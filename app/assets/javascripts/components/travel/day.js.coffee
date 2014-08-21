angular.module('travel-components').controller 'DaysController'
, [
    '$scope'
  , ($scope) ->
      EDIT_VARIABLES = ['place', 'transfer', 'activity', 'comment', 'hotel']

      $scope.tripService = $scope.$parent.tripService

      $scope.setEdit = (val, object) ->
        if val
          $scope.reload ->
            $scope["#{object}_edit"] = val
        else
          $scope["#{object}_edit"] = val

      $scope.setEditAll = (val) ->
        for v in EDIT_VARIABLES
          $scope.setEdit(val, v)

      $scope.getDay = (day_id) ->
        $scope.tripService.getDay(day_id).then (day) ->
          $scope.day = day

          $scope.$parent.days.push $scope.day

          $scope.$parent.toggleActivities(false)
          $scope.$parent.toggleTransfers(false)

      $scope.reload = (callback = null) ->
        $scope.tripService.getDay($scope.day.id).then (new_day) ->
          for prop in ['places', 'transfers', 'hotel', 'comment', 'activities', 'add_price']
            $scope.day[prop] = new_day[prop]

          $scope.setEditAll(false)

          $scope.$parent.setDayCollapse($scope.day, 'transfers')
          $scope.$parent.setDayCollapse($scope.day, 'activities')

          callback() if callback

      $scope.save = ->
        $scope.tripService.updateDay($scope.day).then ->
          $scope.reload()

      # init logic
      $scope.setEditAll(false)
  ]
