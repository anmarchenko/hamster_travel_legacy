angular.module('travel').component('manualCities', {
    controller: 'ManualCitiesController',
    templateUrl: 'userManualCities.html',
    bindings: {
        userId: '<'
    }
});

angular.module('travel').controller('ManualCitiesController',
  ['$scope', '$uibModal', function($scope, $uibModal) {
    // show modal logic
    $scope.showModal = function() {
        $uibModal.open({
            animation: true,
            templateUrl: 'userManualCitiesModal.html',
            controller: ['$scope', '$uibModalInstance', 'userId', function($scope, $uibModalInstance, userId) {
                $scope.userId = userId;
                $scope.close = function() {
                    $uibModalInstance.close();
                };
                $scope.save = function() {
                  $scope.close();
                };
            }],
            resolve: {
                userId: function() {
                    return $scope.$ctrl.userId;
                }
            }
        })
    }
}]);
