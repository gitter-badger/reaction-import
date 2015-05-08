Package.describe({
  name: 'teachmefly:reaction-collections-admin',
  summary: 'Fast add data to mongodb collections',
  version: '0.0.2',
  git: 'git@github.com:TeachMeFly/reaction-import.git',
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use([
    'meteor-platform',
    'reactive-var',
    'coffeescript',
    'less',
    'reactioncommerce:core@0.5.0',
    'cfs:standard-packages',
  ]);
  api.addFiles([
    'common/routing.coffee',
  ]);
  api.addFiles([
    'template/settings.html',
    'template/settings.coffee',
  ], 'client');
  api.addFiles([
    'server/register.coffee',
    'server/methods.coffee',
  ], 'server');
});
