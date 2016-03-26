angular.module('travel-components').controller 'DaysController'
, [
    '$scope'
  , ($scope) ->
      EDIT_VARIABLES = ['place', 'transfer', 'activity', 'comment', 'hotel']

      $scope.tripService = $scope.$parent.tripService

      $scope.setEdit = (val, object, new_object) ->
        if val
          $scope.reload (day) ->
            $scope["#{object}_edit"] = val

            if object == 'transfer' && day.transfers.length == 0
              day.transfers = [new_object]

            if object == 'activity' && day.activities.length == 0
              day.activities = [new_object]
        else
          $scope["#{object}_edit"] = val

      $scope.setEditAll = (val) ->
        for v in EDIT_VARIABLES
          $scope.setEdit(val, v)

      $scope.setDay = (day_index, day) ->
        $scope.day_index = day_index
        $scope.day = day

        $scope.$parent.days[day_index] = $scope.day

        $scope.$parent.toggleActivities(false)
        $scope.$parent.toggleTransfers(false)

      # REST: methods using API
      $scope.reload = (callback = null) ->
        $scope.tripService.reloadDay $scope.day, ->
          $scope.setEditAll(false)

          $scope.$parent.setDayCollapse($scope.day, 'transfers')
          $scope.$parent.setDayCollapse($scope.day, 'activities')

          $scope.$parent.loadBudget()

          callback($scope.day) if callback

      $scope.save = ->
        $scope.tripService.updateDay($scope.day).then ->
          $scope.reload()

      # init logic
      $scope.setEditAll(false)
  ]
