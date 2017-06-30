angular.module('travel').controller('ActivitiesPlanController', [
        '$scope', '$http', function ($scope, $http) {
            var activitiesUrl = function() {
              return "/api/trips/" + $scope.trip_id + "/days_activities?locale=" + LOCALE;
            }

            $scope.initActivities = function (trip_id) {
                $scope.trip_id = trip_id;
                $http.get(activitiesUrl()).then( function(response) {
                    // TODO: ES6
                    for (var i = 0; i < response.data.days.length; i++) {
                        var day = response.data.days[i];
                        $scope.$broadcast('day_activities_loaded', day);
                    }
                })
            };
        }
    ]
)
