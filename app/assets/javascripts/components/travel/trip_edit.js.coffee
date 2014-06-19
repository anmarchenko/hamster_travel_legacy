angular.module('travel-components').controller 'TripEditController'
, [
    '$scope'
  , ($scope) ->
      $scope.initScope = (attrs) ->
        $scope.last_day_index = attrs['last_day_index']
        $scope.message = attrs['message']
      $scope.submit = ($event) ->
        diff = moment.duration ( moment($scope.end_date).diff(moment($scope.start_date)) )
        new_days = diff.days()

        if new_days < $scope.last_day_index
          if !confirm($scope.message)
            $event.preventDefault()
]