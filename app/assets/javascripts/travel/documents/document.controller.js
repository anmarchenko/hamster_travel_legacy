angular.module('travel').controller('DocumentController', ['$scope', '$http', function($scope, $http) {
    $scope.delete = function () {
        $http.delete('/api/trips/' + $scope.$ctrl.tripId + '/documents/' + $scope.$ctrl.document.id).then(function () {
            $scope.$ctrl.onChange();
            toastr["success"]($scope.$ctrl.deleteSuccessMessage);
        });
    }
}]);