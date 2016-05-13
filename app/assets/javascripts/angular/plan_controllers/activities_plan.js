angular.module('travel-components').controller('ActivitiesPlanController'
    , [
        '$scope', 'Days'
        , function ($scope, Days) {

            $scope.planDays = [];
            $scope.saving = false;

            $scope.initActivities = function (trip_id) {
                $scope.trip_id = trip_id;
                Days.getActivities($scope.trip_id).then( function(response) {
                    // TODO: ES6
                    for (var i = 0; i < response.data.days.length; i++) {
                        var day = response.data.days[i];
                        $scope.planDays.push(day);
                        $scope.$broadcast('day_activities_loaded', day);
                    }
                })
            }

            $scope.savePlan = function () {
                if ($scope.saving) {
                    return;
                }
                $scope.saving = true;
                $scope.saveTrip();

                Days.saveWithActivities($scope.trip_id, $scope.planDays).success(function () {
                    $scope.saving = false;
                    toastr["success"]($('#notification_saved').text());

                    $scope.loadBudget();
                    $scope.loadCountries();
                })
            }


            $scope.cancelEdits = function () {
                $scope.cancelEditsPlan();

                $scope.planDays = [];
                Days.getActivities($scope.trip_id).then( function(response) {
                    // TODO: ES6
                    for (var i = 0; i < response.data.days.length; i++) {
                        var day = response.data.days[i];
                        $scope.planDays.push(day);
                        $scope.$broadcast('day_activities_updated', day);
                    }
                })

            }

            // TODO: ES6
            $scope.$on('day_activities_reloaded', function(event, day) {
                for (var i = 0; i < $scope.planDays.length; i++) {
                    if($scope.planDays[i].id === day.id) {
                        $scope.planDays.splice(i, 1);
                        break;
                    }
                }
                $scope.planDays.push(day);
            })

        }
    ]
)
