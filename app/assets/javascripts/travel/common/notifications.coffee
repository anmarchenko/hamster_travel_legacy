angular.module('travel-components').controller 'NotificationsController'
, [
    '$scope', '$http',
    ($scope, $http) ->

      $scope.invites = []
      $scope.loadInvites =  ->
        $http.get('/messages').success (data) ->
          $scope.invites = data.invites

      $scope.accept = (invite_id) ->
        $http.put("/messages/#{invite_id}").success (data) ->
          $scope.loadInvites()

      $scope.decline = (invite_id) ->
        $http.delete("/messages/#{invite_id}").success (data) ->
          $scope.loadInvites()

      $scope.loadInvites()
  ]
