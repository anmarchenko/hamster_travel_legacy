angular.module('travel-components').controller 'DaySorterController'
, [
    '$scope', '$uibModal'
  , ($scope, $uibModal) ->
      $scope.startSorting = (trip_id) ->
# get info about days
        modalInstance = $uibModal.open({
            animation: true,
            templateUrl: 'daySortModal.html',
            controller: 'DaySorterModalController',
            size: 'lg',
            resolve: {
              days: ->
                []
            }
          }
        )

  ]
