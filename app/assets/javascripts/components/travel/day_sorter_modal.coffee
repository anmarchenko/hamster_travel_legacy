angular.module('travel-components').controller 'DaySorterModalController'
, [
    '$scope', '$uibModalInstance', '$http', 'days'
  , ($scope, $uibModalInstance, $http, days) ->

      $scope.days = days

      $scope.moveUp = (index) ->
        return if index <= 0 || index >= days.length
        temp = $scope.days[index]
        $scope.days[index] = $scope.days[index-1]
        $scope.days[index-1] = temp

      $scope.moveDown = (index) ->
        return if index < 0 || index >= days.length - 1
        temp = $scope.days[index]
        $scope.days[index] = $scope.days[index+1]
        $scope.days[index+1] = temp

      $scope.closeModal = ->
        $uibModalInstance.close()

      $scope.save = ->
        $uibModalInstance.close()
  ]
