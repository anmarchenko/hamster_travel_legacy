angular.module('travel-components').controller('ActivityMovePopupController'
    , [
        '$scope', '$rootScope'
        , function ($scope, $rootScope) {
            // logic

            $scope.init = function (activity, day) {
                $scope.moved_activtiy = activity;
                $scope.source_day = day;
                $scope.target_day_id = day.id;
            }

            $scope.moveActivity = function () {
                // close popover
                $('body').trigger('click');

                $rootScope.$emit('move_activity', {
                    source_id: $scope.source_day.id,
                    target_id: $scope.target_day_id,
                    activity: $scope.moved_activtiy
                });
            }
        }

    ]
)