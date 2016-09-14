# Description:
#   Allows hubot to execute PenText framework commands
#
# Dependencies:
#   The PenText framework
#
# Configuration:
#   See the various handlers in bash/
#
# Usage:
#   build
#     Builds a .pdf document of <type> based on files in <repository>. The file is stored in target/ of the specified repository.
#     Usage: build <type> <repository> [namespace=ros] [branch=master] [-v]
#     <type>       Can be either report or quote
#     <repository> Specifies the name of the gitlab repository where the files needed to do the job are located.
#     [namespace]  This optional parameter refers to the gitlab user or group this repository is part of. Defaults to ros
#     [branch]     This optional parameter specifies which branch to use. Defaults to master.
#     [-v]         Specifying this flag will yield verbose output.
#     
#   convert
#     Converts gitlab issues in <respository> to xml files. The issues must be open and need to be labelled with either finding or non-finding.
#     Depending on the label, the xml files will be put in either the finding/ or non-finding/ directory in the repository.
#     Usage: convert <repository> [--closed] [--dry-run] [--issues] [--projects] [-v|--verbose] [-y]
#     <repository>   Specifies the name of the gitlab repository where the files needed to do the job are located.
#     [--closed]     If specified, will include closed issues
#     [--dry-run]    If specified, will not write xml files, but only displays output on screen
#     [--issues]     If specified, will list issues in given <repository>
#     [--projects]   If specified, will list gitlab repositories
#     [-v|--verbose] If specified, will yield verbose output
#     [-y]           Assumes yes on all questions
#
#   validate
#     Validates the XML structure of a reports or quote to be able to generate a .pdf file. (See build command)
#     Usage: validate <repository> [-a|-all] [--autofix] [-c|--capitalization] [--debug] [--edit] [--learn] [--long] [--offer] [--spelling] [-v|--verbose] [--no-report] [--quiet]
#     <repository>   Specifies the name of the gitlab repository where the files needed to do the job are located.     
#     [-a|-all]             Perform all checks
#     [--autofix]           Try to automatically correct issues
#     [-c|--capitalization] Check capitalization
#     [--debug]             Show debug information
#     [--edit]              Open files with issues using an editor
#     [--learn]             Store all unknown words in dictionary file
#     [--long]              Check for long lines
#     [--offer]             Validate offer master file
#     [--spelling]          Check spelling
#     [-v|--verbose]        If specified, will yield verbose output
#     [--no-report]         Do not validate report master file
#     [--quiet]             Don't output status messages
#
#
# Commands:
#   hubot build <type> <repo> <target> - Builds a .pdf file from <target> in <repo>
#   hubot convert <repo> <target> - Builds a .xml file from <target> in <repo>
#   hubot invoice <repo> <target> - Builds pdf invoice from quote
#   hubot quickscope <repo> <namespace> [branch=MASTER] - Converts quickscope into quotation
#   hubot startpentest <name> - Bootstraps a pentest
#   hubot startquote <name> - Bootstraps a quotation
#   hubot validate <parms..> - Validates a report/quotation
#   hubot usage [command] - Displays usage information for command. If no command is specified, supported commands are displayed.
#

# Author:
#   Peter Mosmans
#   John Sinteur
#   Daniel Attevelt
#
#  This is part of the PenText framework
#

USAGE_LABEL = '# Usage:'

Fs             = require 'fs'
Path           = require 'path'

admins = ['peter']

###
  This will initialise the usage information for the chatops command used in the pentext framework
  It will parse the file comment sections in search of usage information. See above for an example

  ! This section should always be above the commands section and should always be terminated by two consecutive #s !
  ! Only single word commands are supported !

  robot gets a new property .usages which can be used later on
###
init_usage = (robot) ->
  robot.usages = []

  load_scripts(robot)

###
  This will load all the scripts in the same folder as this one. It will then proceed
  to parsing those scripts in order to extract the rosbot command usage information
###
load_scripts = (robot) ->
  if Fs.existsSync(__dirname)
    for file in Fs.readdirSync(__dirname).sort()
      fullPath = Path.join __dirname, file
      robot.logger.info "File: " + fullPath

      body = Fs.readFileSync fullPath, 'utf-8'
      parse_scripts(robot, body)

###
  This function will parse the script for usage information.
  It will do so by looping through every comment line until it hits the # Usage: label
  Then it will start to look for a command tag that is identified by:
  # (3 spaces) <command>. The will let the function know it's dealing with a command identifiers.
  # (5 spaces) <infoline> lets the function know it's dealing with info line that should go together with the previously encountered command.

  The sequence is broken by two sequential empty comment lines. e.g.:
  #
  #

###
parse_scripts = (robot, body) ->
  parsing_usage      = false
  current_command    = null

  # https://regex101.com
  cmd_regex          = /^#[ ]{3}[\S]+/i
  info_regex         = /^#[ ]{5}[\S]+/i

  # Loop through each comment line until there is none.
  for line in body.split "\n"
    break unless line[0] is '#' or line.substr(0, 2) is '//'

    # Determine if we've reached the Usage: tag
    if line.indexOf(USAGE_LABEL) != -1
      parsing_usage = true

    if parsing_usage
      # Pre-cleaning ...
      cleanedLine = line.replace(/^(#|\/\/)\s?/, "").trim()

      # Are we dealing with a command?
      if line.match cmd_regex
        current_command = cleanedLine
        robot.usages[current_command] = []

      # Are we dealing with an info line ?
      if line.match info_regex
        if not robot.usages[current_command]
          robot.logger.debug "Error parsing chatpos usage info: found info line, but no command line"
        else
          robot.usages[current_command].push cleanedLine

      # Detects two sequential #'s and quits parsing usage when it does
      if cleanedLine.length == 0
        if current_command == null
          parsing_usage = false
        else
          current_command = null

  # Sanity check
  robot.logger.info "--- Following usage information parsed ----"
  for command, lines of robot.usages
    for index, line of lines
      robot.logger.info "* #{command} : #{line}"

module.exports = (robot) ->
  run_cmd = (cmd, args, cb ) ->
    spawn = require("child_process").spawn
    child = spawn(cmd, args)
    child.stdout.on "data", (buffer) -> cb buffer.toString()
    child.stderr.on "data", (buffer) -> cb buffer.toString()

  init_usage(robot)


#    ***************************************************************************
#                        ChatOps command handlers
#    ***************************************************************************

  robot.respond /build (.*)/i, id:'chatops.build', (msg) ->
    msg.match[0] = msg.match[0].replace(/^[a-z0-9]+$/i);
    msg.match.shift();
    args = msg.match[0].split(" ");
    cmd = "bash/handler_build";
    run_cmd cmd, args, (text) -> msg.send text.replace("\n","");

  robot.respond /convert (.*)/i, id:'chatops.convert', (msg) ->
    msg.match[0] = msg.match[0].replace(/^[a-z0-9]+$/i);
    msg.match.shift();
    args = msg.match[0].split(" ");
    cmd = "bash/handler_convert";
    run_cmd cmd, args, (text) -> msg.send text.replace("\n","");

  robot.respond /invoice (.*)/i, id:'chatops.invoice', (msg) ->
    msg.match[0] = msg.match[0].replace(/^[a-z0-9]+$/i);
    msg.match.shift();
    args = msg.match[0].split(" ");
    cmd = "bash/handler_invoice";
    run_cmd cmd, args, (text) -> msg.send text.replace("\n","");

  robot.respond /quickscope (.*)/i, id:'chatops.quickscope', (msg) ->
    msg.match[0] = msg.match[0].replace(/^[a-z0-9]+$/i);
    msg.match.shift();
    args = msg.match[0].split(" ");
    cmd = "bash/handler_quickscope";
    run_cmd cmd, args, (text) -> msg.send text.replace("\n","");

  robot.respond /startpentest (.*)/i, id:'chatops.startpentest', (msg) ->
    msg.match[0] = msg.match[0].replace(/^[a-z0-9]+$/i);
    msg.match.shift();
    args = msg.match[0].split(" ");
    if args[0].substring(0, 4) == "off-"
      msg.send "[-] Please do not start pen names with off-";
      return;
    if args[0].substring(0, 4) == "pen-"
      msg.send "[-] Please do not start pen names with pen-";
      return;
    roomName = "pen-" + args[0];
    newroom = robot.adapter.callMethod('createPrivateGroup', roomName, admins)
    msg.send  "[+] new channel created - Added " + admins + " to the new room " + roomName
    newroom.then (roomId) =>
      robot.messageRoom roomId.rid, "@all hello!"
      args[1] = roomId.rid
    cmd = "bash/handler_pentest";
    run_cmd cmd, args, (text) -> msg.send text.replace("\n","");

  robot.respond /startquote (.*)/i, id:'chatops.startquote',(msg) ->
    msg.match[0] = msg.match[0].replace(/^[a-z0-9]+$/i);
    msg.match.shift();
    args = msg.match[0].split(" ");
    if args[0].substring(0, 4) == "pen-"
      msg.send "[-] Please do not start quote names with pen-";
      return;
    if args[0].substring(0, 4) == "off-"
      msg.send "[-] Please do not start quote names with off-";
      return;
    roomName = "off-" + args[0]
    newroom = robot.adapter.callMethod('createPrivateGroup', roomName, admins)
    msg.send  "[+] new channel created - Added " + admins + " to the new room " + roomName
    newroom.then (roomId) =>
      robot.messageRoom roomId.rid, "@all hello!"
    cmd = "bash/handler_quote";
    run_cmd cmd, args, (text) -> msg.send text.replace("\n","");

  robot.respond /validate (.*)/i, id:'chatops.validate', (msg) ->
    msg.match[0] = msg.match[0].replace(/^[a-z0-9]+$/i);
    msg.match.shift();
    args = msg.match[0].split(" ");
    cmd = "bash/handler_validate";
    run_cmd cmd, args, (text) -> msg.send text.replace("\n","");


  # Handler for the usage command.
  # Note that the regex option group (.*) also captures the space after the command
  # This allows for the case when there is no command specified, supported commands can be displayed
  robot.respond /usage(.*)/i, id:'chatops.usage', (msg) ->
    msg.match[0] = msg.match[0].replace(/^[a-z0-9]+$/i);
    msg.match.shift();
    args = msg.match[0].trim().split(" ");
    command = args[0]

    # If not command is provided, return information on which commands can be handled
    if command.trim().length == 0
      msg.send "I can provide usage information for the following commands:"
      for command of robot.usages
        msg.send command
      msg.send "Issue the command: usage <command> for usage information for this command"
      return

    # This deals when unsupported commands
    if not robot.usages[command]
      msg.send "I have no usage information for: " + command
      return

    # All odd case have been dealt with, let's get down to business
    for index, line of robot.usages[command]
      msg.send line
