angular.module('travel-components').controller('ActivityMovePopupController'
    , [
        '$scope'
        , function ($scope) {
            // logic

            $scope.init = function (activity, day) {
                $scope.moved_activtiy = activity;
                $scope.source_day = day;
                $scope.target_day_id = day.id;
            }

            $scope.moveActivity = function ($event) {
                // close popover
                $('body').trigger('click');
            }
        }

    ]
)