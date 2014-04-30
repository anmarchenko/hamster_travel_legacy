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

      $scope.fillAsPreviousPlace = (place, place_index, day, day_index) ->
        if day.places[place_index - 1]
          prev_place = day.places[place_index - 1]
        else
          prev_day = $scope.days[day_index - 1]
          prev_place = prev_day.places[prev_day.places.length - 1]
        place.city_code = prev_place.city_code
        place.city_text = prev_place.city_text

      $scope.savePlan = ->
        $scope.saving = true
        Trip.createDays($scope.trip_id, $scope.days)
        $scope.loadDays()
        $scope.saving = false

      # init controller
      $scope.loadDays()

  ]
