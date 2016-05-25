angular.module('travel-components').controller('ActivitiesDayController'
    , [
        '$scope', '$timeout', '$rootScope', '$http'
        , function ($scope, $timeout, $rootScope, $http) {
            $scope.day = {}
            $scope.day_id = null;
            $scope.trip_id = null;
            $scope.new_activity_template = {};

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
                $http.get("/api/trips/" + $scope.trip_id + "/days/" + $scope.day_id + "/activities").success(function (day) {
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
            };

            $scope.load = function (trip_id, day_id, new_activity_template) {
                $scope.day_id = day_id;
                $scope.trip_id = trip_id;
                $scope.new_activity_template = new_activity_template;
            };

            $scope.save = function (skip_notification) {
                $scope.saving = true;

                $http.post("/api/trips/" + $scope.trip_id + "/days/" + $scope.day.id + "/activities",
                    {day: $scope.day}).success(function () {
                    $scope.reload();
                    $scope.saving = false;

                    if (!skip_notification) {
                        toastr["success"]($('#notification_saved').text());
                    }
                })
            };

            $scope.expensesPresent = function () {
                return $scope.day.expenses && $scope.day.expenses.length > 0 && $scope.day.expenses[0].amount_cents > 0;
            };

            $scope.bookmarksPresent = function () {
                return $scope.day.links && $scope.day.links.length > 0 && $scope.day.links[0].url;
            };

            $scope.triggerShowMore = function () {
                $scope.show_more = !$scope.show_more;

                $scope.$broadcast('activities_show_more', $scope.show_more)
            };

            $scope.setDefaults = function () {
                if ($scope.day.activities.length == 0) {
                    var obj = {};
                    angular.copy($scope.new_activity_template, obj);
                    $scope.day.activities = [obj];
                }

                if ($scope.day.links.length == 0) {
                    $scope.day.links = [{}];
                }
            };

            $scope.startEdit = function () {
                if ($scope.reloading) {
                    return;
                }
                $scope.edit = true;
                $scope.setDefaults();
            };

            $scope.cancelEdit = function (no_reload) {
                $scope.edit = false;

                if (!no_reload) {
                    $scope.reload();
                }
            };

            $scope.onDragFinish = function (e, ui) {
                if (!$scope.edit) {
                    $scope.save(true);
                }
            };

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
            );

            $scope.$on('day_activities_updated', function (event, day) {
                    if ($scope.day.id == day.id) {
                        $scope.day = day;

                        $scope.reloading = false;
                    }
                }
            );

            $scope.$on('day_activities_loaded', function (event, day) {
                    if (day.id == $scope.day_id) {
                        $scope.day = day;

                        $timeout(function () {
                            $scope.day_loaded = true;
                        }, Math.random() * 1000
                        )
                    }
                }
            );

            $rootScope.$on('move_activity', function (event, payload) {
                if ($scope.day.id == payload.source_id) {
                    var activity_index = undefined;
                    // TODO: rewrite with ES6
                    for (var i = 0; i < $scope.day.activities.length; i++) {
                        if ($scope.day.activities[i].id == payload.activity.id) {
                            activity_index = i;
                        }
                    }
                    if (activity_index != undefined) {
                        $scope.day.activities.splice(activity_index, 1);
                        $scope.save(true);

                        if ($scope.edit) {
                            $scope.setDefaults();
                        }
                    }
                }
                if ($scope.day.id == payload.target_id) {
                    $scope.day.activities.push(payload.activity);
                    $scope.save(true);
                }
            })

        }

    ]
)