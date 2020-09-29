# Introduction
This directory contains the ChatOps scripts, based on Hubot. It uses RocketChat and gitlab as the underlying framework (but can be modified to fit any other framework).

This document describes the goal of the scripts, as well as installation instructions and their basic usage.


## Workflow
Scripts are ordered by workflow, not alphabetically.
The workflow consists of
1. setting up a repository for a quote with the PenText framework
2. (optional: converting quickscope input to a quote)
3. building a PDF quote
4. setting up a repository for a pentest with the PenText framework, based on a quote
5. (optional: converting gitlab issues to XML findings and non-findings)
6. (optional: validating a PenText report)
7. building a PDF report
8. building a PDF invoice

## Naming
The scripts either take the **project name** as input, or the **repository name** (and optional namespace and branch). The project name is leading, repository names are derived from the project names: the quotation repository has `off-` as prefix, and the pentest repository will have `pen-` as prefix.
As a rule of thumb, the handlers that are prefixed with `start` (startquote, startpentest) will take the **project name** as input. All other handlers take the **repository name** as input.

Example: when the project's name is ros, then the corresponding quote repository and RocketChat channel's name will be `off-ros`.
If this quote will result in a pentest project, then the corresponding repository and RocketChat channel will be named `pen-ros`.

Note that git repository names are _lowercase_.


# Scripts

The scripts use multiple environment variables, that can be set by the user under which rosbot is running. These are
+ `GITLABCLI` :: the location of the python-gitlab command line interface (defaults to `gitlab`)
+ `GITSERVER` :: the name of the gitlab server (defaults to `gitlab.local`)
+ `GITWEB` :: the URL of the gitlab webinterface (defaults to `https://$GITSERVER`)
+ `NAMESPACE` :: the namespace of the user which is used to set up gitlab repositories (defaults to `ros`)
+ `PENTEXTREPO` :: the location of the PenText repository (defaults to `https://github.com/radicallyopensecurity/pentext`)
+ `KB_USER` :: The username of the kanboard account (required when using the kanboard interface)
+ `KB_APIKEY` :: The API key with which the kanboard account can be user (required when using the kanboard interface)
+ `KB_ENDPOINT` :: The URL of the kanboard API
+ `CHECKLIST_TEMPLATE_URL `:: URL of checklist template. This will be displayed when a checklist isn't available in the KBB task decription.


## Prerequisites

### python-gitlab
The Bash scripts use the *python-gitlab* command-line interface to talk to the gitlab instance. This interface can be installed using `sudo pip install git+https://github.com/gpocentek/python-gitlab`. Obviously, Python needs to be installed as well.
This command line interface expects a configuration file `.python-gitlab.cfg` for the user under which rosbot is running, which it uses to connect to gitlab. Make sure it contains the correct details so that you can connect to gitlab.

If you want to convert and build documents, the pentext toolchain is necessary. Use the Ansible playbook https://galaxy.ansible.com/PeterMosmans/docbuilder/ or install the tools (Java, Saxon and Apache FOP) by hand, see https://github.com/radicallyopensecurity/pentext/blob/master/xml/doc/Tools%20manual.md for more information.

### Python libraries
Pandoc is necessary in order to automatically convert gitlab issues written in markdown to XML format.
The *pypandoc* library is also necessary: `sudo pip install pypandoc`.

## Test the configuration
Test out whether the configuration is successful by manually executing the Bash script [bash/test_pentext](bash/test_pentext) - this should return an OK.


## CoffeeScript

### rosbot.coffee

[scripts/rosbot.coffee](scripts/rosbot.coffee) - contains the various keywords and redirects to the proper handlers. All RocketChat-specific actions (e.g. the creation of rooms) is being handled by this script.

The scripts contains an array of users that will be added to the newly created rooms by default.

Example:
`admins = ['admin']`

## Bash

### startquote
Start the quotation process by setting up a repository with the PenText framework, and creating a RocketChat channel.

Handled by [bash/handler_quote](bash/handler_quote)

Sets up a pentest RocketChat channel named `off-PROJECT_NAME`, a gitlab repo named `off-PROJECT_NAME`, and installs the latest version of the Pentext framework. Note that this uses the `PROJECT_NAME` as input, so it will automatically append the `off-` prefix.

Usage: `startquote PROJECT_NAME`


### quickscope
Converts a quickscope (`source/quickscope.xml`) into a full-blown XML quote.

Handled by [bash/handler_quickscope](bash/handler_quickscope)


Usage: `quickscope REPO_NAME [NAMESPACE [BRANCH]]]`


### build
Builds PDF files from XML quotes and reports.

Handled by [bash/handler_build](bash/handler_build)

Usage: `build quote|report REPO_NAME [NAMESPACE [[BRANCH]] [-PARAMETERS]`


### startpentest
Start the pentesting process by setting up a repository with the PenText framework, adding standard gitlab labels and issues, and creating a RocketChat channel.

Handled by [bash/handler_pentest](bash/handler_pentest)

Sets up a pentest RocketChat channel named `pen-PROJECT_NAME`, and a gitlab repo named `pen-PROJECT_NAME`. Will use the quotation found in the corresponding `off-PROJECT_NAME` as base. Note that the prefix `pen-` is set by the `rosbot.coffee` script.

Usage: `startpentest PROJECT_NAME`


### convert
Converts gitlab issues labeled with `finding` and `non-finding` into XML files, and adds those to the repository
Handled by [bash/handler_convert](bash/handler_convert)

Converts gitlab items to XML findings

Usage: `convert REPO_NAME`


### validate
Validates quotes and reports.
Handled by [bash/handler_validate](bash/handler_validate)

Validates quotes and reports using the `validate_report.py` script (proper casing, spell checking, long lines, cross-checks)

Usage: `validate [OPTIONAL PARAMETERS]`


### invoice
Builds PDF invoices from quotes.

Handled by [bash/handler_invoice](bash/handler_invoice)


Usage: `invoice REPO_NAME INVOICE_NO [NAMESPACE [[BRANCH]] [-PARAMETERS]`

###   checklist
Handled by [python/kanboard_pm.py](python/kanboard_pm.py)

The "checklist" family of commands are used to manipulate the checklist of a kanboard task.

The following commands have been implemented:
 * checklist show      Shows the checklist for the column the task is in.
 * checklist toggle    Toggles a certain item

### checklist show
Handled by [python/kanboard_pm.py](python/kanboard_pm.py)

Shows the checklist for the column the kanboard task is in. It is required that the task's description contains the full checklist.
The script will connect to kanboard, open the Pentesting project and tries to find the kanboard task. It will then pull the description
and look for the checklist associated with the column the task is in.

 Usage: `checklist show <kanboard task>`
  * `<kanboard task>`   Specifies the title of the kanboard task. This should be an exact match and is mandatory.
  
###  checklist toggle
Handled by [python/kanboard_pm.py](python/kanboard_pm.py)

Pulls the checklist from the kanboard task's description and toggles its items

Usage: `checklist toggle <kanboard task> <index>`
* `<kanboard task>`   Specifies the title of the kanboard task. This should be an exact match and is mandatory.
* `<index>`           Should be an integer or comma separated list of integers as indices to the items. Mandatory.

###   column
Handled by [python/kanboard_pm.py](python/kanboard_pm.py)

The "column" family of commands are used to move a kanboard task across the board.

The following commands are implemented:
* column show      Shows the column the kanboard task is in
* column next      Moves the kanboard task to the next column
* column prev      Moves the kanboard task to the previous column

###   column show
Handled by [python/kanboard_pm.py](python/kanboard_pm.py)

Shows the column the kanboard task is currently in.

Usage: `column show <kanboard task>`
* `<kanboard task>`   Specifies the title of the kanboard task. This should be an exact match and is mandatory.

###   column next
Handled by [python/kanboard_pm.py](python/kanboard_pm.py)

Moves the kanboard task to the next column.

Usage: `column next <kanboard task>`
* `<kanboard task>`   Specifies the title of the kanboard task. This should be an exact match and is mandatory.

###  column prev
Handled by [python/kanboard_pm.py](python/kanboard_pm.py)

Moves the kanboard task to the previous column.

Usage: `column prev <kanboard task>`
* `<kanboard task>`   Specifies the title of the kanboard task. This should be an exact match and is mandatory.



