Template.importTab.created = ->
  @importData = new ReactiveVar new Array

Template.importTab.helpers
"importData": ->
  return Template.instance().importData.get()
"getDataObject": ->
  DataObject = new ReactiveVar new Array
  reader = new FileReader
  reader.onloadend = (event) ->
    DataObject.set EJSON.parse event.target.result
    #console.log DataObject.get()
  reader.readAsText @, 'utf-8'
  return DataObject



Template.importTab.events
  "submit #upload-form": (event, template) ->
    event.preventDefault()
    files = event.currentTarget.getElementsByClassName('upload-files').item(0).files
    _.forEach files, fileHandler

  #"dropped #drop-zone": (event, template) ->
    #saveHandler event
    # FS.Utility.eachFile event, (file) ->
      # unless /.+\.json$/.test file.name
      #   Alerts.add "Invalid file format, we need .json.", "danger", placement:"collectionAdminImport", i18n_key: "collectionAdminImport.wrongFormat", autoHide: 3000
      #   return false
        #throw new Meteor.Error('500', 'Invalid file format, we need .json')
        # importData = template.importData.get()
        # importData.push file
        # template.importData.set importData

fileHandler = (file) ->
  unless /.+\/json$/.test file.type
    throw new Meteor.Error "Invalid filetype"
  reader = new FileReader
  reader.onloadend = (event) ->
    dataObject = EJSON.parse event.target.result
    console.log dataObject

  reader.readAsText file, 'utf-8'

  console.log file.type

saveHandlerold = (item) ->
  if item.length
    item.addClass('list-group-item-warning')
    elementData = Blaze.getData item.get 0
    # updateTags
    saveTags elementData.tags.split('/'), null, ->
      saveProduct elementData, ->
        console.log "row saved"
        item.removeClass('list-group-item-warning').addClass('list-group-item-success')
        Meteor.setTimeout ->
          saveHandler item.next()
          ,3000

saveTags = (data, parentId, cb) ->
  currentTag = data.shift().match(/^\s*(.+?)\s*$/)[1]
  Meteor.call "updateHeaderTags", currentTag, null, parentId, (error) ->
    if error
      throw new Error "somethind wrong in tags"
    currentTagInstance = Tags.findOne "name":currentTag
    unless data.length
      cb()
      return
    saveTags data, currentTagInstance._id, cb

saveProduct = (data, cb) ->
  Meteor.call "createProduct", (error, result) ->
    currentId = result
    Products.update(currentId, {$set: {isVisible: data.isVisible}})
    Meteor.call "updateProductField", currentId, "title", data.title, ->
      Meteor.call "updateProductField", currentId, "pageTitle", data.pageTitle, ->
        Meteor.call "updateProductField", currentId, "vendor", data.vendor, ->
          Meteor.call "updateProductField", currentId, "description", data.description, ->
            productSetTags currentId, data, ->
              productSetVariants currentId, data.variants, ->
                console.log currentId
                cb()

productSetTags = (currentId, data, cb) ->
  tags = data.tags.split '/'
  setTag = (tagsArray, setTagCb) ->
    currentTag = tagsArray.shift().match(/^\s*(.+?)\s*$/)[1]
    currentTagInstance = Tags.findOne "name":currentTag
    Meteor.call "updateProductTags", currentId, currentTag, null, null, (error) ->
      if error
        throw new Error error
        unless tagsArray.length
          Meteor.call "setHandleTag", currentId, currentTagInstance._id, (error) ->
            if error
              throw new Error error
              setTagCb()
              return
              setTag tagsArray, setTagCb
              setTag tags, cb

productSetVariants = (currentId, variants, cb) ->
  currentVariant = variants.pop()
  unless currentVariant
    variantInstance = Products.findOne({"_id": currentId})
    Meteor.call "deleteVariant", variantInstance.variants[0]._id, ->
      cb()
      return
    Meteor.call "createVariant", currentId, ->
      variantInstance = Products.findOne({"_id": currentId})
      variantModel =
        "_id": variantInstance.variants[variantInstance.variants.length - 1]._id
        "title": currentVariant.title
        "price": currentVariant.price
        "weight": 35
        "inventoryQuantity": 10
        "inventoryManagement": true
        "inventoryPolicy": true
        "taxable": true
      Meteor.call "updateVariant", variantModel, ->
        variantAddImage currentId, variantModel._id, currentVariant.image, variantInstance.variants.length - 1, ->
          productSetVariants currentId, variants, cb

variantAddImage = (currentId, variantId, image, count, cb) ->
  unless image
    cb()
    return
    file = new FS.File
    file.attachData image.binarydata, {type:image.type}
    file.name image.name
    file.metadata =
      ownerId: Meteor.userId()
      productId: currentId
      variantId: variantId
      shopId: ReactionCore.getShopId()
      priority: count
    console.log file
    ReactionCore.Collections.Media.insert file, ->
      cb()

Template.fileInfo.events
  "click #save": (event, template) ->
    saveHandler template.$('.importItem:first')

Template.fileInfo.helpers
  "makeTagsTree": ->
    @.get().map (item) ->
      console.log item.tags
      console.log @.get()

  "get": ->
    return @get()
