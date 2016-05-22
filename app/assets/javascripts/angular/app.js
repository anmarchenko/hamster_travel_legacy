angular.module('travel-services', []);

angular.module('travel-components', ['ui.bootstrap', 'ui.sortable', 'ngCookies', 'ngAnimate', 'ngSanitize', 'ui.bootstrap-slider', 'sticky']);

angular.module('travel', ['travel-services', 'travel-components']);