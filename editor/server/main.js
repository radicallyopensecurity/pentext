import { Meteor } from 'meteor/meteor';
import { LibraryFindings } from '../imports/api/library_findings.js';
import { LibraryNonFindings } from '../imports/api/library_non_findings.js';
import { Settings } from '../imports/api/settings.js';
import Findings from '../imports/api/findings.js';
import NonFindings from '../imports/api/nonfindings.js';

var fs      = Npm.require('fs');
var util    = Npm.require('util');
var cheerio = Npm.require('cheerio');

Meteor.startup(() => {
    handle_settings();
    handle_findings();
    handle_library_findings();
    handle_non_findings();
    handle_library_non_findings();
});

/**
 * Takes a finding object and turns it into XML that can be handled
 * by the pentext system to generate a report.
 * @param non_finding
 * @return string
 */
function get_finding_xml(finding)
{
    var xml= '<finding id="" threatLevel="" type=""><title></title><description></description><technicaldescription></technicaldescription><impact></impact><recommendation></recommendation></finding>'
    var $ = cheerio.load(xml, {xmlMode: true});

    $('finding').attr('id', finding.id);
    $('finding').attr('type', finding.type);
    $('finding').attr('threatLevel', finding.threat_level);

    $('title').html(finding.title);
    $('description').html(finding.description);
    $('technicaldescription').html(finding.technical_description);
    $('impact').html(finding.impact);
    $('recommendation').html(finding.recommendation);

    return $.xml();
}

/**
 * Takes a non-finding object and turns it into XML that can be handled
 * by the pentext system to generate a report.
 * @param non_finding
 * @return string
 */
function get_non_finding_xml(non_finding)
{
    var xml= '<non-finding id=""><title></title></non-finding>';
    var $ = cheerio.load(xml, {xmlMode: true});

    $('non-finding').attr('id', non_finding.id);
    $('title').html(non_finding.title);
    $('non-finding').append(non_finding.description)

    return $.xml();
}

/**
 * Sets up library findings. Removes any present at start, and publishes the collection
 */
function handle_library_findings() {
    LibraryFindings.remove({});

    Meteor.publish("library_findings", function() {
        return LibraryFindings.find({});
    })
}

/**
 * Sets up non library findings. Removes any present at start, and publishes the collection
 */
function handle_library_non_findings() {
    LibraryNonFindings.remove({});

    Meteor.publish("library_non_findings", function() {
        return LibraryNonFindings.find({});
    })
}

/**
 * This function is called when meteor starts. It will init an empty findings collection.
 * Then it will add an "after update" handler that will generate xml from the finding object
 * and will store it under the filename supplied by the object.
 */
function handle_findings()
{
    Findings.remove({});

    // This event handler will generate an XML file from the JS object and store it.
    Findings.after.update(function (userid, finding, fieldnames, modifier) {
        var xml = get_finding_xml(finding);
        var findings_dir = Settings.findOne({_id: "findings_directory"}).value;
        fs.writeFileSync(findings_dir + "/" + finding.filename, xml);
        Findings.direct.update(finding._id, {$set: {raw: xml}});
    });

    Meteor.publish("findings", function() {
        return Findings.find({});
    })
}

/**
 * Saves non-findings back to disc
 */
function handle_non_findings() {
    NonFindings.remove();

    NonFindings.after.update(function (userid, non_finding) {
        var xml = get_non_finding_xml(non_finding);
        var dir = Settings.findOne({_id: "non_findings_directory"}).value;
        fs.writeFileSync(dir + "/" + non_finding.filename, xml);
        NonFindings.direct.update(non_finding._id, {$set: {raw: xml}});
    });

    Meteor.publish("non_findings", function() {
        return NonFindings.find({});
    })
}

/**
 * This function is called when meteor starts. It will check if the needed settings
 * are present. If not, it will create a default one. An update hook is attached
 * to the settings collection, so that all logic that depends on a change of this
 * collection has a chance to update accordingly.
 */
function handle_settings() {
    //Settings.remove({});

    // Check if findings directory is available
    // No ? Create default entry
    if (!Settings.findOne({_id: "findings_directory"})) {
        Settings.insert({_id: "findings_directory", value: ""})
    }
    if (!Settings.findOne({_id: "library_findings_directory"})) {
        Settings.insert({_id: "library_findings_directory", value: ""})
    }
    if (!Settings.findOne({_id: "non_findings_directory"})) {
        Settings.insert({_id: "non_findings_directory", value: ""})
    }
    if (!Settings.findOne({_id: "non_findings_library_directory"})) {
        Settings.insert({_id: "non_findings_library_directory", value: ""})
    }

    // Update hook for findings https://github.com/matb33/meteor-collection-hooks
    Settings.after.update(function (user, setting) {
        if (setting._id == "findings_directory") {
            dir = Settings.findOne({_id: "findings_directory"}).value;
            read_xml(dir, Findings, parse_finding_xml);
        } else if (setting._id == "library_findings_directory") {
            dir = Settings.findOne({_id: "library_findings_directory"}).value;
            read_xml(dir, LibraryFindings, parse_finding_xml);
        } else if (setting._id == "non_findings_directory") {
            dir = Settings.findOne({_id: "non_findings_directory"}).value;
            read_xml(dir, NonFindings, parse_non_finding_xml);
        } else if (setting._id == "non_findings_library_directory") {
            dir = Settings.findOne({_id: "non_findings_library_directory"}).value;
            read_xml(dir, LibraryNonFindings, parse_non_finding_xml);
        }
    });

    Meteor.publish("settings", function () {
        return Settings.find({});
    })
}

/**
 * This function is used to read findings/non-findings which are stored in xml format on the filesystem.
 * This function can read library (non)findings as well as pentest (non)findings.
 * @param: dir - the directory where to look for findings
 * @param: collection - The collection to add the finding to
 */
function read_xml(dir, collection, func) {
    collection.remove({});

    try {
        var stats = fs.statSync(dir);
    } catch (e) {
        console.log(e);
        return false;
    }

    if (stats.isDirectory()) {
        var files = fs.readdirSync(dir);
        for (filename of files) {
            var fullpath   = dir + "/" + filename;
            var stats = fs.statSync(fullpath);
            if (stats.isDirectory()) { // Bail out as we can't read directories.
                continue;
            }
            if (!fullpath.endsWith(".xml")) {
                continue;
            }

            var content    = fs.readFileSync(fullpath, encoding = "utf8");
            var parsed_xml = func(filename, content);
            collection.insert(parsed_xml);
        }
    }
}



function parse_finding_xml(filename, rawxml)
{
    var title;
    var id;
    var threat_level;
    var type;
    var description;
    var technical_description;
    var impact;
    var recommendation;
    var valid = true;

    $ = cheerio.load(rawxml, {  xmlMode: false});

    if ((id = $('finding').attr('id')) == null) {
        valid = false;
    }

    if ((type = $('finding').attr('type')) == null) {
        valid = false;
    }

    if ((threat_level = $('finding').attr('threatlevel')) == null) {
        valid = false;
    }

    if ((title = $('title').html()) == null) {
        valid = false;
    }

    if ((description = $('description').html()) == null) {
        valid = false;
    }

    if ((technical_description = $('technicaldescription').html()) == null) {
        valid = false;
    }

    if ((impact = $('impact').html()) == null) {
        valid = false;
    }

    if ((recommendation = $('recommendation').html()) == null) {
        valid = false;
    }

    return {
        "filename": filename,
        "title": title,
        "id": id,
        "threat_level": threat_level,
        "type": type,
        "description": description,
        "technical_description": technical_description,
        "impact": impact,
        "recommendation": recommendation,
        "raw": rawxml,
        "valid": valid
    }
}


function parse_non_finding_xml(filename, rawxml)
{
    var title;
    var id;
    var description;
    var valid = true;

    $ = cheerio.load(rawxml, {  xmlMode: false});

    if ((id = $('non-finding').attr('id')) == null) {
        valid = false;
    }

    if ((title = $('title').html()) == null) {
        valid = false;
    }

    if ((description = $('non-finding').html()) == null) {
        valid = false;
    }

    return {
        "filename": filename,
        "title": title,
        "id": id,
        "description": description,
        "raw": rawxml,
        "valid": valid
    }
}