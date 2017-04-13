import { Mongo } from 'meteor/mongo';

export const LibraryNonFindings = new Mongo.Collection('library_non_findings');
export const LibraryNonFindingsIndex = new EasySearch.Index({
        collection: LibraryNonFindings,
        fields: ['filename', 'content'],
        engine: new EasySearch.Minimongo(),
        defaultSearchOptions: {
            null,
            limit: 10000
        }
    });