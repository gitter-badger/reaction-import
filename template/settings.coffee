Template.importTab.created = ->
  @importData = new ReactiveVar new Array

Template.importTab.events
  "submit #upload-form": (event, template) ->
    event.preventDefault()
    files = event.currentTarget.getElementsByClassName('upload-files').item(0).files
    _.forEach files, (file) ->
      unless /.+\/json$/.test file.type
        throw new Meteor.Error "Invalid filetype"
      reader = new FileReader
      reader.onloadend = (event) ->
        dataObject = EJSON.parse event.target.result
        Meteor.call "parseData", dataObject, (error, result) ->
          console.log error

      reader.readAsText file, 'utf-8'

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
