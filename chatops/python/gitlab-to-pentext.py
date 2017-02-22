#!/usr/bin/env python

"""
Gitlab bridge for PenText: imports and updates gitlab issues into PenText
(XML) format

This script is part of the PenText framework
                           https://pentext.org

   Copyright (C) 2016-2017 Radically Open Security
                           https://www.radicallyopensecurity.com

                Author(s): Peter Mosmans

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

"""

from __future__ import absolute_import
from __future__ import print_function
from __future__ import unicode_literals

import argparse
import os
import sys
import textwrap

try:
    import gitlab
    import pypandoc
    # Path of this script. The validate_report module is on the same path.
    sys.path.append(os.path.dirname(__file__))
    import validate_report
except ImportError as exception:
    print('[-] This script needs python-gitlab, pypandoc and validate_report library',
          file=sys.stderr)
    print("validate_report is part of the pentext framework", file=sys.stderr)
    print("Install python-gitlab with: sudo pip install python-gitlab", file=sys.stderr)
    print("Install pypandoc with: sudo pip install pypandoc\n", file=sys.stderr)
    print("Currently missing: " + exception.message, file=sys.stderr)
    sys.exit(-1)

DECLARATION = '<?xml version="1.0" encoding="utf-8"?>\n'
    
def add_finding(issue, options):
    """
    Writes issue as XML finding to file.
    """
    title = validate_report.capitalize(issue.title.strip())
    print_status('{0} - {1} - {2}'.format(issue.state, issue.labels,
                                          title), options)
    threat_level = 'Moderate'
    finding_type = 'TODO'
    finding_id = 'f{0}-{1}'.format(issue.iid, valid_filename(title))
    filename = 'findings/{0}.xml'.format(finding_id)
    finding = u'<title>{0}</title>\n'.format(title)
    finding += '<description>{0}\n</description>\n'.format(convert_text(issue.description))
    impact = 'TODO'
    recommendation = '<ul>\n<li>\nTODO\n</li>\n</ul>\n';
    technical_description = ''
    for note in [x for x in reversed(issue.notes.list()) if not x.system]:
        if len(note.body.splitlines()):
            if 'impact' in note.body.split()[0].lower():
                impact = convert_text(''.join(note.body.splitlines(True)[1:]))
            elif 'recommendation' in note.body.split()[0].lower():
                recommendation = convert_text(''.join(note.body.splitlines(True)[1:]))
            else:
                technical_description += u'{0}\n'.format(convert_text(note.body))
    finding += '<technicaldescription>\n{0}\n</technicaldescription>\n\n'.format(technical_description)
    finding += '<impact>\n{0}\n</impact>\n\n'.format(impact)
    finding += '<recommendation>\n{0}\n</recommendation>\n\n'.format(recommendation)
    finding = u'{0}<finding id="{1}" threatLevel="{2}" type="{3}">\n{4}</finding>'.format(DECLARATION,
                                                                                            finding_id,
                                                                                            threat_level,
                                                                                            finding_type,
                                                                                            finding)
    if options['dry_run']:
        print_line('[+] {0}\n{1}'.format(filename, finding))
    else:
        if os.path.isfile(filename) and not options['overwrite']:
            print_line('Finding {0} already exists (use --overwrite to overwrite)'.
                       format(filename))
        else:
            if options['y'] or ask_permission('Create file ' + filename):
                with open(filename, 'w') as xmlfile:
                    xmlfile.write(finding)
                    print_line('[+] Created {0}'.format(filename))


def convert_text(text):
    """
    Convert (gitlab) markdown to 'XML' (actually HTML5).
    """
    return unicode.replace(pypandoc.convert_text(text, 'html5', format='markdown_github'), '\r\n', '\n')


def add_non_finding(issue, options):
    """
    Adds a non-finding.
    """
    title = validate_report.capitalize(issue.title.strip())
    print_status('{0} - {1} - {2}'.format(issue.state, issue.labels,
                                          title), options)
    non_finding_id = 'nf{0}-{1}'.format(issue.iid, valid_filename(title))
    filename = 'non-findings/{0}.xml'.format(non_finding_id)
    non_finding = u'<title>{0}</title>\n{1}\n'.format(title,
                                                      convert_text(issue.description))
    for note in [x for x in reversed(issue.notes.list()) if not x.system]:
        non_finding += u'<p>{0}</p>\n'.format(convert_text(note.body))
    non_finding = u'{0}<non-finding id="{1}">\n{2}\n</non-finding>\n'.format(DECLARATION,
                                                                             non_finding_id,
                                                                             non_finding)
    if options['dry_run']:
        print_line('[+] {0}\n{1}'.format(filename, non_finding))
    else:
        if os.path.isfile(filename) and not options['overwrite']:
            print_line('Non-finding {0} already exists (use --overwrite to overwrite)'.
                       format(filename))
        else:
            if options['y'] or ask_permission('Create file ' + filename):
                with open(filename, 'w') as xmlfile:
                    xmlfile.write(non_finding)
                    print_line('[+] Created {0}'.format(filename))


def ask_permission(question):
    """
    Ask question and return True if user answered with y.
    """
    print_line('{0} ? [y/N]'.format(question))
    return raw_input().lower() == 'y'


def list_issues(gitserver, options):
    """
    Lists all issues for options['issues']
    """
    try:
        for issue in gitserver.project_issues.list(project_id=options['issues'],
                                                   per_page=999):
            if issue.state == 'closed' and not options['closed']:
                continue
            if 'finding' in [x.lower() for x in issue.labels]:
                add_finding(issue, options)
            if 'non-finding' in [x.lower() for x in issue.labels]:
                add_non_finding(issue, options)
    except Exception as exception:
        print_error('could not find any issues ({0})'.format(exception), -1)


def list_projects(gitserver):
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
gitlab-to-pentext - imports and updates gitlab issues into PenText (XML) format

Copyright (C) 2015-2017  Radically Open Security (Peter Mosmans)

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
    parser.add_argument('-y', action='store_true',
                        help='assume yes on all questions, write findings')
    if len(sys.argv) == 1:
        parser.print_help()
    return vars(parser.parse_args())


def preflight_checks():
    """
    Checks if all tools are there.
    Exits with 0 if everything went okilydokily.
    """
    gitserver = None
    try:
        gitserver = gitlab.Gitlab.from_config('remote')
        gitserver.auth()
    except gitlab.config.GitlabDataError as exception:
        print_error('could not connect {0}'.format(exception), -1)
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
    result = ''
    for char in filename.strip():
        if char in ['*', ':', '/', '.', '\\', ' ', '[', ']', '(', ')', '\'']:
            if len(char) and not result.endswith('-'):
                result += '-'
        else:
            result += char
    return result.lower()


def main():
    """
    The main program.
    """
    options = parse_arguments()
    gitserver = preflight_checks()
    if options['projects']:
        list_projects(gitserver)
    if options['issues']:
        list_issues(gitserver, options)


if __name__ == "__main__":
    main()
