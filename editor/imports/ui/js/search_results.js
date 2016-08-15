/**
 * Created by osboxes on 12/08/16.
 */
import { Snippets } from '../../api/snippets.js';
import { Template } from 'meteor/templating';

Template.search_results.helpers({
    results() {
        return Snippets.find({}).count();
    }
});

