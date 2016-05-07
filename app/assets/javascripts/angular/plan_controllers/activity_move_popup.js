angular.module('travel-components').controller('ActivityMovePopupController'
    , [
        '$scope'
        , function ($scope) {
            // logic

            $scope.init = function (activity, days) {
                $scope.moved_activtiy = activity;
                $scope.plan_days_info = days;
            }
        }

    ]
)