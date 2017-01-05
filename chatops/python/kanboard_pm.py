#!/usr/bin/env python
def error(message):
    sys.stderr.write("[!] %s\n" % message)

import sys
import os
import tempfile

try:
    from kanboard import Kanboard
except ImportError:
    error('This script needs the kanboard module to work. Use this command to install: sudo pip install kanboard\n')
    sys.exit(-1)
    sys.exit(-1)


class Column:
    def __init__(self, id, position, title):
        self.id =id
        self.title = title
        self.position = position

class KanboardAdapter():
    def __init__(self, project_name, task_name):
        self.kb = Kanboard(kb_endpoint, kb_user, kb_apikey, "X-API-Auth")
        self.project_name = project_name
        self.task         = None
        self.columns       = None

        # This pulls in the Kanboard project ("Pentesting" as of yet)
        self.kbb_project = self.kb.get_project_by_name(name=self.project_name)
        if not self.kbb_project:
            error("Could not find the *%s* project in Kanboard. Verify endpoint." % self.project_name)
            exit(-1)

        # This pulls in the task that will be manipulated
        tasks = self.kb.search_tasks(project_id=self.kbb_project["id"], query="title:%s" % task_name)
        if len(tasks) == 0:
            error("Could not find kanboard task with the title: %s" % task_name)
            exit(-1)
        for task in tasks:
            if task_name == task["title"]:
                self.task = task
                break
        if not self.task:
            error("Similar kanboard tasks for *%s* have been found, but no exact match. Check spelling." % task_name)
            exit(-1)

        self.description = task["description"].split("\r\n")

        # At this point the kbb project, the task and the description are loaded

    def get_columns(self):
        columns    = self.kb.get_columns(project_id=self.kbb_project["id"])

        self.columns = dict()
        for column in columns:
            self.columns[int(column["id"])] = Column(int(column["id"]), int(column["position"]), column["title"])

        return self.columns

    def get_column(self):
        if not self.columns:
            self.get_columns()

        column_id = int(self.task["column_id"]) # Make sure this is cast to int, otherwise comparison might go wrong

        for id in self.columns:
            if id == column_id:
                return self.columns[id]

        error("Could not determine the current column of the project")


    def update_column(self, column):
        result = self.kb.move_task_position(project_id=self.kbb_project["id"], task_id=self.task["id"], column_id=column.id, position=1)
        if not result:
            error("Unable to update column")

    def save_project_description(self):
        # Format into string
        desc = "\r\n".join(self.description)

        result = self.kb.update_task(id=self.task["id"], description=desc)
        if not result:
            error("Unable to update checklist")

    def update_project_description(self, linenr, content):
        self.description[linenr] = content

    def get_checklist_of_column(self, column):
        heading = "### Checklist %s" % column.title

        record = False
        found = False
        index = 1
        checklist = dict()

        # Loop through each line in the description
        for line in self.description:
            # Did we find the heading we're looking for? Start recording all subsequent lines
            if line.find(heading) is not -1:
                found = True
                record = True
                continue

            # Found a blank line? We're done. Stop recording
            if len(line.strip()) == 0:
                record = False

            # Add line to the checklist and update the index
            if record:
                checklist[index] = self.description.index(line), line  # Tuple that stores the index to the line in the description + the line itself
                index += 1

        if found is False:
            if checklist_template_url:
                error("Could not find the checklist for *%s* in kanboard task *%s*. Verify in kanboard if the task description contains the pentest checklist, which can be found here: %s" %
                    (column.title, self.task["title"], checklist_template_url))
            else:
                error("Could not find the checklist for column: *%s* in kanboard task *%s*" % (column.title, self.task["title"]))
            exit(-1)

        return checklist

    def save_checklist_backup(self):
        # Save description in temp dir before changing
        _, filename = tempfile.mkstemp(prefix="checklist_%s_" % self.task["title"])

        f = open(filename, "w")
        f.write("\n".join(self.description))
        f.close()


def checklist_show():
    '''
      Displays the checklist of the current project columns. It does so by putting the indices in front of the item
      so it can be used to toggle.
    '''

    column = adapter.get_column()
    checklist = adapter.get_checklist_of_column(column)

    print "Checklist for current column: *%s*" % column.title

    if len(checklist) > 0:
        for key, item in checklist.iteritems():
            key = str(key) + ":"
            print "%s %s" % (str(key).ljust(3, ' '), item[1]) # 0 is index to line in description, 1 is line content
    else:
        print "- This checklist has no items."


def checklist_toggle(indices):
    '''
     Toggles certain checklist item(s). This function only eats integers. Proper validation should have been done upsteam.
     :param indices list
    '''
    column     = adapter.get_column()
    checklist = adapter.get_checklist_of_column(column)
    output = []

    # Save a quick backup before manipulating the checklist
    adapter.save_checklist_backup()

    for index in indices:
        # Input validation
        if index not in checklist.keys():
            error("%i is not a valid item" % index)
            exit(-1)

        # item is a tuple
        item = checklist[index]

        line_index   = item[0] # Index to settings
        line_content = item[1] # Actual content

        # Validation of the item
        if item[1].find("[X]") == -1 and item[1].find("[ ]") == -1:
            error("Could not find checkbox for item: %s. Make sure this item contains either [ ] or [X] by editing the kanboard task description directly" % item[1])
            exit(-1)

        # Actual toggling
        if line_content.find("[X]") != -1:
            line_content = line_content.replace("[X]", "[ ]", 1)
            output.append("%s has been *unchecked*" % line_content)
        elif line_content.find("[ ]") != -1:
            line_content = line_content.replace("[ ]", "[X]", 1)
            output.append("%s has been *checked*" % line_content)

        # Update description
        adapter.update_project_description(line_index, line_content)

    # Save
    adapter.save_project_description()
    print "\n".join(output)

def column_show():
    global adapter

    columns    = adapter.get_columns()
    cur_column = adapter.get_column()

    for column_id in columns:
        if column_id == cur_column.id:
            print "*%s*" % cur_column.title
        else:
            print columns[column_id].title


def change_column(direction):
    '''
    Moves the project to the [next|previous] column.

    Retrieves a list of available columns
    Retrieves the current column
    Will validate the current column in order to determine the next column.
    When the project is already in a border case, a notification of the fact is displayed.
    Will select the next column and update the current column with the next column + display notification
    '''
    global adapter

    columns    = adapter.get_columns()
    cur_column = adapter.get_column()

    # Get the id of the column with the lowest and highest position
    highest_column = None
    lowest_column  = None

    for id in columns:
        if not highest_column:
            highest_column = columns[id]
        if not lowest_column:
            lowest_column = columns[id]

        if columns[id].position > highest_column.position:
            highest_column = columns[id]
        if columns[id].position < lowest_column.position:
            lowest_column = columns[id]


    if cur_column.id == highest_column.id and direction == 1:
        print "This project is in its final column."
        return

    if cur_column.id == lowest_column.id and direction == -1:
        print "This project is in its first column."
        return

    next_position = cur_column.position + direction
    next_column = None
    for id in columns:
        if columns[id].position == next_position:
            next_column = columns[id]

    adapter.update_column(next_column)

    print "The project changed column from *%s* to *%s*" % (cur_column.title, next_column.title)


def column_next():
    '''
    Moves the project to the next stage
    '''
    change_column(1)


def column_previous():
    '''
    Moves the project to the previous column
    '''
    change_column(-1)


def validate_env_vars():
    '''
    Validates the required environment variables to be able to adapter with kanboard.
    It checks them all. If one is missing, the script will exit
    '''
    global kb_user
    global kb_apikey
    global kb_endpoint

    if kb_user is None:
        error("Environment variable KB_USER is not set.")
    if kb_apikey is None:
        error("Environment variable KB_APIKEY is not set.")
    if kb_endpoint is None:
        error("Environment variable KB_ENDPOINT is not set.")
    if None in [kb_user, kb_apikey, kb_endpoint]:
        exit(-1)

def process_cmdline_arguments(args):
    ''' Validate command line arguments.
    Fills the following global variables:
    command (checklist|column)
    sub_command [show|toggle] | [show|next|previous]
    argument <int> in case of checklist toggle
    '''

    global kanboard_task
    global command
    global sub_command
    global argument

    if len(args) == 0:
        error("Please specify valid input")
        exit(1)

    kanboard_task = args[0]
    command       = args[1]

    if not kanboard_task:
        error("Please specify a kanboard task title")
        exit(-1)

    if not command:
        error("Please specify a command")
        exit(-1)

    if command not in ["checklist", "column"]:
        error("command %s not recognised" % command)
        exit(-1)

    if command == "checklist":
        sub_commands = ["show", "toggle"]
        if len(args) >= 3:
            sub_command = args[2]

        if sub_command not in sub_commands:
            error("Please specify one of the following sub-commands: %s" % '|'.join(sub_commands))
            exit(-1)

        if sub_command == "toggle":
            if len(args) != 4:
                error("Please specify a comma separated listof indices as argument to this command")
                exit(-1)

            argument = args[3]
            argument = clean_checklist_toggle_arguments(argument)

    if command == "column":
        sub_commands = ["show", "next", "previ"]
        if len(args) >= 3:
            sub_command = args[2]

        if sub_command not in sub_commands:
            error("Please specify one of the following sub-commands: %s" % '|'.join(sub_commands))
            exit(2)


def clean_checklist_toggle_arguments(argument):
    indices = argument.split(",")
    clean_indices = []
    for index in indices:
        index = index.strip()
        if len(index) == 0:
            continue

        if index and not index.isdigit():
            error("%s is not an integer." % index)
            exit(-1)
        else:
            clean_indices.append(int(index))
    return clean_indices


''' ---------------------- ENTRY POINT --------------------------'''

''' Globals '''
kanboard_task = None
command = None
sub_command = None
argument = None
kb_endpoint            = os.environ.get("KB_ENDPOINT")
kb_user                = os.environ.get("KB_USER")
kb_apikey              = os.environ.get("KB_APIKEY")
checklist_template_url = os.environ.get("CHECKLIST_TEMPLATE_URL")

validate_env_vars()

# Process command line:
# Fills command, sub_command and argument (in case of toggle)
process_cmdline_arguments(sys.argv[1:])

adapter     = KanboardAdapter("Pentesting", kanboard_task)





# Debug reut WARNING THIS MAY SHOW UP IN A RC CHANNEL, FOR EVERYONE TO SEE
# print kanboard_task
# print command
# print sub_command
# print argument

if command == "checklist":
    if sub_command == "show":
        checklist_show()
    if sub_command == "toggle":
        checklist_toggle(argument)

if command == "column":
    if sub_command == "show":
        column_show()
    if sub_command == "next":
        column_next()
    if sub_command == "prev":
        column_previous()








