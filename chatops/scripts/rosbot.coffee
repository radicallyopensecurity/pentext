# Description:
#   Allows hubot to execute PenText framework commands
#
# Dependencies:
#   The PenText framework
#
# Configuration:
#   See the various handlers in bash/
#
# Author:
#   Peter Mosmans
#   John Sinteur
#
#  This is part of the PenText framework

admins = ['admin']

module.exports = (robot) ->
  run_cmd = (cmd, args, cb ) ->
    spawn = require("child_process").spawn
    child = spawn(cmd, args)
    child.stdout.on "data", (buffer) -> cb buffer.toString()
    child.stderr.on "data", (buffer) -> cb buffer.toString()

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
