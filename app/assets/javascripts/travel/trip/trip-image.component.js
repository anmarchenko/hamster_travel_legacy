angular.module('travel').component('tripImage', {
    controller: 'TripImageController',
    templateUrl: 'tripImage.html',
    bindings: {
        tripId: '<',
        imageUrl: '<',
        edit: '<'
    }
});