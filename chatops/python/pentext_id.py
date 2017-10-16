#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
pentext_id - Identify findings from report

This script is part of the PenText framework
                           https://pentext.org

   Copyright (C)      2017 Radically Open Security
                           https://www.radicallyopensecurity.com

                   Author: Peter Mosmans

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.
"""


from __future__ import absolute_import
from __future__ import print_function
from __future__ import unicode_literals

import argparse
import logging
import os
import sys
import textwrap

try:
    from lxml import etree
except ImportError as exception:
    print('[-] This script needs lxml',
          file=sys.stderr)
    print("Install lxml with: sudo pip install lxml", file=sys.stderr)
    sys.exit(-1)


VERSION = '0.2.0'


class LogFormatter(logging.Formatter):
    """
    Class to format log messages based on their type.
    """
    FORMATS = {logging.DEBUG: "[d] %(message)s",
               logging.INFO: "[*] %(message)s",
               logging.ERROR: "[-] %(message)s",
               logging.CRITICAL: "[-] FATAL: %(message)s",
               'DEFAULT': "%(message)s"}

    def format(self, record):
        self._fmt = self.FORMATS.get(record.levelno, self.FORMATS['DEFAULT'])
        return logging.Formatter.format(self, record)


def parse_arguments(banner):
    """
    Parse and return command line arguments.
    """
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=textwrap.dedent(banner + '''\
pentext_id - Identify findings based on their unique id, filename, or location
in the report

Copyright (C) 2017 Peter Mosmans [Radically Open Security]

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.'''))
    parser.add_argument('target', nargs='?', type=str,
                        help="""[PARAMETER] can be TODO""")
    parser.add_argument('--debug', action='store_true',
                        help='Show debug information')
    parser.add_argument('-v', '--verbose', action='store_true',
                        help='Be more verbose')
    parser.add_argument('--finding', action='store', type=int,
                        help='Convert finding filename ID to finding ID')
    parser.add_argument('--id', action='store', type=int,
                        help='Show filename of a finding ID')
    parser.add_argument('--source', action='store',
                        default='source/report.xml',
                        help='Set source file (default: source/report.xml)')
    args = parser.parse_args()
    return args


def setup_logging(args):
    """
    Set up loghandlers according to options.
    """
    logger = logging.getLogger()
    logger.setLevel(0)
    console = logging.StreamHandler(stream=sys.stdout)
    console.setFormatter(LogFormatter())
    if args.debug:
        console.setLevel(logging.DEBUG)
    elif args.verbose:
        console.setLevel(logging.INFO)
    else:
        console.setLevel(logging.ERROR)
    logger.addHandler(console)


def locate_finding(findings, args):
    """
    Show id corresponding to a finding.
    """
    try:
        for i, href in enumerate(findings, start=1):
            if 'findings/f{0}-'.format(args.finding) in href or \
               'findings/{0}-'.format(args.finding) in href:
                print("{0:2d} {1}".format(i, href))
    except IndexError:
        logging.error('Finding %s could not be located', args.id)


def locate_id(findings, args):
    """
    Show finding corresponding to an identifier
    """
    try:
        print("{0:2d} {1}".format(args.id, findings[args.id-1]))
    except IndexError:
        logging.error('Finding %s could not be located', args.id)


def main():
    """
    Main program loop.
    """
    banner = 'pentext_id version {0}'.format(VERSION)
    args = parse_arguments(banner)
    setup_logging(args)
    logging.info('%s starting', banner)
    # read document
    filename = args.source
    if not os.path.isfile(filename):
        logging.error('Could not open %s', filename)
        sys.exit(-1)
    findings = []
    try:
        # Parse document into an ElementTree
        tree = etree.parse(filename, etree.XMLParser(strip_cdata=False))
        # Read finding code
        code = tree.getroot().attrib['findingCode']
        # Grab all elements from the findings section
        for elements in tree.xpath('//section[@id="findings"]'):
            # Iterate through all elements, looking for the findings
            for element in elements:
                if 'href' in element.attrib:
                    findings.append(element.attrib['href'])
    except (etree.ParseError, IOError) as exception:
        logging.warning('Validating %s failed: %s', filename, exception)
    if args.id:
        locate_id(findings, args)
    elif args.finding:
        locate_finding(findings, args)
    else:
        for i, href in enumerate(findings, start=1):
            print("{0}-{1:02d} {2}".format(code, i, href))


if __name__ == "__main__":
    main()
