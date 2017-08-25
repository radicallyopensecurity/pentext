#!/usr/bin/env python

"""
Cross-checks findings, validates XML files, offerte and report files.

This script is part of the PenText framework
                           https://pentext.org

   Copyright (C) 2015-2017 Radically Open Security
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
import mmap
import os
import re
import subprocess
import sys
import textwrap
import xml.sax


try:
    from lxml import etree as ElementTree
    from titlecase import titlecase
    import enchant
except ImportError as exception:
    print('[-] This script needs the lxml, pyenchant and titlecase libary ({0}'.format(exception),
          file=sys.stderr)
    print("    Install requirements using pip install -r requirements.txt",
          file=sys.stderr)
    sys.exit(-1)


# When set to True, the report will be validated using docbuilder
DOCBUILDER = False
UPPERCASE = ['TCP', 'UDP', 'XSS']
VOCABULARY = 'project-vocabulary.txt'
# Snippets may contain XML fragments without the proper entities
EXAMPLEDIR = 'examples/'
SNIPPETDIR = 'snippets/'
STATUS = 25  # loglevel for 'generic' status messages
TEMPLATEDIR = 'templates/'
OFFERTE = '/offerte.xml'
REPORT = '/report.xml'
WARN_LINE = 80  # There should be a separation character after x characters...
MAX_LINE = 86  # ... and before y


class LogFormatter(logging.Formatter):
    """
    Format log messages according to their type.
    """
    # DEBUG   = (10) debug status messages
    # INFO    = (20) verbose status messages
    # STATUS  = (25) generic status messages
    # WARNING = (30) warning messages (= errors in validation)
    # ERROR   = (40) error messages (= program errors)
    FORMATS = {logging.DEBUG: "DEBUG: %(module)s: %(lineno)d: %(message)s",
               logging.INFO: "[*] %(message)s",
               STATUS: "[+] %(message)s",
               logging.WARN: "[-] %(message)s",
               logging.ERROR: "ERROR: %(message)s",
               'DEFAULT': "%(message)s"}

    def format(self, record):
        self._fmt = self.FORMATS.get(record.levelno, self.FORMATS['DEFAULT'])
        return logging.Formatter.format(self, record)


def parse_arguments():
    """
    Parses command line arguments.
    """
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=textwrap.dedent('''\
validate_report - validates offer letters and reports

Copyright (C) 2015-2017  Radically Open Security (Peter Mosmans)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.'''))
    parser.add_argument('-a', '--all', action='store_true',
                        help='Perform all checks')
    parser.add_argument('--auto-fix', action='store_true',
                        help='Try to automatically correct issues')
    parser.add_argument('-c', '--capitalization', action='store_true',
                        help='Check capitalization')
    parser.add_argument('--debug', action='store_true',
                        help='Show debug information')
    parser.add_argument('--edit', action='store_true',
                        help='Open files with issues using an editor')
    parser.add_argument('--learn', action='store_true',
                        help='Store all unknown words in dictionary file')
    parser.add_argument('--long', action='store_true',
                        help='Check for long lines')
    parser.add_argument('--offer', action='store_true',
                        help='Validate offer master file')
    parser.add_argument('--spelling', action='store_true',
                        help='Check spelling')
    parser.add_argument('-v', '--verbose', action='store_true',
                        help='increase output verbosity')
    parser.add_argument('--no-report', action='store_true',
                        help='Do not validate report master file')
    parser.add_argument('--quiet', action='store_true',
                        help='Don\'t output status messages')
    return vars(parser.parse_args())


def validate_spelling(tree, filename, options):
    """
    Check spelling of text within tags.
    If options['learn'], then unknown words will be added to the dictionary.
    """
    result = True
    learn = []
    speller = enchant.DictWithPWL("en_US", VOCABULARY)
    if not speller:
        options['spelling'] = False
        return result
    try:
        root = tree.getroot()
        for section in root.iter():
            if section.text and isinstance(section.tag, basestring) and \
               section.tag not in ('a', 'code', 'monospace', 'pre'):
                for word in re.findall('([a-zA-Z]+\'?[a-zA-Z]+)', section.text):
                    if not speller.check(word):
                        if word.upper() not in (learned.upper() for learned in learn):
                            learn.append(word)
                        result = False
                        logging.warning('Misspelled (unknown) word %s in %s',
                                        word.encode('utf-8'), filename)
    except:
        print('[-] Hmm. spell exception')
    if options['learn'] and learn:
        try:
            with open(VOCABULARY, mode='a+') as open_file:
                for word in learn:
                    open_file.write(word + '\n')
        except IOError:
            logging.error('Could not write to %s', open_file)
    return result


def all_files():
    """
    Returns a list of all files contained in the git repository.
    """
    cmd = ['git', 'ls-files']
    process = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE)
    return process.stdout.read().splitlines()


def open_editor(filename):
    """
    Open editor with file to edit.
    """
    if sys.platform in ('linux', 'linux2'):
        editor = os.getenv('EDITOR')
        if editor:
            print('{0} {1}'.format(editor, filename))
            sys.stdout.flush()
            subprocess.call([editor, '"{0}"'.format(filename)], shell=True)
        else:
            subprocess.call('xdg-open', filename)
    elif sys.platform == "darwin":
        subprocess.call(['open', filename])
    elif sys.platform == "win32":
        os.system('"{0}"'.format(filename.replace('/', os.path.sep)))


def validate_files(filenames, options):
    """
    Check file extensions and calls appropriate validator function.
    Returns True if all files validated successfully.
    """
    result = True
    masters = []
    findings = []
    non_findings = []
    scans = []
    for filename in filenames:
        if (filename.lower().endswith('.xml') or
                filename.lower().endswith('xml"')):
            if SNIPPETDIR not in filename and TEMPLATEDIR not in filename:
                if (OFFERTE in filename and options['offer']) or \
                   (REPORT in filename and not options['no_report']):
                    masters.append(filename)
                type_result, xml_type = validate_xml(filename, options)
                result = result and type_result
                if 'non-finding' in xml_type:
                    non_findings.append(filename)
                else:
                    if 'finding' in xml_type:
                        findings.append(filename)
                    else:
                        if 'scans' in xml_type:
                            scans.append(filename)
    for master in masters:
        result = validate_master(
            master, findings, non_findings, scans, options) and result
    return result


def validate_report():
    """
    Validates XML report file by trying to build it.
    Returns True if the report was built successful.
    """
    host, command = docbuilder_proxy.read_config(docbuilder_proxy.CONFIG_FILE)
    command = command + ' -c'
    return proxy_vagrant.execute_command(host, command)


def validate_xml(filename, options):
    """
    Validates XML file by trying to parse it.
    Returns True if the file validated successfully.
    """
    result = True
    xml_type = ''
    # crude check whether the file is outside the pentext framework
    if 'notes' in filename:
        return result, xml_type
    logging.info('Validating XML file: %s', filename)
    try:
        with open(filename, 'rb') as xml_file:
            xml.sax.parse(xml_file, xml.sax.ContentHandler())
            tree = ElementTree.parse(
                filename, ElementTree.XMLParser(strip_cdata=False))
            tree.xinclude()  # Include everything
            type_result, xml_type = validate_type(tree, filename, options)
            result = validate_long_lines(
                tree, filename, options) and result and type_result
        if options['edit'] and not result:
            open_editor(filename)
    except (xml.sax.SAXException, ElementTree.ParseError) as exception:
        print('[-] validating {0} failed ({1})'.format(filename, exception))
        result = False
    except IOError as exception:
        print('[-] validating {0} failed ({1})'.format(filename, exception))
        result = False
    return result, xml_type


def get_all_text(node):
    """
    Retrieves all text within tags.
    """
    text_string = node.text or ''
    for element in node:
        text_string += get_all_text(element)
    if node.tail:
        text_string += node.tail
    return text_string.strip()


def abbreviations(word, **kwargs):
    """
    Check whether word needs to be all caps
    """
    if word.upper() in (UPPERCASE):
        return word.upper()


def capitalize(sentence):
    """
    Return capitalized version of @sentence
    """
    return titlecase(sentence, callback=abbreviations)


def is_capitalized(line):
    """
    Checks whether all words in @line start with a capital.

    Returns True if that's the case.
    """
    return not line or line.strip() == titlecase(line, callback=abbreviations).strip()


def validate_type(tree, filename, options):
    """
    Performs specific checks based on type.
    Currently only finding and non-finding are supported.
    """
    result = True
    fix = False
    root = tree.getroot()
    xml_type = root.tag
    attributes = []
    tags = []
    if options['spelling']:
        result = validate_spelling(tree, filename, options)
    if xml_type == 'pentest_report':
        attributes = ['findingCode']
    if xml_type == 'finding':
        attributes = ['threatLevel', 'type', 'id']
        tags = ['title', 'description', 'technicaldescription', 'impact',
                'recommendation']
    if xml_type == 'non-finding':
        attributes = ['id']
        tags = ['title']
    if not len(attributes):
        return result, xml_type

    for attribute in attributes:
        if attribute not in root.attrib:
            print('[A] Missing obligatory attribute in {0}: {1}'.
                  format(filename, attribute))
            if attribute == 'id':
                root.set(attribute, filename)
                fix = True
            else:
                result = False
        else:
            if attribute == 'threatLevel' and root.attrib[attribute] not in \
               ('Low', 'Moderate', 'Elevated', 'High', 'Extreme'):
                print('[-] threatLevel is not Low, Moderate, High, Elevated or Extreme: {0} {1}'.
                      format(filename, root.attrib[attribute]))
                result = False
            if attribute == 'type' and (options['capitalization'] and not
                                        is_capitalized(root.attrib[attribute])):
                print('[A] Type missing capitalization (expected {0}, read {1})'.
                      format(capitalize(root.attrib[attribute]),
                             root.attrib[attribute]))
                root.attrib[attribute] = titlecase(
                    root.attrib[attribute], callback=abbreviations)
                fix = True
    for tag in tags:
        if root.find(tag) is None:
            logging.warning('Missing tag in %s: %s', filename, tag)
            result = False
            continue
        if not get_all_text(root.find(tag)):
            logging.warning('Empty tag in %s: %s', filename, tag)
            result = False
            continue
        if tag == 'title' and (options['capitalization'] and
                               not is_capitalized(root.find(tag).text)):
            print('[A] Title missing capitalization in {0} (expected {1}, read {2})'.
                  format(filename, titlecase(root.find(tag).text, callback=abbreviations).strip(),
                         root.find(tag).text.strip()))
            root.find(tag).text = titlecase(
                root.find(tag).text, callback=abbreviations)
            fix = True
        all_text = get_all_text(root.find(tag))
        if tag == 'description' and all_text.strip()[-1] != '.':
            print('[A] Description missing final dot in {0}: {1}'.format(
                filename, all_text))
            root.find(tag).text = all_text.strip() + '.'
            fix = True
    if fix:
        if options['auto_fix']:
            print('[+] Automatically fixed {0}'.format(filename))
            tree.write(filename)
        else:
            print('[+] NOTE: Items with [A] can be fixed automatically, use --auto-fix')
    return (result and not fix), xml_type


def validate_long_lines(tree, filename, options):
    """
    Checks whether pre or code section contains lines longer than MAX_LINE characters
    Returns True if the file validated successfully.
    """
    if not options['long']:
        return True
    result = True
    fix = False
    root = tree.getroot()
    for pre_section in [j for section in ('pre', 'code') for j in root.iter(section)]:
        if pre_section.text:
            fixed_text = ''
            for line in pre_section.text.splitlines():
                while len(line) > MAX_LINE:
                    result = False
                    print('[-] {0} Line inside {1} too long: {2}'.
                          format(filename, section, line.encode('utf-8')[MAX_LINE:]))
                    cutpoint = MAX_LINE
                    for split in [' ', '"', '\'', '=', '-', ';']:
                        if split in line.encode('utf-8')[WARN_LINE:MAX_LINE]:
                            cutpoint = line.find(split, WARN_LINE, MAX_LINE)
                    fix = True
                    fixed_line = line[:cutpoint] + '\n'
                    print('cutted line {0}'.format(line))
                    line = line[cutpoint:]
                    fixed_text += fixed_line.encode('utf-8')
                    print('[A] can be fixed (breaking at {0}): {1}'.format(
                        cutpoint, fixed_line))
                fixed_text += line + '\n'
            if fix and options['auto_fix']:
                print('[+] Automatically fixed {0}'.format(filename))
                pre_section.text = fixed_text
                print(fixed_text)
                tree.write(filename)
                close_file(filename)
    return result


def validate_master(filename, findings, non_findings, scans, options):
    """
    Validate master file.
    Returns True if master file was successfully validated.
    """
    result = True
    include_findings = []
    include_nonfindings = []
    logging.info('Validating master file %s', filename)
    try:
        xmltree = ElementTree.parse(filename,
                                    ElementTree.XMLParser(strip_cdata=False))
        xmltree.xinclude()  # include all stuff
        if not find_keyword(xmltree, 'TODO', filename):
            print('[-] Keyword checks failed for {0}'.format(filename))
            result = False
        logging.info(
            'Performing cross check on findings, non-findings and scans...')
        for finding in findings:
            if not cross_check_file(filename, finding):
                print('[A] Cross check failed for finding {0}'.format(finding))
                include_findings.append(finding)
                result = False
        for non_finding in non_findings:
            if not cross_check_file(filename, non_finding):
                logging.warning(
                    'Cross check failed for non-finding %s', non_finding)
                include_nonfindings.append(non_finding)
                result = False
        if result:
            logging.info('Cross checks successful')
    except (ElementTree.ParseError, IOError) as exception:
        logging.warning('Validating %s failed: %s', filename, exception)
        result = False
    if not result:
        if options['auto_fix']:
            add_include(filename, 'findings', include_findings)
            add_include(filename, 'nonFindings', include_nonfindings)
            close_file(filename)
            logging.info('Automatically fixed %s', filename)
        else:
            logging.warning('Item can be fixed automatically, use --auto-fix')
    return result


def report_string(report_file):
    """
    Return the report_file into a big memory mapped string.
    """
    try:
        report = open(report_file)
        return mmap.mmap(report.fileno(), 0, access=mmap.ACCESS_READ)
    except IOError as exception:
        logging.critical('Could not open %s: %s', report_file, exception)
        sys.exit(-1)


def cross_check_file(filename, external):
    """
    Checks whether filename contains a cross-check to the file external.
    """
    result = True
    report_text = report_string(filename)
    if report_text.find(external) == -1:
        logging.warning(
            'Could not find a reference in %s to %s', filename, external)
        result = False
    return result


def add_include(filename, identifier, findings):
    """
    Adds XML include based on the identifier ('findings' or 'nonFindings').
    """
    tree = ElementTree.parse(
        filename, ElementTree.XMLParser(strip_cdata=False))
    root = tree.getroot()
    for section in tree.iter('section'):
        if section.attrib['id'] == identifier:
            finding_section = section
    if finding_section is not None:
        for finding in findings:
            new_finding = ElementTree.XML(
                '<placeholderinclude href="../{0}"/>'.format(finding))
            finding_section.append(new_finding)
            tree.write(filename, encoding="utf-8",
                       xml_declaration=True, pretty_print=True)


def close_file(filename):
    """
    Replace placeholder with proper XML include.
    """
    f = open(filename, 'r')
    filedata = f.read()
    f.close()
    newdata = filedata.replace("placeholderinclude", "xi:include")
    fileout = filename
    f = open(fileout, 'w')
    f.write(newdata)
    f.close()
    tree = ElementTree.parse(
        filename, ElementTree.XMLParser(strip_cdata=False))
    tree.write(filename, encoding="utf-8",
               xml_declaration=True, pretty_print=True)


def find_keyword(xmltree, keyword, filename):
    """
    Finds keywords in an XML tree.
    This function needs lots of TLC.
    """
    result = True
    section = ''
    for tag in xmltree.iter():
        if tag.tag == 'section' and' id' in tag.attrib:
            section = 'in {0}'.format(tag.attrib['id'])
        if tag.text:
            if keyword in tag.text:
                logging.warning('%s found in %s %s',
                                keyword, filename, section)
                result = False
    return result


def setup_logging(options):
    """
    Set up loghandlers according to options.
    """
    logger = logging.getLogger()
    logger.setLevel(0)
    console = logging.StreamHandler(stream=sys.stdout)
    console.setFormatter(LogFormatter())
    if options['debug']:
        console.setLevel(logging.DEBUG)
    else:
        if options['verbose']:
            console.setLevel(logging.INFO)
        else:
            logger.setLevel(STATUS)
    logger.addHandler(console)


def main():
    """
    The main program. Cross-checks, validates XML files and report.
    Returns True if the checks were successful.
    """
    # we want to print pretty Unicode characters
    reload(sys)
    sys.setdefaultencoding('utf-8')
    options = parse_arguments()
    setup_logging(options)
    if options['all']:
        options['capitalization'] = True
        options['long'] = True
    if options['learn']:
        logging.debug('Adding unknown words to %s', VOCABULARY)
    logging.info('Validating all XML files...')
    result = validate_files(all_files(), options)
    if result:
        if DOCBUILDER:
            logging.info('Validating report build...')
            result = validate_report() and result
    if result:
        logging.log(STATUS, 'Validation checks successful. Good to go')
    else:
        logging.warning('Validation failed')
    if options['spelling'] and options['learn']:
        logging.log(
            STATUS, 'Don\'t forget to check the vocabulary file %s', VOCABULARY)


if __name__ == "__main__":
    main()
