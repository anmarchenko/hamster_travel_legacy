angular.module('travel-components').controller('ActivitiesDayController'
    , [
        '$scope', 'Activities', '$timeout'
        , function ($scope, Activities, $timeout) {
            $scope.day = {}
            $scope.day_id = null;
            $scope.trip_id = null;

            $scope.day_loaded = false;

            $scope.show_more = false;

            $scope.edit = false;
            $scope.whole_plan_edit = false;

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

                    // send this day to parent controller
                    $scope.$emit('day_activities_reloaded', day)
                })
            }

            $scope.load = function (trip_id, day_id) {
                $scope.day_id = day_id;
                $scope.trip_id = trip_id;
            }

            $scope.save = function (skip_notification) {
                $scope.saving = true;

                Activities.saveAll($scope.trip_id, $scope.day).success(function () {
                    $scope.reload();
                    $scope.saving = false;

                    if (!skip_notification){
                        toastr["success"]($('#notification_saved').text());
                    }
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
                if ($scope.reloading) {
                    return;
                }
                $scope.edit = true;
                if (new_activity) {
                    $scope.new_activity_template = new_activity;
                }
                $scope.setDefaults();
            }

            $scope.cancelEdit = function (no_reload) {
                $scope.edit = false;

                if (!no_reload) {
                    $scope.reload();
                }
            }

            $scope.onDragFinish = function (e, ui) {
                if (!$scope.edit) {
                    $scope.save(true);
                }
            }

            $scope.$on('whole_plan_edit', function (event, edit) {
                    if (edit) {
                        $scope.whole_plan_edit = true;
                        $scope.startEdit();
                    } else {
                        $scope.whole_plan_edit = false;
                        $scope.cancelEdit(true);
                        $scope.reloading = true;
                    }
                }
            )

            $scope.$on('day_activities_updated', function (event, day) {
                    if ($scope.day.id == day.id) {
                        $scope.day = day;

                        $scope.reloading = false;
                    }
                }
            )

            $scope.$on('day_activities_loaded', function (event, day) {
                    if (day.id == $scope.day_id) {
                        $scope.day = day;

                        $timeout(function () {
                                $scope.day_loaded = true;
                            }, Math.random() * 1000
                        )
                    }
                }
            )

        }

    ]
)