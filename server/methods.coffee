# Tag insertion method
insertTag = (name, parentId) ->
  tag = Tags.findOne "name":name

  unless tag
    newTag =
      slug: getSlug name
      name: name
      isTopLevel: !parentId
      shopId: ReactionCore.getShopId()
      updatedAt: new Date()
      createdAt: new Date()
    newTagId = Tags.insert newTag

  tagId = tag && tag._id || newTagId

  # If parentId is set, then update parent tag
  if parentId
    Tags.update parentId, {$addToSet: {"relatedTagIds": tagId}}

  return tagId

# Image insertion method
Media = ReactionCore.Collections.Media
insertMedia = (mediaUrl, productId, variantId) ->
  console.log mediaUrl, productId, variantId
  Media.insert mediaUrl, (error, media) ->
    console.log media._id
    Media.update media._id, $set:
      metadata:
        #ownerId: @userId()
        productId: productId
        variantId: variantId
        shopId: ReactionCore.getShopId()
        priority: 0 # this is new product

  return 'mediaId'

# Product insertion method
priceParser = (string) ->
  price = 0.00
  #if string === String
  #  price = parseFloat string

  return price

insertProduct = (product, parentId) ->
  newProductVariants = [
    _id: Random.id()
    title: ""
    price: priceParser product.price
  ]
  newProduct =
    _id: Random.id()
    title: product.name
    # TODO make dynamic variants
    variants: newProductVariants
    hashtags: [parentId]
    isVisible: true
  productId = Products.insert newProduct, validate: false
  mediaId = insertMedia product.img, productId, newProductVariants[0]._id

  return productId

# For recursive call
objectHandler = (item, parentId) ->
  currentId = insertTag item.name, parentId
  item.childs && item.childs.forEach (item) ->
    objectHandler item, currentId
  item.products && item.products.forEach (item) ->
    insertProduct item, currentId

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

    parseData: (dataObj) ->
      @unblock
      check dataObj, Array
      dataObj.forEach (item) ->
        objectHandler item

