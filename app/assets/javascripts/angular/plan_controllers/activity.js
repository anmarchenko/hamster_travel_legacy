angular.module('travel-components').controller('ActivityController'
    , [
        '$scope'
        , function ($scope) {
            $scope.show_more = false;

            $scope.showMore = function () {
                return $scope.show_more;
            }

            $scope.triggerShowMore = function () {
                $scope.show_more = !$scope.show_more;
            }

            $scope.init = function (activity) {
                if(activity && !activity.name){
                    $scope.show_more = true;
                }
            }

            $scope.$on('activities_show_more', function (event, show_more) {
                    $scope.show_more = show_more;
                }
            )
        }

    ]
)