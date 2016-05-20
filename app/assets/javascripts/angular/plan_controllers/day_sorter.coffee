angular.module('travel-components').controller 'DaySorterController'
, [
    '$scope', '$uibModal', '$http'
  , ($scope, $uibModal, $http) ->
      $scope.startSorting = (trip_id) ->
        # get info about days

        $http.get("/api/trips/#{trip_id}/days_sorting.json?locale=#{LOCALE}").then (response) ->
          $uibModal.open({
              animation: true,
              templateUrl: 'daySortModal.html',
              controller: 'DaySorterModalController',
              size: 'lg',
              resolve: {
                days: ->
                  response.data
                trip_id: ->
                  trip_id
              }
            }
          )

  ]
