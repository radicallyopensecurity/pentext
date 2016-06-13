#!/usr/bin/env python

"""
Gitlab bridge for PenText: imports and updates gitlab issues into PenText
(XML) format

Copyright (C) 2016 Peter Mosmans [Radically Open Security]
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

"""

from __future__ import absolute_import
from __future__ import print_function
from __future__ import unicode_literals

import argparse
import collections
import os
import re
import sys
import textwrap

try:
    import gitlab
    import jxmlease
    # path to docbuilder installation (needs it module)
    sys.path.append('r:/public/docbuilder')
    import validate_report
except ImportError:
    print('[-] This script needs gitlab, jxmlease and validate_report library',
          file=sys.stderr)
    sys.exit(-1)


def add_to_report(report, item, options):
    """
    Adds item to report.
    """
    with open(report, 'r') as xml_file:
        data = xml_file.read()
    report_xml = jxmlease.parse(data)
    report_xml['techSummary']['findings'].add_node(item)


def convert_markdown(text):
    """
    Replace markdown monospace with monospace tags
    """
    result = text
    return result
    print('EXAMINING ' + text + ' END')
    monospace = re.findall("\`\`\`(.*?)\`\`\`", text, re.DOTALL)
    print(monospace)
    if len(monospace):
        print('YESSS ' + monospace)
        result = {}
        result['monospace'] = ''.join(monospace)


def replace_tags(text):
    """
    Replace markdown with correct XML tags
    """
    monospace = False
    linebreaks = re.compile(ur'[\n-\r\x85\u2028\u2929]')
    return linebreaks.split(text)


def list_issues(gitserver, options):
    """
    Lists all issues for options['issues']
    """
    for issue in gitserver.projects.get(options['issues']).issues.list(all=True):
        if issue.state != 'opened' and not options['closed']:
            continue
        if 'finding' in issue.labels:
            add_finding(issue, options)
        if 'non-finding' in issue.labels:
            add_non_finding(issue, options)


def add_finding(issue, options):
    title = validate_report.capitalize(issue.title.strip())
    print_status('{0} - {1} - {2}'.format(issue.state, issue.labels,
                                          title), options)
    threatLevel = 'Moderate'
    finding_type = 'TODO'
    finding_id = '{0}-{1}'.format(issue.iid, valid_filename(title))
    filename = 'findings/{0}.xml'.format(finding_id)
    finding = collections.OrderedDict()
    finding['title'] = title
    finding['description'] = unicode.replace(issue.description,
                                             '\r\n', '\n')
    finding['technicaldescription'] = ''
    for note in [x for x in issue.notes.list() if not x.system]:
        finding['technicaldescription'] += unicode.replace(note.body,
                                                           '\r\n', '\n')
    finding['impact'] = {}
    finding['impact']['p'] = 'TODO'
    finding['recommendation'] = {}
    finding['recommendation']['ul'] = {}
    finding['recommendation']['ul']['li'] = 'TODO'
    finding_xml = jxmlease.XMLDictNode(finding, tag='finding',
                                       xml_attrs={'id': finding_id,
                                                  'threatLevel': threatLevel,
                                                  'type': finding_type})
    if options['dry_run']:
        print_line('[+] {0}'.format(filename))
        print(finding_xml.emit_xml())
    else:
        if os.path.isfile(filename) and not options['overwrite']:
            print_line('Finding {0} already exists (use --overwrite to overwrite)'.
                       format(filename))
        else:
            print_line('Create file {0} ? [y/N]'.format(filename))
            if raw_input().lower() == 'y':
                with open(filename, 'w') as xmlfile:
                    xmlfile.write(finding_xml.emit_xml().encode('utf-8'))
                print_line('[+] Created {0}'.format(filename))


def add_non_finding(issue, options):
    """
    Adds a non-finding.
    """
    title = validate_report.capitalize(issue.title.strip())
    print_status('{0} - {1} - {2}'.format(issue.state, issue.labels,
                                          title), options)
    non_finding_id = '{0}-{1}'.format(issue.iid, valid_filename(title))
    filename = 'non-findings/{0}.xml'.format(non_finding_id)
    non_finding = collections.OrderedDict()
    non_finding['title'] = title
    non_finding['p'] = unicode.replace(issue.description,
                                   '\r\n', '\n')
    for note in [x for x in issue.notes.list() if not x.system]:
        non_finding['p'] += unicode.replace(note.body,
                                        '\r\n', '\n')
    non_finding_xml = jxmlease.XMLDictNode(non_finding, tag='non-finding',
                                           xml_attrs={'id': non_finding_id})
    if options['dry_run']:
        print_line('[+] {0}'.format(filename))
        print(non_finding_xml.emit_xml())
    else:
        if os.path.isfile(filename) and not options['overwrite']:
            print_line('Non-finding {0} already exists (use --overwrite to overwrite)'.
                       format(filename))
        else:
            with open(filename, 'w') as xmlfile:
                xmlfile.write(non_finding_xml.emit_xml().encode('utf-8'))
            print_line('[+] Created {0}'.format(filename))


def list_projects(gitserver, options):
    """
    Lists all available projects.
    """
    for project in gitserver.projects.list(all=True):
        print_line('{0} - {1}'.format(project.as_dict()['id'],
                                      project.as_dict()['path']))


def parse_arguments():
    """
    Parses command line arguments.
    """
    parser = argparse.ArgumentParser(
            formatter_class=argparse.RawDescriptionHelpFormatter,
            description=textwrap.dedent('''\
gitlab-to-pentext - imports and updates gitlab issues into PetText (XML) format

            Copyright (C) 2016  Peter Mosmans [Radically Open Security]]
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.'''))
    parser.add_argument('--closed', action='store',
                        help='take closed issues into account')
    parser.add_argument('--dry-run', action='store_true',
                        help='do not write anything, only output on screen')
    parser.add_argument('--issues', action='store',
                        help='list issues for a given project')
    parser.add_argument('--overwrite', action='store_true',
                        help='overwrite existing issues')
    parser.add_argument('--projects', action='store_true',
                        help='list gitlab projects')
    parser.add_argument('-v', '--verbose', action='store_true',
                        help='increase output verbosity')
    if len(sys.argv) == 1:
        parser.print_help()
    return vars(parser.parse_args())


def preflight_checks(options):
    """
    Checks if all tools are there.
    Exits with 0 if everything went okilydokily
    """
    try:
        gitserver = gitlab.Gitlab.from_config('remote')
        gitserver.auth()
    except gitlab.config.GitlabDataError as e:
        print_error('could not connect {0}'.format(e), -1)
    return gitserver


def print_error(text, result=False):
    """
    Prints error message.
    When @result, exits with result.
    """
    if len(text):
        print_line('[-] ' + text, True)
    if result:
        sys.exit(result)


def print_line(text, error=False):
    """
    Prints text, and flushes stdout and stdin.
    When @error, prints text to stderr instead of stdout.
    """
    if not error:
        print(text)
    else:
        print(text, file=sys.stderr)
    sys.stdout.flush()
    sys.stderr.flush()


def print_status(text, options=False):
    """
    Prints status message if options array is given and contains 'verbose'.
    """
    if options and options['verbose']:
        print_line('[*] ' + str(text))


def valid_filename(filename):
    """
    Return a valid filename.
    """
    valid_filename = ''
    for char in filename.strip():
        if char in [':', '/', '.', '\\', ' ', '[', ']', '(', ')', '\'']:
            if len(char) and valid_filename[-1] != '-':
                valid_filename += '-'
        else:
            valid_filename += char
    if len(valid_filename) and valid_filename[-1:] == '-':
        valid_filename = valid_filename[:-1]
    return valid_filename.lower()


def main():
    """
    The main program.
    """
    options = parse_arguments()
    gitserver = preflight_checks(options)
    if options['projects']:
        list_projects(gitserver, options)
    if options['issues']:
        list_issues(gitserver, options)


if __name__ == "__main__":
    main()
