angular.module('travel').component('userTrips', {
    controller: 'UserTripsController',
    templateUrl: 'userTrips.html',
    bindings: {
        userId: '<',
        path: '<',
        header: '<'
    }
});

angular.module('travel').controller('UserTripsController', ['$scope', '$http', function ($scope, $http) {
    $scope.loaded = false;

    $scope.$ctrl.$onInit = function() {
      $scope.load();
    }

    $scope.load = function () {
        $http.get('/' + LOCALE + '/api/users/' + $scope.$ctrl.userId + '/' + $scope.$ctrl.path).then(function (response) {
            $scope.trips = response.data.trips;
            $scope.loaded = true;
        });
    };
}]);
