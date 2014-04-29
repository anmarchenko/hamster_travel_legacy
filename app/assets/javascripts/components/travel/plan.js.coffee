angular.module('travel-components').controller 'PlanController'
, [
    '$scope', 'Trip', '$location'
  , ($scope, Trip, $location) ->

      # define controller
      $scope.trip_id = (/trips\/(.+)/.exec($location.absUrl())[1]);

      $scope.edit = false

      $scope.setEdit = (val) ->
        $scope.edit = val

      $scope.loadDays = ->
        Trip.getDays($scope.trip_id).then (days) ->
          $scope.days = days

      $scope.addPlace = (day) ->
        day.places.push({})

      $scope.removePlace = (day, index) ->
        day.places.splice(index, 1)

      # init controller
      $scope.loadDays()

  ]
