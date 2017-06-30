angular.module('travel').controller('DaySorterController', [
    '$scope', '$uibModal', '$http', function($scope, $uibModal, $http) {
        $scope.startSorting = function(trip_id, fields) {
            $http.get("/api/trips/" + trip_id + "/days_sorting.json?locale=" + LOCALE).then(function(response) {
                $uibModal.open({
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
                        },
                        fields: function() {
                            return fields;
                        }
                    }
                });
            });
        };
    }
]);
