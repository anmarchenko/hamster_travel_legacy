angular.module('travel-components').controller('EditingUsersController'
    , [
        '$scope', '$http', '$interval', function ($scope, $http, $interval) {
            $scope.editing_users = [];

            $scope.init = function (trip_id) {
                $scope.trip_id = trip_id;

                var promise = $interval(function () {
                    $http.get("/api/user_shows/" + $scope.trip_id).success(function (response) {
                        $scope.editing_users = response;
                    }).error(function () {
                        $interval.cancel(promise);
                    });
                }, 10000);
            }

        }
    ]
)