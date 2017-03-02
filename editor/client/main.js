import { Template } from 'meteor/templating';
import { Session } from 'meteor/session';
import { ReactiveVar } from 'meteor/reactive-var';
import { FindingsIndex } from '../imports/api/findings.js'
import { NonFindingsIndex } from '../imports/api/nonfindings';
import { LibraryFindingsIndex } from '../imports/api/library_findings.js'
import { LibraryNonFindingsIndex } from '../imports/api/library_non_findings.js'
import Findings from '../imports/api/findings';
import NonFindings from '../imports/api/nonfindings';
import { Settings } from '../imports/api/settings.js';
import './main.html';


Meteor.subscribe("snippets");
Meteor.subscribe("oneReport");
Meteor.subscribe("settings");
Meteor.subscribe("findings");
Meteor.subscribe("library_findings");
Meteor.subscribe("non_findings");
Meteor.subscribe("library_non_findings");

Findings.attachSchema(new SimpleSchema({
    // filename: {
    //     type: String,
    //     label: "Filename",
    //     min: 1,
    //     max: 200
    // },
    id: {
        type: String,
        label: "ID",
        min: 1,
        max: 200,
    },
    threat_level: {
        type: String,
        allowedValues: [
            "Low",
            "Moderate",
            "Elevated",
            "High",
            "Extreme"
        ],
        label: "Threat level",
    },
    type: {
        type: String,
        label: "Type",
        min: 1,
        max: 200,
    },
    title: {
        type: String,
        label: "Title",
        min: 1,
        max: 200,
    },
    description: {
        type: String,
        label: "Description",
        min: 1,
        autoform: {
            rows: 5
        },
    },
    technical_description: {
        type: String,
        label: "Technical Description",
        min: 1,
        autoform: {
            rows: 5
        },
    },
    impact: {
        type: String,
        min: 1,
        label: "Impact",
        autoform: {
            rows: 5
        },
    },
    recommendation: {
        type: String,
        min: 1,
        label: "Recommendation",
        autoform: {
            rows: 5
        },
    }
}));


NonFindings.attachSchema({
    // filename: {
    //     type: String,
    //     label: "Filename",
    //     min: 1,
    //     max: 200
    // },
    id: {
        type: String,
        label: "ID",
        min: 1,
        max: 200,
    },
    title: {
        type: String,
        label: "Title",
        min: 1,
        max: 200,
    },
    description: {
        type: String,
        label: "Description",
        min: 1,
        autoform: {
            rows: 5
        },
    },
});

/** ******************************** EDITOR PANE HELPERS *************************************/

/**
 * FINDINGS_EDITOR
 */
Template.findings_editor.helpers({
    getFormType:function () {
        var finding_id = Session.get("selected_finding");
        return finding_id ? "update" : "insert";
    },
    getSelectedFinding:function () {
        return Findings.findOne(Session.get("selected_finding"));
    }
});

/**
 * NON-FINDINGS EDITOR
 */
Template.non_findings_editor.helpers({
    getFormType:function () {
        var finding_id = Session.get("selected_finding");
        return finding_id ? "update" : "insert";
    },
    getSelectedNonFinding:function () {
        return NonFindings.findOne(Session.get("selected_non_finding"));
    }
});

// Template.editor.event = {
//     'click .btn_reset': function () {
//         AutoForm.resetForm('findingForm');
//         Session.set("selected_finding", null);
//     }
// };

/**
 * MAIN
  */
Template.main.events = {
    'click .edit_findings_button': function (event, template) {
        Session.set("edit_mode", "findings");
    },
    'click .edit_non_findings_button': function (event, template) {
        Session.set("edit_mode", "non_findings");
    },
};

Template.main.created = function () {
    Session.set("edit_mode", null);
};

Template.main.helpers({
    editMode:function() {
        return Session.get("edit_mode");
    },
    findingButtonActive:function(){
        return Session.get("edit_mode") == "findings" ? "active" : "";
    },
    nonFindingButtonActive:function(){
        return Session.get("edit_mode") == "non_findings" ? "active" : "";
    },
    findingsEditorActive: function () {
        return Session.get("selected_finding");
    },
    nonFindingsEditorActive: function () {
        return Session.get("selected_non_finding");
    },
    editModeIs: function (mode) {
        return Session.get("edit_mode") == mode;
    },
});

/**
 * Findings Settings
 */
Template.findings_settings.helpers({
    findings_directory: function () {
        return Settings.findOne({_id: "findings_directory"}).value;
    },
    findings_library_directory: function () {
        return Settings.findOne({_id: "library_findings_directory"}).value;
    }
});

Template.findings_settings.events({
    "submit .update_findings_directory": function(event){
        event.preventDefault();
        var newvalue = event.target.findings_directory.value;
        Settings.update({_id: "findings_directory"}, {$set: {value: newvalue}});
        Session.set("selected_finding", null); // Prevents editor from emptying out on update
    },
    "submit .update_findings_library_directory": function(event){
        event.preventDefault();
        var newvalue = event.target.library_findings_directory.value;
        Settings.update({_id: "library_findings_directory"}, {$set: {value: newvalue}});
    }
});

/**
 * Non-Findings Settings
 */
Template.non_findings_settings.helpers({
    non_findings_directory: function () {
        return Settings.findOne({_id: "non_findings_directory"}).value;
    },
    non_findings_library_directory: function () {
        return Settings.findOne({_id: "non_findings_library_directory"}).value;
    }
});

Template.non_findings_settings.events({
    "submit .update_non_findings_directory": function(event){
        event.preventDefault();
        var newvalue = event.target.non_findings_directory.value;
        Settings.update({_id: "non_findings_directory"}, {$set: {value: newvalue}});
        Session.set("selected_non_finding", null); // Prevents editor from emptying out on update
    },
    "submit .update_non_findings_library_directory": function(event){
        event.preventDefault();
        var newvalue = event.target.non_findings_library_directory.value;
        Settings.update({_id: "non_findings_library_directory"}, {$set: {value: newvalue}});
    }
});



/**
 * FINDINGS_PANE
 */
Template.findings_pane.created = function () {
    this.activeTab = new ReactiveVar("pentest");
};

Template.findings_pane.helpers({
    isPentestTabActive:function () {
        return Template.instance().activeTab.get() == "pentest" ? "active" : null;
    },
    isLibraryTabActive:function () {
        return Template.instance().activeTab.get() == "library" ? "active" : null
    },
    editModeIs: function (mode) {
        return Session.get("edit_mode") == mode;
    },
    editMode: function() {
        return Session.get("edit_mode");
    }

});

Template.findings_pane.events({
    'click .pentest': function (event, template) {
        template.activeTab.set("pentest");
    },
    'click .library': function (event, template) {
        template.activeTab.set("library");
    },
});

/**
 * FINDINGS
 */
Template.findings.helpers({
    FindingsIndex: () => FindingsIndex,
    properties: () => { return {placeholder: "Enter filter term .."}},
});


/**
 * LIBRARY FINDINGS
 */
Template.library_findings.helpers({
    LibraryFindingsIndex: () => LibraryFindingsIndex,
    properties: () => { return {placeholder: "Enter filter term .."}}
});

/**
 * LIBRARY NON FINDINGS
 */
Template.library_non_findings.helpers({
    LibraryNonFindingsIndex: () => LibraryNonFindingsIndex,
    properties: () => { return {placeholder: "Enter filter term .."}}
});

/**
 * NON-FINDINGS
 */
Template.non_findings.helpers({
    NonFindingsIndex: () => NonFindingsIndex,
    properties: () => { return {placeholder: "Enter filter term .."}}
});


/**
 * FINDING
 */
Template.finding.events = {
    'click .search_result_title': function (e) {
        if (Session.get(this._id)) {
            Session.set(this._id, false);
        } else {
            Session.set(this._id, true);
        }
    }
};

Template.finding.helpers({
    shouldShowContent:function () {
        return Session.get(this._id);
    },
    bordercolor:function() {
        switch (this.valid) {
            case true:
                return "green";
            case false:
                return "red";
            default:
                return "";
        }
    },
    tooltip:function() {
        switch (this.valid) {
            case true:
                return "This file is a valid XML file. All elements can be copied to the editor";
            case false:
                return "This file is not a valid XML file. This means that not all elements can be copied to the editor. If your are missing text, manually copy and paste it from the raw view.";
            default:
                return "";
        }
    },
    typeIs: function (type) {
        return Template.parentData(1).index.config.name == type;
    }
});


/**
 * USE FINDING BUTTON
 */
Template.use_finding_button.events({
   "click": function () {
       Session.set("selected_finding", this._id);
       return false;
   }
});

Template.use_library_finding_button.events({
    "click": function () {
        var id = Session.get("selected_finding");
        if (!id) return false;

        Findings.update(id, {
            $set: {
                threat_level: this.threat_level,
                type: this.type,
                title: this.title,
                description: this.description,
                technical_description: this.technical_description,
                impact: this.impact,
                recommendation: this.recommendation

            }
        });
        return false;
    }
});

/**
 * LIBRARY NON FINDING BUTTON
 */
Template.use_library_non_finding_button.events({
    "click": function () {
        var id = Session.get("selected_non_finding");

        console.log(id);
        if (!id) return false;

        NonFindings.update(id, {
            $set: {
                title: this.title,
                description: this.description,
            }
        });
        return false;
    }
});


Template.use_non_finding_button.events({
    "click": function () {
        Session.set("selected_non_finding", this._id);
        return false;
    }
});
