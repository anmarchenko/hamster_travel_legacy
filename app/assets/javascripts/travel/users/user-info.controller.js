angular.module('travel').controller('UserInfoController', [ '$scope', '$http', function ($scope, $http) {
    $scope.loaded = false;

    $scope.load = function () {
        $http.get(`/api/users/${$scope.$ctrl.userId}`).then(function (response) {
            $scope.user = response.data.user;

            $scope.loaded = true;
        });
    };

    $scope.load();
}]);
