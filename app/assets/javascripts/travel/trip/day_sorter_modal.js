angular.module('travel').controller('DaySorterModalController', [
    '$scope', '$uibModalInstance', '$http', 'days', 'trip_id', 'fields',
    function($scope, $uibModalInstance, $http, days, trip_id, fields) {
        $scope.days = days;
        $scope.sortInProgress = false;
        $scope.fields = {};
        console.log(fields);
        if (fields && fields.length > 0) {
            var field, index;
            for (index = 0; index < fields.length; index += 1) {
                field = fields[index];
                $scope.fields[field] = true;
            }
            console.log($scope.fields)
        }

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

        $scope.noFieldsSelected = function() {
            for (var field in $scope.fields) {
                if ($scope.fields[field]) {
                    return false;
                }
            }
            return true;
        };

        $scope.closeModal = function() {
            $uibModalInstance.close();
        };

        $scope.disabledSave = function() {
            return $scope.sortInProgress || $scope.noFieldsSelected();
        };

        $scope.save = function() {
            var ids, reorderedFields, field;
            if ($scope.noFieldsSelected()) {
                return;
            }
            $scope.sortInProgress = true;
            ids = $scope.days.map(function(day) {
                return day.id;
            });
            reorderedFields = [];
            for (field in $scope.fields) {
                if ($scope.fields[field]) {
                    reorderedFields.push(field);
                }
            }
            $http.post("/api/trips/" + trip_id + "/days_sorting", {
                day_ids: ids,
                fields: reorderedFields
            }).then(function() {
                window.location.reload();
            });
        };
    }
]);
