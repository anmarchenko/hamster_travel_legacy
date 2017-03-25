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
        $http.get('/' + LOCALE + '/api/users/' + $scope.$ctrl.userId + '/manual_cities').then(function(response) {
          $scope.processing = false;

          $uibModal.open({
              animation: true,
              templateUrl: 'userManualCitiesModal.html',
              size: 'lg',
              controller: ['$scope', '$uibModalInstance', 'userId', 'cities', '$http',
                function($scope, $uibModalInstance, userId, cities, $http) {
                  $scope.userId = userId;
                  $scope.cities = cities;
                  $scope.city_codes = $scope.cities.map(function(city){
                    return city.code;
                  });
                  $scope.close = function() {
                      $uibModalInstance.close();
                  };
                  $scope.save = function() {
                    $scope.close();

                    $http.post('/' + LOCALE + '/api/users/' + $scope.userId + '/manual_cities', {
                      manual_cities_ids: $scope.cities.map(function(city){
                        return city.id;
                      })
                    }).then(function() {
                      window.location.reload();
                    }, function(data){
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
                    if ($scope.city_codes.indexOf(item.code) === -1) {
                      $scope.cities.push(item);
                      $scope.city_codes.push(item.code);
                    }
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
                    return response.data.manual_cities;
                  }
              }
          });
        }, function(data){
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
