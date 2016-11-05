angular.module('travel').component('manualCities', {
    controller: 'ManualCitiesController',
    templateUrl: 'userManualCities.html',
    bindings: {
        userId: '<'
    }
});

angular.module('travel').controller('ManualCitiesController',
  ['$scope', '$uibModal', '$http', function($scope, $uibModal, $http) {
    $scope.cities = [];
    $scope.processing = false;

    $scope.showModal = function() {
        if ($scope.processing) {
          return;
        }
        $scope.processing = true;
        $http.get('/' + LOCALE + '/api/users/' + $scope.$ctrl.userId + '/manual_cities').success(function(data) {
          $scope.processing = false;

          $uibModal.open({
              animation: true,
              templateUrl: 'userManualCitiesModal.html',
              size: 'lg',
              controller: ['$scope', '$uibModalInstance', 'userId', 'cities', '$http',
                function($scope, $uibModalInstance, userId, cities, $http) {
                  $scope.userId = userId;
                  $scope.cities = cities;
                  $scope.close = function() {
                      $uibModalInstance.close();
                  };
                  $scope.save = function() {
                    $scope.close();

                    $http.post('/' + LOCALE + '/api/users/' + $scope.userId + '/manual_cities', {
                      manual_cities_ids: $scope.cities.map(function(city){
                        return city.id;
                      })
                    }).success(function(data) {
                      window.location.reload();
                    }).error(function(data){
                      console.log(data);
                      swal({
                          title: $('#generic_error_title').text(),
                          text: $('#generic_error_text').text(),
                          type: 'error'
                      });
                    });
                  };
                  $scope.citySelected = function(item, _model, _label, scope) {
                    scope.city_text = '';
                    scope.city_id = '';
                    $scope.cities.push(item);
                  };
                  $scope.remove = function(index) {
                    $scope.cities.splice(index, 1);
                  }
                }
              ],
              resolve: {
                  userId: function() {
                    return $scope.$ctrl.userId;
                  },
                  cities: function() {
                    return data.manual_cities;
                  }
              }
          });
        }).error(function(data){
          console.log(data);
          $scope.processing = false;
          swal({
              title: $('#generic_error_title').text(),
              text: $('#generic_error_text').text(),
              type: 'error'
          });
        });
    }
}]);
