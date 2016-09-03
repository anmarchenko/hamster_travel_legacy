angular.module('travel').controller('DaySorterModalController', [
    '$scope', '$uibModalInstance', '$http', 'days', 'trip_id', function($scope, $uibModalInstance, $http, days, trip_id) {
        $scope.days = days;
        $scope.sortInProgress = false;
        $scope.moveUp = function(index) {
            var temp;
            if (index <= 0 || index >= days.length) {
                return;
            }
            temp = $scope.days[index];
            $scope.days[index] = $scope.days[index - 1];
            $scope.days[index - 1] = temp;
        };
        $scope.moveDown = function(index) {
            var temp;
            if (index < 0 || index >= days.length - 1) {
                return;
            }
            temp = $scope.days[index];
            $scope.days[index] = $scope.days[index + 1];
            $scope.days[index + 1] = temp;
        };
        $scope.closeModal = function() {
            $uibModalInstance.close();
        };
        $scope.save = function() {
            var ids;
            $scope.sortInProgress = true;
            ids = $scope.days.map(function(day) {
                return day.id;
            });
            $http.post("/api/trips/" + trip_id + "/days_sorting", {
                day_ids: ids
            }).then(function() {
                window.location.reload();
            });
        };
    }
]);
