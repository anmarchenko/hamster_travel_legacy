angular.module('travel').controller('DocumentController', ['$scope', '$http', function($scope, $http) {
    $scope.edit = false;

    $scope.delete = function () {
        $http.delete('/api/trips/' + $scope.$ctrl.tripId + '/documents/' + $scope.$ctrl.document.id).then(function () {
            $scope.$ctrl.onChange();
            toastr["success"]($scope.$ctrl.deleteSuccessMessage);
        });
    };

    $scope.startEdit = function () {
        $scope.edit = true;
        $scope.editedName = $scope.$ctrl.document.name;
    };

    $scope.cancelEdit = function () {
        $scope.edit = false;
    };

    $scope.save = function () {
        $http.put('/api/trips/' + $scope.$ctrl.tripId + '/documents/' + $scope.$ctrl.document.id,
                    {name: $scope.editedName}).then(function (response) {
            if (response.data.success) {
                $scope.$ctrl.document.name = $scope.editedName;
                toastr["success"]($scope.$ctrl.saveSuccessMessage);
            } else {
                toastr["error"]($scope.$ctrl.saveErrorMessage);
            }
            $scope.$ctrl.onChange();
            $scope.edit = false;
        });
    }
}]);
