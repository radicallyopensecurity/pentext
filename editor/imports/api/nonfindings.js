/**
 * Created by osboxes on 20/09/16.
 */
import { Mongo } from 'meteor/mongo';

export default NonFindings = new Mongo.Collection('non_findings');
export const NonFindingsIndex = new EasySearch.Index({
    collection: NonFindings,
    fields: ['filename', 'content'],
    engine: new EasySearch.Minimongo(),
    defaultSearchOptions: {
        null,
        limit: 10000
    }
});