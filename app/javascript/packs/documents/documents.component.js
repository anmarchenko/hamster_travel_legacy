angular.module('travel').component('documents', {
    controller: 'DocumentsController',
    templateUrl: 'documents.html',
    bindings: {
        tripId: '<'
    }
});