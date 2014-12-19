Meteor.methods
    getCollectionDump: (collectionName) ->
        unless Roles.userIsInRole(Meteor.userId(), ['admin'])
            throw new Meteor.Error 403, "No permission to access"
        unless ReactionCore.Collections[collectionName]
            throw new Meteor.Error 500, "Collection not exist"
        return new DataMan(EJSON.stringify(
            ReactionCore.Collections[collectionName].find().fetch(),
             null, '\t'), {type: "text/plain;charset=utf-8"})

    wipeCollections: ->
        unless Roles.userIsInRole(Meteor.userId(), ['admin'])
            throw new Meteor.Error 403, "No permission to access"
        Tags.remove({})
        Products.remove({})

