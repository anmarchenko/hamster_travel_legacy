angular.module('travel').controller('GlobalSearchController', ['$scope', '$http', function ($scope, $http) {
    $scope.getTrips = function(value) {
        return $http.get('/api/trips.json?term=' + value).then(function (response) {
            return response.data;
        });
    };

    $scope.onSelect = function($item) {
        window.location = '/trips/' + $item.id;
    }

    $scope.searchClicked = function () {
        $scope.showMobileSearch = !$scope.showMobileSearch;
        $scope.search_term = '';
    }
}]);
