angular.module('travel-components').controller 'TripEditController'
, [
    '$scope'
  , ($scope) ->
      $scope.initScope = (attrs) ->
        $scope.last_day_index = attrs['last_day_index']
        $scope.planned_days_count = attrs['days_count']
        $scope.dates_unknown = attrs['dates_unknown']

        $scope.message = attrs['message']
        $scope.status = attrs['status']


      $scope.submit = ($event) ->
        if $scope.hideDates()
          new_days = $scope.planned_days_count - 1
        else
          diff = moment.duration ( moment($scope.end_date).diff(moment($scope.start_date)) )
          new_days = diff.days()

        if new_days < $scope.last_day_index
          if !confirm($scope.message)
            $event.preventDefault()

      $scope.showDatesUnknown = ->
        $scope.status == '0_draft'

      $scope.hideDates = ->
        $scope.showDatesUnknown() && $scope.dates_unknown

      $scope.hideDaysSlider = ->
        !$scope.hideDates()
]