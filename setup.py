# Copyright 2017 RadicallyOpenSecurity B.V.

import os

from setuptools import setup, find_packages


version_file = os.path.abspath(os.path.join(os.path.dirname(__file__),
                                            'VERSION'))
with open(version_file) as v:
    VERSION = v.read().strip()


SETUP = {
    'name': "chatops",
    'version': VERSION,
    'author': "RadicallyOpenSecurity",
    'url': "https://github.com/radicallyopensecurity/pentext",
    'install_requires': [
        'lxml',
        'titlecase',
        'pyenchant',
        'pypandoc',
        'python-gitlab',
    ],
    'packages': find_packages(),
    'scripts': [
        'chatops/python/docbuilder.py',
        'chatops/python/gitlab-to-pentext.py',
        'chatops/python/pentext_id.py',
        'chatops/python/validate_report.py',
    ],
    'license': "GPLv3",
    'long_description': open('README.md').read(),
    'description': 'PenText system ',
}


# try:
#     from sphinx_pypi_upload import UploadDoc
#     SETUP['cmdclass'] = {'upload_sphinx': UploadDoc}
# except ImportError:
#     pass

if __name__ == '__main__':
    setup(**SETUP)