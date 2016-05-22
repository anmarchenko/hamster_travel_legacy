angular.module('travel-components').controller('TransfersDayController'
    , [
        '$scope', '$http'
        , function ($scope, $http) {

            var EDIT_VARIABLES;

            EDIT_VARIABLES = ['place', 'transfer', 'comment', 'hotel'];

            $scope.setEdit = function(val, object, new_object) {
                if (val) {
                    return $scope.reload(function(day) {
                        $scope[object + "_edit"] = val;
                        if (object === 'transfer' && day.transfers.length === 0) {
                            return day.transfers = [new_object];
                        }
                    });
                } else {
                    return $scope[object + "_edit"] = val;
                }
            };

            $scope.reload = function(callback) {
                if (callback == null) {
                    callback = null;
                }
                return $scope.tripService.reloadDay($scope.day, function() {
                    $scope.setEditAll(false);
                    $scope.loadBudget();
                    $scope.loadCountries();
                    if (callback) {
                        return callback($scope.day);
                    }
                });
            };

            $scope.save = function() {
                return $scope.tripService.updateDay($scope.day).then(function() {
                    return $scope.reload();
                });
            };

            $scope.setEditAll = function(val) {
                for (var i = 0, len = EDIT_VARIABLES.length; i < len; i++) {
                    $scope.setEdit(val, EDIT_VARIABLES[i]);
                }
            };

            $scope.setEditAll(false);
        }
    ]
)
