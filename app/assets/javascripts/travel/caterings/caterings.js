angular.module('travel').controller('CateringsController'
    , [
        '$scope', '$http'
        , function ($scope, $http) {

            $scope.caterings = [];
            $scope.caterings_loaded = false;

            $scope.init = function (trip_id) {
                $scope.trip_id = trip_id;
                $scope.load();
            };

            $scope.load = function () {
                $http.get('/api/caterings/' + $scope.trip_id).then( function(response) {
                    $scope.caterings = response.data.caterings;
                    $scope.caterings_loaded = true;
                })
            };

            $scope.savePlan = function () {
                if ($scope.saving) {
                    return;
                }
                $scope.saving = true;

                $http.put('/api/caterings/' + $scope.trip_id, {trip: {caterings: $scope.caterings}}).then(function () {
                    $scope.saving = false;

                    toastr["success"]($('#notification_saved').text());

                    $scope.loadBudget();
                })
            };


            $scope.cancelEdits = function () {
                $scope.cancelEditsPlan();
                $scope.load();
            }
        }
    ]
)
