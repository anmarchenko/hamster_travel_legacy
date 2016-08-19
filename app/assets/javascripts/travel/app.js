angular.module('travel', ['ui.bootstrap', 'ui.sortable', 'ngCookies', 'ngAnimate', 'ngSanitize',
    'ui.bootstrap-slider', 'sticky', 'ui.router']).config(['$compileProvider', function ($compileProvider) {
    $compileProvider.debugInfoEnabled(false);
}]);
