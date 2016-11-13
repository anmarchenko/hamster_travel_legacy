angular.module('travel').component('tripDeleteLink', {
    controller: 'TripDeleteLinkController',
    templateUrl: 'tripDeleteLink.html',
    bindings: {
        tripId: '@'
    }
});

angular.module('travel').controller('TripDeleteLinkController', ['$scope', '$http',
  function ($scope, $http) {
    $scope.deleteTrip = function() {
      $http.delete('/api/trips/' + $scope.$ctrl.tripId).success(function(data){
        window.location.href = '/' + LOCALE + '/trips/my';
      }).error(function(data){
        console.log(data);
        swal({
            title: 'Internal error',
            text: 'Something went wrong',
            type: 'error'
        });
      });
    }
}]);
