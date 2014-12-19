ReactionCore.registerPackage
    name: "reaction-collections-admin"
    label: "Collection Admin"
    description: "Add some usability for manage collections"
    overviewRoute: 'dashboard/collectionsadmin'
    icon: "fa fa-cog"
    hasWidget: false
    autoEnable: true
    shopPermissions: [
        {
            label: "Collection Dumps"
            permission: "dashboard/collectionsadmin"
            group: "Shop Management"
        }
    ]
