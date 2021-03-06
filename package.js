Package.describe({
  name: 'dukeondope:reaction-data-manager',
  summary: 'Fast add data to mongodb collections',
  version: '0.0.3',
  git: 'https://github.com/dukeondope/reaction-import.git',
});

Package.onUse(function(api) {
  api.versionsFrom('METEOR@1.0');
  api.use([
    'meteor-platform',
    'reactioncommerce:core',
    'coffeescript',
    'less',
    'underscore',
    'jquery',
  ]);
  api.use([
    'reactive-var',
    'http',
    'cfs:standard-packages',
  ]);
  api.addFiles([
    'common/routing.coffee',
  ], 'client');
  api.addFiles([
    'template/settings.html',
    'template/settings.coffee',
    'template/style.css',
  ], 'client');
  api.addFiles([
    'server/register.coffee',
    'server/methods.coffee',
  ], 'server');
});
