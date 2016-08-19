angular.module('travel-components').controller 'ParticipantsController'
, [
    '$scope', '$window', '$http'
  , ($scope, $window, $http) ->

      $scope.participants_loaded = false

      $scope.init = (trip_id) ->
        $scope.trip_id = trip_id
        $scope.loadParticipants()

      $scope.loadParticipants = ->
        $http.get("/api/participants?id=#{$scope.trip_id}").success (data) ->
          $scope.participants = data.users
          $scope.invited = data.invited_users
          $scope.participants_loaded = true

      $scope.selectUser = ($item, $model, $label, $scope) ->
        $scope.toggle()

        $http.post('/api/trip_invites', {id: $scope.trip_id, user_id: $item.code}).success (data) ->
          $scope.loadParticipants()

      $scope.deleteUser = (user_id) ->
        $http.delete("/api/trip_invites/#{$scope.trip_id}?user_id=#{user_id}").success (data) ->
          $scope.loadParticipants()

      $scope.deleteInvitedUser = (user_id) ->
        $http.delete("/api/trip_invites/#{$scope.trip_id}?trip_invite_id=#{user_id}").success (data) ->
          $scope.loadParticipants()
]
