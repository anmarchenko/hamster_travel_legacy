angular.module('travel').config(['$stateProvider', function($stateProvider) {
    $stateProvider.state({
        name: 'transfers',
        url: '/transfers',
        templateUrl: 'transfersTab.html'
    });
    $stateProvider.state({
        name: 'activities',
        url: '/activities',
        templateUrl: 'activitiesTab.html'
    });
    $stateProvider.state({
        name: 'catering',
        url: '/catering',
        templateUrl: 'cateringTab.html'
    });
    $stateProvider.state({
        name: 'report',
        url: '/report',
        templateUrl: 'reportTab.html'
    });
}]);
