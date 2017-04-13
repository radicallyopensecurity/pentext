/**
 * Created by osboxes on 20/09/16.
 */
import { Mongo } from 'meteor/mongo';

export default Findings = new Mongo.Collection('findings');
export const FindingsIndex = new EasySearch.Index({
    collection: Findings,
    fields: ['filename', 'content'],
    engine: new EasySearch.Minimongo(),
    defaultSearchOptions: {
        null,
        limit: 10000
    }
});