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

            $scope.reload = function () {
                Activities.index($scope.trip_id, $scope.day_id).success(function (day) {
                    $scope.day = day;

                    $scope.loadBudget();
                    $scope.loadCountries();
                })
            }

            $scope.load = function (trip_id, day_id) {
                $scope.day_id = day_id;
                $scope.trip_id = trip_id;
                Activities.index($scope.trip_id, $scope.day_id).success(function (day) {
                    $scope.day = day;
                    $scope.day_loaded = true;
                })
            }


            $scope.expensesPresent = function(){
                return $scope.day.expenses && $scope.day.expenses.length > 0 && $scope.day.expenses[0].amount_cents > 0;
            }

            $scope.bookmarksPresent = function(){
                return $scope.day.links && $scope.day.links.length > 0 && $scope.day.links[0].url;
            }

            $scope.triggerShowMore = function () {
                $scope.show_more = !$scope.show_more;

                $scope.$broadcast('activities_show_more', $scope.show_more)
            }

            $scope.startEdit = function () {
                $scope.edit = true;
            }
            $scope.cancelEdit = function () {
                $scope.edit = false;

                $scope.reload();
            }

        }

    ]
)