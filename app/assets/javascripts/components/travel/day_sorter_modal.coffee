angular.module('travel-components').controller 'DaySorterModalController'
, [
    '$scope', '$uibModalInstance', '$http', 'days'
  , ($scope, $uibModalInstance, $http, days) ->

      $scope.days = days



  ]
