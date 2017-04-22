angular.module('travel').controller('ReportController'
    , [
        '$scope', '$http'
        , function ($scope, $http) {
            $scope.report = null;
            $scope.report_loaded = false;

            $scope.init = function (trip_id) {
                $scope.trip_id = trip_id;
                $scope.load();
            };

            $scope.load = function () {
                $http.get('/api/reports/' + $scope.trip_id).then(function (response) {
                    $scope.report = response.data.report;
                    $scope.report_loaded = true;
                })
            };

            $scope.savePlan = function () {
                if($scope.saving) {
                    return;
                }
                $scope.saving = true;
                // do not send null to the backend
                if (!$scope.report) {
                    $scope.report = '';
                }

                $http.put('/api/reports/' + $scope.trip_id, {report: $scope.report}).then(function () {
                    $scope.saving = false;
                    toastr["success"]($('#notification_saved').text());
                });
            };

            $scope.cancelEdits = function () {
                $scope.cancelEditsPlan();

                $scope.load();
            };

        }
    ]
)
