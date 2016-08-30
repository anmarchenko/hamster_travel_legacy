angular.module('travel').controller('TripDescriptionController', ['$scope', '$uibModal', function ($scope, $uibModal) {
    // show modal logic
    $scope.showModal = function () {
        $uibModal.open({
            animation: true,
            templateUrl: 'tripDescriptionModal.html',
            controller: ['$scope', '$uibModalInstance', 'text', function ($scope, $uibModalInstance, text) {
                $scope.text = text;
                $scope.close = function () {
                    $uibModalInstance.close();
                }
            }],
            resolve: {
                text: function() {
                    return $scope.$ctrl.text;
                }
            }
        })
    }
}]);