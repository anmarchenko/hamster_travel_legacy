angular.module 'travel-services', ['rails']
angular.module 'travel-components', ['ui.bootstrap', 'ui.bootstrap.datetimepicker', 'ui.sortable', 'ngCookies',
                                        'ngAnimate']

angular.module 'travel', ['travel-services', 'travel-components']
