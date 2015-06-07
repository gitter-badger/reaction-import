ReactionCore.registerPackage
  name: 'reaction-import' # usually same as meteor package
  autoEnable: true # auto-enable in dashboard
 
  registry: [
    # all options except route and template
    # are used to describe the
    # dashboard 'app card'.
    {
      provides: 'dashboard'
      label: 'ImportData'
      description: "Easily import categories and products into Reaction Commerce"
      icon: 'fa fa-database' # glyphicon/fa
      cycle: '3' # Core, Stable, Testing (currently testing)
      container: 'dashboard'  #group this with settings
    }
    # configures settings link for app card
    # use 'group' to link to dashboard card
    {
      route: 'import'
      provides: 'settings'
      container: 'dashboard'
    }
    # configures template for checkout
    # paymentMethod dynamic template
    {
      template: 'collectionAdminSettings'
      provides: 'settings'
    }
  ]
  # array of permission objects
  permissions: [
    {
      label: "ImportData"
      permission: "dashboard/settings"
      group: "Shop Settings"
    }
  ]
