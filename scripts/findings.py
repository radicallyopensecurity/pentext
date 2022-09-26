#!/usr/bin/python3

import argparse
import os
import xml.etree.ElementTree as ET


def update_xml(filename, id):
	"""
	Adds/updates ids for 'appendix', 'finding' and 'non-finding' files according to their filenames.
	E.g. filename = 'password_reuse.xml', then <finding id='password_reuse'>.
	
	'appendix', 'finding' and 'non-finding' must be root tags.
	
	:param filename: path + filename to the xml file (e.g. '/path/to/password_reuse.xml')
	:param id: filename without extension (e.g. 'password_reuse')
	:returns: xml type as str ('appendix', finding', 'non-finding') or None, if none of those three
	"""
	source_tree = ET.parse(filename)
	root = source_tree.getroot()
	if root is not None and root.tag in ('appendix', 'finding', 'non-finding'):
		root.set('id', id)
	else:
		return
	
	# write back to file
	target_tree = ET.ElementTree(root)
	with open(filename, 'wb') as f:
		target_tree.write(f)
	

def get_xml_root_tag(filename):
	"""
	Returns the root tag of a file if it is either 'appendix', 'finding' or 'non-finding'.
	
	:returns: xml type as str ('appendix', 'finding', 'non-finding') or None, if none of those three
	"""
	source_tree = ET.parse(filename)
	root = source_tree.getroot()
	if root is not None and root.tag in ('appendix', 'finding', 'non-finding'):
		return root.tag
	return
 		

def generate_xiinclude(filename):
	"""
	Returns a valid xi:include links
	
	:param filename: filename of the xml file to include
	:returns: str <xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="file" />
	"""
	return '<xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="{0}" />'.format(filename)


def traverse_directory(dir):
	"""
	Traverse a directory and consider all '.xml' (notice lowercase) files.
	
	:param dir: the directory to traverse
	:returns: list of tuples. tuple[0] contains filename with path and extension, tuple[1] contains filename without path and extension
	"""
	filenames = []
	for root, dirs, files in os.walk(dir):
		for file in files:
			name, ext = os.path.splitext(file)
			if ext == '.xml':
				filenames.append(('{0}/{1}'.format(root, file), name))
	return filenames

def main():	
	# argparser for directory argument
	argparser = argparse.ArgumentParser(description='Script to automatically edit findings/non-findings ids\' to their filenames.')
	argparser.add_argument('directory', help='Directory to look for xml files')
	argparser.add_argument('-l', '--list_only', help='Don\'t alter xml files, just print xi:include links', required=False, action='store_false')
	args = argparser.parse_args()
	
	files = traverse_directory(args.directory)
	
	xiinclude = {
		'appendix': [],
		'finding': [],
		'non-finding': [],
	}
	
	# iterate over files
	for file in files:
		if args.list_only:
			update_xml(file[0], file[1])
			
		xml_type = get_xml_root_tag(file[0])
		if xml_type:
			xiinclude[xml_type].append(generate_xiinclude(file[0]))
		
	# format output 
	for xml in xiinclude:
		print(xml)
		for xml_type in xiinclude[xml]:
			print(xml_type)
		print()
	print('Check if the paths are relative to your main report file.')
		
				
if __name__ == '__main__':
	main()