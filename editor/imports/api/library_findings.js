import { Mongo } from 'meteor/mongo';

export const LibraryFindings = new Mongo.Collection('library_findings');
export const LibraryFindingsIndex = new EasySearch.Index({
        collection: LibraryFindings,
        fields: ['filename', 'content'],
        engine: new EasySearch.Minimongo(),
        defaultSearchOptions: {
            null,
            limit: 10000
        }
    });