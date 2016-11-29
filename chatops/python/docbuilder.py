#!/usr/bin/env python

"""
Builds PDF files from (intermediate fo and) XML files.

This script is part of the PenText framework
                           https://pentext.org

   Copyright (C) 2015-2016 Radically Open Security
                           https://www.radicallyopensecurity.com

                Author(s): Peter Mosmans

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

"""

from __future__ import absolute_import
from __future__ import print_function

import argparse
import os
import subprocess
from subprocess import PIPE
import sys
import textwrap


GITREV = 'GITREV'  # Magic tag which gets replaced by the git short commit hash
OFFERTE = 'generate_offerte.xsl'  # XSL for generating waivers
WAIVER = 'waiver_'  # prefix for waivers


def parse_arguments():
    """
    Parses command line arguments.
    """
    global verboseprint
    global verboseerror
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=textwrap.dedent('''\
Builds PDF files from (intermediate fo and) XML files.

Copyright (C) 2015-2016  Radically Open Security (Peter Mosmans)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.'''))
    parser.add_argument('-c', '--clobber', action='store_true',
                        help='overwrite output file if it already exists')
    parser.add_argument('-date', action='store',
                        help='the invoice date')
    parser.add_argument('-execsummary', action='store',
                        help="""create an executive summary as well as a report. 
                        Default: no """)
    parser.add_argument('--fop-config', action='store',
                        default='/etc/docbuilder/rosfop.xconf',
                        help="""fop configuration file (default
                        /etc/docbuilder/rosfop.xconf""")
    parser.add_argument('-f', '--fop', action='store',
                        default='../target/report.fo',
                        help="""intermediate fop output file (default:
                        ../target/report.fo)""")
    parser.add_argument('--fop-binary', action='store',
                        default='/usr/local/bin/fop',
                        help='fop binary (default /usr/local/bin/fop')
    parser.add_argument('-i', '--input', action='store',
                        default='report.xml',
                        help="""input file (default: report.xml)""")
    parser.add_argument('-invoice', action='store',
                        help="""invoice number""")
    parser.add_argument('--saxon', action='store',
                        default='/usr/local/bin/saxon/saxon9he.jar',
                        help="""saxon JAR file (default
                        /usr/local/bin/saxon/saxon9he.jar)""")
    parser.add_argument('-x', '--xslt', action='store',
                        default='../xslt/generate_report.xsl',
                        help='input file (default: ../xslt/generate_report.xsl)')
    parser.add_argument('-o', '--output', action='store',
                        default='../target/report-latest.pdf',
                        help="""output file name (default:
                        ../target/report-latest.pdf""")
    parser.add_argument('-v', '--verbose', action='store_true',
                        help='increase output verbosity')
    parser.add_argument('-w', '--warnings', action='store_true',
                        help='show warnings')
    args = parser.parse_args()
    if args.verbose:
        def verboseprint(*args):  # pylint: disable=missing-docstring
            for arg in args:
                print(arg, end="")
            print()

        def verboseerror(*args):  # pylint: disable=missing-docstring
            for arg in args:
                print(arg, end="", file=sys.stderr)
            print(file=sys.stderr)
    else:
        verboseprint = lambda *a: None
        verboseerror = lambda *a: None
    return vars(parser.parse_args())


def print_output(stdout, stderr):
    """
    Prints out standard out and standard err using the verboseprint function.
    """
    if stdout:
        verboseprint('[+] stdout: {0}'.format(stdout))
    if stderr:
        verboseerror('[-] stderr: {0}'.format(stderr))


def change_tag(fop):
    """
    Replaces GITREV in document by git commit shorttag.
    """
    cmd = ['git', 'log', '--pretty=format:%h', '-n', '1']
    process = subprocess.Popen(cmd, stdout=subprocess.PIPE)
    shorttag, _stderr = process.communicate()
    if not process.returncode:
        fop_file = open(fop).read()
        if GITREV in fop_file:
            fop_file = fop_file.replace(GITREV, shorttag)
            with open(fop, 'w') as new_file:
                new_file.write(fop_file)
            print('[+] Embedding git version information into document')


def to_fo(options):
    """
    Creates a fo output file based on a XML file.
    Returns True if successful
    """
    cmd = ['java', '-jar', options['saxon'],
           '-s:' + options['input'], '-xsl:' + options['xslt'],
           '-o:' + options['fop'], '-xi']
    if options['invoice']:
        cmd.append('INVOICE_NO=' + options['invoice'])
    if options['date']:
        cmd.append('DATE=' + options['date'])
    if options['execsummary']:
        cmd.append('EXEC_SUMMARY=' + options['execsummary'])
    process = subprocess.Popen(cmd, stdout=PIPE, stderr=PIPE)
    stdout, stderr = process.communicate()
    print_output(stdout, stderr)
    if process.returncode:
        print_exit('[-] Error creating fo file from XML input',
                   process.returncode)
    else:
        change_tag(options['fop'])
    return True


def to_pdf(options):
    """
    Creates a PDF file based on a fo file.
    Returns True if successful
    """
    cmd = [options['fop_binary'], '-c', options['fop_config'], options['fop'],
           options['output']]
    try:
        verboseprint('Converting {0} to {1}'.format(options['fop'],
                                                    options['output']))
        process = subprocess.Popen(cmd, stdout=PIPE, stderr=PIPE)
        stdout, stderr = process.communicate()
        result = process.returncode
        print_output(stdout, stderr)
        if result == 0:
            print('[+] Succesfully built ' + options['output'])
    except OSError as exception:
        print_exit('[-] ERR: {0}'.format(exception.strerror), exception.errno)
    return result == 0


def print_exit(text, result):
    """
    Prints error message and exits with result code.
    """
    print(text, file=sys.stderr)
    sys.exit(result)


def main():
    """
    The main program.
    """
    global verboseerror
    global verboseprint
    result = False
    options = parse_arguments()
    if not os.path.isfile(options['input']):
        print_exit('[-] Cannot find input file {0}'.
                   format(options['input']), result)
    try:
        if os.path.isfile(options['output']):
            if not options['clobber']:
                print_exit('[-] Output file {0} already exists. '.
                           format(options['output']) +
                           'Use -c (clobber) to overwrite',
                           result)
            os.remove(options['output'])
    except OSError as exception:
        print_exit('[-] Could not remove/overwrite file {0} ({1})'.
                   format(options['output'], exception.strerror), result)
    result = to_fo(options)
    if result:
        if OFFERTE in options['xslt']:  # an offerte can generate multiple fo's
            report_output = options['output']
            verboseprint('generating separate waivers detected')
            output_dir = os.path.dirname(options['output'])
            fop_dir = os.path.dirname(options['fop'])
            try:
                for fop in [os.path.splitext(x)[0] for x in
                            os.listdir(fop_dir) if x.endswith('fo')]:
                    if WAIVER in fop:
                        options['output'] = output_dir + os.sep + fop + '.pdf'
                    else:
                        options['output'] = report_output
                    options['fop'] = fop_dir + os.sep + fop + '.fo'
                    result = to_pdf(options) and result
            except OSError as exception:
                print_exit('[-] ERR: {0}'.format(exception.strerror),
                           exception.errno)
        else:
            result = to_pdf(options)

    else:
        print_exit('[-] Unsuccessful (error {0})'.format(result), result)
    sys.exit(not result)


if __name__ == "__main__":
    main()
