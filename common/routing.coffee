Router.map ->
    @route 'dashboard/collectionsadmin',
        controller: ShopAdminController
        template: "collectionAdminSettings"
        waitOn: ->
            @subscribe "products"
            @subscribe "tags"
