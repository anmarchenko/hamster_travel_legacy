angular.module('travel-services', []);

angular.module('travel-components', ['ui.bootstrap', 'ui.sortable', 'ngCookies', 'ngAnimate', 'ngSanitize',
                                     'ui.bootstrap-slider', 'sticky', 'ui.router']);

angular.module('travel', ['travel-services', 'travel-components']).config(['$compileProvider', function ($compileProvider) {
    $compileProvider.debugInfoEnabled(false);
}]);