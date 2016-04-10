angular.module('travel-components').controller('ActivityController'
    , [
        '$scope', 'Activities'
        , function ($scope, Activities) {
            $scope.day_id = null;
            $scope.trip_id = null;

            $scope.show_more = false;

            $scope.showMore = function () {
                return $scope.show_more;
            }

            $scope.triggerShowMore = function () {
                $scope.show_more = !$scope.show_more;
            }

            $scope.$on('activities_show_more', function (event, show_more) {
                    $scope.show_more = show_more;
                }
            )
        }

    ]
)