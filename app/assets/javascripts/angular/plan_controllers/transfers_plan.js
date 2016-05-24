angular.module('travel-components').controller('TransfersPlanController'
    , [
        '$scope', '$http', '$cookies'
        , function ($scope, $http, $cookies) {

            $scope.days = [];
            $scope.saving = false;

            $scope.transfersCollapsed = true;

            $scope.init = function (trip_id) {
                $scope.trip_id = trip_id;

                // TODO: ES6
                var columns = ['show_place', 'show_transfers', 'show_hotel'];
                for (var i = 0, len = columns.length; i < len; i++) {
                    $scope.restoreVisibilityFromCookie(columns[i]);
                }

                $http.get("/api/v2/trips/" + $scope.trip_id + "/days_transfers").then( function(response) {
                    // TODO: ES6
                    for (var i = 0; i < response.data.days.length; i++) {
                        var day = response.data.days[i];
                        $scope.days.push(day);
                        $scope.$broadcast('day_transfers_loaded', day);

                        $scope.collapseTransfers(day);
                    }
                })
            };

            $scope.savePlan = function () {
                if ($scope.saving) {
                    return;
                }
                $scope.saving = true;

                $http.post("/api/v2/trips/" + $scope.trip_id + "/days_transfers/", {days: $scope.days}).success(function () {
                    $scope.saving = false;
                    toastr["success"]($('#notification_saved').text());

                    $scope.loadBudget();
                    $scope.loadCountries();
                })
            };

            $scope.cancelEdits = function () {
                $scope.cancelEditsPlan();
                $scope.days = [];
                $http.get("/api/v2/trips/" + $scope.trip_id + "/days_transfers").then( function(response) {
                    // TODO: ES6
                    for (var i = 0; i < response.data.days.length; i++) {
                        var day = response.data.days[i];
                        $scope.days.push(day);
                        $scope.collapseTransfers(day);
                        $scope.$broadcast('day_transfers_updated', day);
                    }
                })
            };

            $scope.$on('day_transfers_reloaded', function(event, day) {
                for (var i = 0; i < $scope.days.length; i++) {
                    if($scope.days[i].id === day.id) {
                        $scope.days.splice(i, 1);
                        break;
                    }
                }
                $scope.days.push(day);
            });

            $scope.restoreVisibilityFromCookie = function(column) {
                var cookie_val, key;
                key = $scope.trip_id + "_" + column;
                cookie_val = $cookies.get(key);
                if (cookie_val === void 0) {
                    return $scope[column] = true;
                } else {
                    return $scope[column] = cookie_val === 'true';
                }
            };

            $scope.saveVisibilityToCookie = function(column) {
                var key;
                key = $scope.trip_id + "_" + column;
                $cookies.put(key, $scope[column]);
            };

            $scope.changeVisibility = function(column) {
                $scope[column] = !$scope[column];
                $scope.saveVisibilityToCookie(column);
            };

            $scope.collapseTransfers = function (day) {
                for (var j = 0; j < day.transfers.length; j++){
                    day.transfers[j].isCollapsed = true;
                }
            }

        }
    ]
)
