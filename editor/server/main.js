import { Meteor } from 'meteor/meteor';
import { Snippets } from '../imports/api/snippets.js';

var dir = "//media/sf_ROS-pentesters-library/Findings/";

Meteor.startup(() => {
    Snippets.remove({});

    var fs   = Npm.require('fs');
    var files = fs.readdirSync(dir);

    // Put the files and content in the db.
    for (filename of files) {
        Snippets.insert({filename: filename, content: fs.readFileSync(dir + filename)});
    }

    Meteor.publish("snippets", function() {
       return Snippets.find({});
   });

    console.log(Snippets.find().count());
});
