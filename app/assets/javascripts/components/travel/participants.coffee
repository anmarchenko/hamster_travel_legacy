angular.module('travel-components').controller 'ParticipantsController'
, [
    '$scope', '$location', '$window', '$http'
  , ($scope, $location, $window, $http) ->

      $scope.loadParticipants = ->
        $http.get("/api/participants?id=#{$scope.$parent.trip_id}").success (data) ->
          $scope.participants = data

      $scope.selectUser = ($item, $model, $label, $scope) ->
        $scope.toggle()
        console.log $item

  ]
