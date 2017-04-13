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
import io
import os
import sys
import textwrap

try:
    import gitlab
    import pypandoc
    # Path of this script. The validate_report module is on the same path.
    sys.path.append(os.path.dirname(__file__))
    import validate_report
except (NameError, ImportError) as exception:
    print('[-] This script needs python-gitlab, pypandoc and validate_report library',
          file=sys.stderr)
    print("validate_report is part of the pentext framework", file=sys.stderr)
    print("Install python-gitlab with: sudo pip install python-gitlab", file=sys.stderr)
    print("Install pypandoc with: sudo pip install pypandoc\n", file=sys.stderr)
    print("Currently missing: " + exception.message, file=sys.stderr)
    sys.exit(-1)


class BaseItem(object):
    """
    Base class for Pentext items
    """

    DECLARATION = '<?xml version="1.0" encoding="utf-8"?>\n'

    def __init__(self, item_type):
        if item_type not in ('finding', 'non-finding'):
            raise ValueError('Only finding and non-finding are currently supported')
        self.item_type = item_type
        self.__path = '{0}s'.format(self.item_type)
        self.root_open = '<{0}>\n'.format(self.item_type)
        self.root_close = '</{0}>\n'.format(self.item_type)
        self.title = ''
        self.content = ''

    @property
    def filename(self):
        """
        Filename.
        """
        return '{0}/{1}.xml'.format(self.__path, valid_filename(self.identifier))

    def __str__(self):
        """
        Return a XML version of the class
        """
        return self.DECLARATION + self.root_open + self.element('title') + \
            self.content + self.root_close

    def element(self, attribute):
        """
        Return opening and closing attribute tags, including attribute value.
        """
        return '<{0}>{1}</{0}>\n'.format(attribute, getattr(self, attribute))

    def write_file(self):
        """
        Write item as XML to file.
        """
        try:
            with io.open(self.filename, 'w') as xmlfile:
                xmlfile.write(unicode(self))
                print_line('[+] Wrote {0}'.format(self.filename))
        except IOError:
            print_error('Could not write to %s', self.filename)


class Finding(BaseItem):
    """
    Encapsulates finding.
    """

    def __init__(self):
        BaseItem.__init__(self, 'finding')
        self.threat_level = 'Moderate'
        self.finding_type = 'TODO'
        self.description = '<p>TODO</p>'
        self.technicaldescription = '<p>TODO</p>'
        self.impact = '<p>TODO</p>'
        self.recommendation = '<ul><li>TODO</li></ul>'

    def __str__(self):
        """
        Return a XML version of the class
        """
        self.root_open = '<finding id="{0}" threatLevel="{1}" type="{2}">\n'.format(self.identifier,
                                                                                    self.threat_level,
                                                                                    self.finding_type)
        self.content = self.element('description') + \
                       self.element('technicaldescription') + \
                       self.element('impact') + \
                       self.element('recommendation')
        return BaseItem.__str__(self)


class NonFinding(BaseItem):
    """
    Encapsulates non-finding.
    """

    def __init__(self):
        BaseItem.__init__(self, 'non-finding')


def from_issue(issue):
    """
    Parse gitlab issue and return Finding, NonFinding or None
    """
    if 'finding' in [x.lower() for x in issue.labels]:
        item = Finding()
        item.description = convert_text(issue.description)
        for note in [x for x in reversed(issue.notes.list()) if not x.system]:
            if len(note.body.splitlines()):
                if 'impact' in note.body.split()[0].lower():
                    item.impact = convert_text(''.join(note.body.splitlines(True)[1:]))
                elif 'recommendation' in note.body.split()[0].lower():
                    item.recommendation = convert_text(''.join(note.body.splitlines(True)[1:]))
                else:
                    item.technicaldescription += u'{0}\n'.format(convert_text(note.body))
    elif 'non-finding' in [x.lower() for x in issue.labels]:
        item = NonFinding()
        for note in [x for x in reversed(issue.notes.list()) if not x.system]:
            item.content += convert_text(note.body) + '\n'
    else:
        return None
    item.title = validate_report.capitalize(issue.title.strip())
    item.identifier = 'f{0}-{1}'.format(issue.iid, valid_filename(item.title))
    return item


def add_item(issue, options):
    """
    Convert issue into XML finding and create file.
    """
    item = from_issue(issue)
    if not item:
        return
    if os.path.isfile(item.filename) and not options['overwrite']:
        print_line('{0} {1} already exists (use --overwrite to overwrite)'.
                   format(item.item_type, item.filename))
        return
    if options['dry_run']:
        print_line('[+] {0}\n{1}'.format(item.filename, item))
    else:
        if options['y'] or ask_permission('Create file ' + item.filename):
            item.write_file()


def convert_text(text):
    """
    Convert (gitlab) markdown to 'XML' (actually HTML5).
    """
    return unicode.replace(pypandoc.convert_text(text, 'html5', format='markdown_github'), '\r\n', '\n')


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
    for issue in gitserver.project_issues.list(project_id=options['issues'],
                                               per_page=999):
        if issue.state == 'closed' and not options['closed']:
            continue
        add_item(issue, options)


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
    for path in ('findings', 'non-findings'):
        if not os.path.isdir(path):
            print_error('Path {0} does not exist: Is this a Pentext repository ?'.format(path), -1)
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
        if char in ['*', ':', '/', '.', '\\', ' ', '[', ']', '(', ')', '\'', '\"']:
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
