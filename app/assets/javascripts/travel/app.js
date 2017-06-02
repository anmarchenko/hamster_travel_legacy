angular.module('travel', ['ui.bootstrap', 'ui.sortable', 'ngCookies', 'ngAnimate', 'ngSanitize',
    'ui.bootstrap-slider', 'sticky', 'ui.router', 'ngFileUpload', 'ngImgCrop',
    'tandibar/ng-rollbar']
).config(['$compileProvider', function ($compileProvider) {
    $compileProvider.debugInfoEnabled(false);
}]).config(['RollbarProvider', function(RollbarProvider) {
    RollbarProvider.init({
      accessToken: '9e8f6681c68340a2a1e65cf1476e50b8',
      captureUncaught: true,
      payload: {
        environment: ENVIRONMENT
      }
    });
}]);
