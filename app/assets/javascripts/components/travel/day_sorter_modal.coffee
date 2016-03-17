angular.module('travel-components').controller 'DaySorterModalController'
, [
    '$scope', '$uibModalInstance', '$http', 'days', 'trip_id'
  , ($scope, $uibModalInstance, $http, days, trip_id) ->

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
        ids = $scope.days.map (day) ->
          day.id

        $http.post("/api/trips/#{trip_id}/days_sorting", {day_ids: ids}).then (response) ->
          window.location.reload()
  ]
