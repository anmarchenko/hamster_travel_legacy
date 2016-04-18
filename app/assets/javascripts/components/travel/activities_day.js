angular.module('travel-components').controller('ActivitiesDayController'
    , [
        '$scope', 'Activities'
        , function ($scope, Activities) {
            $scope.day = {}
            $scope.day_id = null;
            $scope.trip_id = null;

            $scope.day_loaded = false;

            $scope.show_more = false;
            $scope.edit = false;
            $scope.saving = false;
            $scope.reloading = false;

            $scope.reload = function () {
                if (!$scope.edit) {
                    $scope.reloading = true;
                }
                Activities.get($scope.trip_id, $scope.day_id).success(function (day) {
                    $scope.day = day;

                    $scope.loadBudget();
                    $scope.loadCountries();
                    if ($scope.edit) {
                        $scope.setDefaults();
                    }

                    $scope.reloading = false;
                })
            }

            $scope.load = function (trip_id, day_id) {
                $scope.day_id = day_id;
                $scope.trip_id = trip_id;
                Activities.get($scope.trip_id, $scope.day_id).success(function (day) {
                    $scope.day = day;
                    $scope.day_loaded = true;
                })
            }

            $scope.save = function () {
                $scope.saving = true;

                Activities.saveAll($scope.trip_id, $scope.day).success(function (data) {
                    $scope.reload();
                    $scope.saving = false;
                })
            }

            $scope.expensesPresent = function () {
                return $scope.day.expenses && $scope.day.expenses.length > 0 && $scope.day.expenses[0].amount_cents > 0;
            }

            $scope.bookmarksPresent = function () {
                return $scope.day.links && $scope.day.links.length > 0 && $scope.day.links[0].url;
            }

            $scope.triggerShowMore = function () {
                $scope.show_more = !$scope.show_more;

                $scope.$broadcast('activities_show_more', $scope.show_more)
            }

            $scope.setDefaults = function () {
                if ($scope.day.activities.length == 0) {
                    $scope.day.activities = [$scope.new_activity_template];
                }

                if ($scope.day.links.length == 0) {
                    $scope.day.links = [{}];
                }
            }

            $scope.startEdit = function (new_activity) {
                if ($scope.reloading){
                    return;
                }
                $scope.edit = true;
                $scope.new_activity_template = new_activity;
                $scope.setDefaults();
            }

            $scope.cancelEdit = function () {
                $scope.edit = false;

                $scope.reload();
            }

        }

    ]
)