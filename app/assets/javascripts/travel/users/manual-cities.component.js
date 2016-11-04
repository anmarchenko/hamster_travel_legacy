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
                $scope.cities = [];
                $scope.close = function() {
                    $uibModalInstance.close();
                };
                $scope.save = function() {
                  $scope.close();
                };
                $scope.citySelected = function(item, _model, _label, scope) {
                  scope.city_text = '';
                  scope.city_id = '';
                  console.log(item);
                  $scope.cities.push(item);
                };
                $scope.remove = function(index) {
                  $scope.cities.splice(index, 1);
                }
            }],
            resolve: {
                userId: function() {
                    return $scope.$ctrl.userId;
                }
            }
        })
    }
}]);
