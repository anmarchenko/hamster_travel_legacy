angular.module('travel').controller('GlobalSearchController', ['$scope', '$http', function ($scope, $http) {
    $scope.getTrips = function(value) {
        return $http.get('/api/trips.json?term=' + value).then(function (response) {
            return response.data;
        });
    };

    $scope.onSelect = function($item) {
        window.location = '/trips/' + $item.id;
    }

    $scope.showSearch = function () {
        $scope.showMobileSearch = true;
        $scope.search_term = '';
        var element = document.getElementById('global_search');
        if (element) {
            element.focus();
        }
    }

    $scope.hideSearch = function () {
        $scope.showMobileSearch = false;
    }
}]);
