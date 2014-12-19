Package.describe({
  name: 'teachmefly:reaction-collections-admin',
  summary: 'Fast add data to mongodb collections',
  version: '0.0.1',
  //git: ' /* Fill me in! */ '
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use([
    'meteor-platform',
    'reactive-var',
    'coffeescript',
    'reactioncommerce:core',
    'cfs:standard-packages',
  ]);
  api.addFiles([
    'common/register.coffee',
  ]);
  api.addFiles([
    'common/app.coffee',
    'common/routing.coffee',
    'template/settings.html',
    'template/settings.coffee',
  ], 'client');
  api.addFiles([
    'server/methods.coffee'
  ], 'server');
});
