#!/usr/bin/env python
def error(message):
    sys.stderr.write("[!] %s\n" % message)

def output(message):
    sys.stdout.write("%s\n" % message)

import sys
import os
import tempfile
import json

try:
    from kanboard import Kanboard
except ImportError:
    error('This script needs the kanboard module to work. Use this command to install: sudo pip install kanboard\n')
    sys.exit(-1)
    sys.exit(-1)


class State:
    def __init__(self, id, position, title):
        self.id =id
        self.title = title
        self.position = position

class KanboardAdapter():
    def __init__(self, project_name, task_name):
        self.kb = Kanboard(kb_endpoint, kb_user, kb_apikey, "X-API-Auth")
        self.project_name = project_name
        self.task         = None
        self.states       = None

        # This pulls in the Kanboard project ("Pentesting" as of yet)
        self.kbb_project = self.kb.get_project_by_name(name=self.project_name)
        if not self.kbb_project:
            error("Could not find the *%s* project in Kanboard. Verify endpoint." % self.project_name)
            exit(-1)

        # This pulls in the task that will be manipulated
        tasks = self.kb.search_tasks(project_id=self.kbb_project["id"], query="title:%s" % task_name)
        if len(tasks) == 0:
            error("Could not find kanboard task for: %s" % task_name)
            exit(-1)
        for task in tasks:
            if task_name == task["title"]:
                self.task = task
                break
        if not self.task:
            error("Similar tasks for %s have been found, but no exact match %s" % task_name)
            exit(-1)

        self.description = task["description"].split("\r\n")

        # At this point the kbb project, the task and the description are loaded

    def get_states(self):
        columns    = self.kb.get_columns(project_id=self.kbb_project["id"])

        self.states = dict()
        for column in columns:
            self.states[int(column["id"])] = State(int(column["id"]), int(column["position"]), column["title"])

        return self.states

    def get_state(self):
        if not self.states:
            self.get_states()

        column_id = int(self.task["column_id"]) # Make sure this is cast to int, otherwise comparison might go wrong

        for id in self.states:
            if id == column_id:
                return self.states[id]

        error("Could not determine the current state of the project")


    def update_state(self, state):
        result = self.kb.move_task_position(project_id=self.kbb_project["id"], task_id=self.task["id"], column_id=state.id, position=1)
        if not result:
            error("Unable to update state")

    def save_project_description(self):
        # Format into string
        desc = "\r\n".join(self.description)

        result = self.kb.update_task(id=self.task["id"], description=desc)
        if not result:
            error("Unable to update checklist")

    def update_project_description(self, linenr, content):
        self.description[linenr] = content

    def get_checklist_of_state(self, state):
        heading = "### Checklist %s" % state.title

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
                    (state, self.task["title"], checklist_template_url))
            else:
                error("Could not find the checklist for state: *%s* in kanboard task *%s*" % (state, self.task["title"]))
            exit(-1)

        return checklist

    def save_checklist_backup(self):
        # Save description in temp dir before changing
        _, filename = tempfile.mkstemp(prefix="checklist_%s_" % self.task["title"])

        f = open(filename, "w")
        f.write("\n".join(self.description))
        f.close()

'''
  Displays the checklist of the current project states. It does so by putting the indices in front of the item
  so it can be used to toggle.
'''
def checklist_show():
    state = adapter.get_state()
    checklist = adapter.get_checklist_of_state(state)

    print "Checklist for current state: *%s*" % state.title

    if len(checklist) > 0:
        for key, item in checklist.iteritems():
            key = str(key) + ":"
            print "%s %s" % (str(key).ljust(3, ' '), item[1]) # 0 is index to line in description, 1 is line content
    else:
        print "- This checklist has no items."

'''
 Toggles certain checklist item(s). This function only eats integers. Proper validation should have been done upsteam.
 :param indices list
'''
def checklist_toggle(indices):
    state     = adapter.get_state()
    checklist = adapter.get_checklist_of_state(state)
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

def state_show():
    global adapter

    states    = adapter.get_states()
    cur_state = adapter.get_state()

    for state_id in states:
        if state_id == cur_state.id:
            print "*%s*" % cur_state.title
        else:
            print states[state_id].title

'''
Moves the project to the [next|previous] state.

Retrieves a list of available states
Retrieves the current state
Will validate the current state in order to determine the next state.
When the project is already in a border case, a notification of the fact is displayed.
Will select the next state and update the current state with the next state + display notification
'''
def change_state(direction):
    global adapter

    states    = adapter.get_states()
    cur_state = adapter.get_state()

    # Get the id of the state with the lowest and highest position
    highest_state = None
    lowest_state  = None

    for id in states:
        if not highest_state:
            highest_state = states[id]
        if not lowest_state:
            lowest_state = states[id]

        if states[id].position > highest_state.position:
            highest_state = states[id]
        if states[id].position < lowest_state.position:
            lowest_state = states[id]


    if cur_state.id == highest_state.id and direction == 1:
        print "This project is in its final state."
        return

    if cur_state.id == lowest_state.id and direction == -1:
        print "This project is in its first state."
        return

    next_position = cur_state.position + direction
    next_state = None
    for id in states:
        if states[id].position == next_position:
            next_state = states[id]

    adapter.update_state(next_state)

    print "The project changed state from *%s* to *%s*" % (cur_state.title, next_state.title)

'''
Moves the project to the next stage
'''
def state_next():
    change_state(1)

'''
Moves the project to the previous state
'''
def state_previous():
    change_state(-1)


'''
Validates the required environment variables to be able to adapter with kanboard.
It checks them all. If one is missing, the script will exit
'''
def validate_env_vars():
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

''' Validate command line arguments.
Fills the following global variables:
command (checklist|state)
sub_command [show|toggle] | [show|next|previous]
argument <int> in case of checklist toggle
'''
def process_cmdline_arguments(args):
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

    if not kanboard_task.find("pen-") == 0:
        print kanboard_task.find("pen-")
        print kanboard_task
        error("This command only works in a pentesting channel prefixed by pen-")
        exit(-1)



    if not command:
        error("Please specify a command")
        exit(-1)

    if command not in ["checklist", "state"]:
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

    if command == "state":
        sub_commands = ["show", "next", "previous"]
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
            error("%s is not a digit." % index)
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

if command == "state":
    if sub_command == "show":
        state_show()
    if sub_command == "next":
        state_next()
    if sub_command == "previous":
        state_previous()








