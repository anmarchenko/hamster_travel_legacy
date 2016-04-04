angular.module('travel-components').controller 'ActivitiesDayController'
, [
    '$scope'
  , ($scope) ->

      $scope.tripService = $scope.$parent.tripService

      $scope.day = {}
      $scope.day_id = null
      $scope.day_edit = false
      $scope.day_loaded = false

      $scope.reload = ->
        $scope.tripService.getDay($scope.day_id).then (day) ->
          $scope.day = day

          $scope.loadBudget()
          $scope.loadCountries()

      $scope.load = (day_id) ->
        $scope.day_id = day_id

        $scope.tripService.getDay($scope.day_id).then (day) ->
          $scope.day = day
          $scope.day_loaded = true

      $scope.expensesPresent = ->
        $scope.day.expenses && $scope.day.expenses.length > 0 && $scope.day.expenses[0].amount_cents > 0

      $scope.bookmarksPresent = ->
        $scope.day.links && $scope.day.links.length > 0 && $scope.day.links[0].url

  ]