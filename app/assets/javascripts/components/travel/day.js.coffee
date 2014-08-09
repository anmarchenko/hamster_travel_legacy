angular.module('travel-components').controller 'DaysController'
, [
    '$scope', 'Trip', '$location'
  , ($scope, Trip, $location) ->
      $scope.trip_id = (/trips\/(.+)/.exec($location.absUrl())[1]);

      $scope.getDay = (day_id) ->
        Trip.getDay($scope.trip_id, day_id).then (day) ->
          $scope.day = day

          # ??????????
          $scope.$parent.days.push $scope.day

          $scope.$parent.toggleActivities(false)
          $scope.$parent.toggleTransfers(false)

  ]
