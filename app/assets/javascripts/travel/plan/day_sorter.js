angular.module('travel-components').controller('DaySorterController', [
    '$scope', '$uibModal', '$http', function($scope, $uibModal, $http) {
        return $scope.startSorting = function(trip_id) {
            return $http.get("/api/trips/" + trip_id + "/days_sorting.json?locale=" + LOCALE).then(function(response) {
                return $uibModal.open({
                    animation: true,
                    templateUrl: 'daySortModal.html',
                    controller: 'DaySorterModalController',
                    size: 'lg',
                    resolve: {
                        days: function() {
                            return response.data;
                        },
                        trip_id: function() {
                            return trip_id;
                        }
                    }
                });
            });
        };
    }
]);
