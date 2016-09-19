angular.module('travel').controller('UserTripsController', ['$scope', '$http', function ($scope, $http) {
    $scope.loaded = false;

    $scope.load = function () {
        $http.get('/' + LOCALE + '/api/users/' + $scope.$ctrl.userId + '/' + $scope.$ctrl.path).then(function (response) {
            $scope.trips = response.data.trips;
            $scope.loaded = true;
        });
    };

    $scope.load();
}]);