angular.module('travel').component('document', {
    controller: 'DocumentController',
    templateUrl: 'document.html',
    bindings: {
        document: '<',
        tripId: '<',
        deleteSuccessMessage: '<',
        saveSuccessMessage: '<',
        saveErrorMessage: '<',
        onChange: '&'
    }
});
