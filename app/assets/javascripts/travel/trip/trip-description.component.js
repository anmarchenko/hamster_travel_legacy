angular.module('travel').component('tripDescription', {
    controller: 'TripDescriptionController',
    templateUrl: 'tripDescription.html',
    bindings: {
        text: '<'
    }
});