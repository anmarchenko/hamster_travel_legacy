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
    $stateProvider.state({
        name: 'documents',
        url: '/documents',
        templateUrl: 'documentsTab.html'
    });
    $stateProvider.state({
        name: 'user_trips',
        url: '/trips',
        templateUrl: 'userTripsTab.html'
    });
    $stateProvider.state({
        name: 'user_map',
        url: '/map',
        templateUrl: 'userMapTab.html'
    });
}]);
