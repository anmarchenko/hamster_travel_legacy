angular.module('travel').component('userTrips', {
    controller: 'UserTripsController',
    templateUrl: 'userTrips.html',
    bindings: {
        userId: '<',
        path: '<',
        header: '<'
    }
});