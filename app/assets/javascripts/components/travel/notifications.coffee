angular.module('travel-components').controller 'NotificationsController'
, [
    '$scope', '$http',
    ($scope, $http) ->
      $scope.accept = (invite_id) ->
        $http.put("/messages/#{invite_id}").success (data) ->
          if data.success
            $scope["show_message_#{invite_id}"] = false

      $scope.decline = (invite_id) ->
        $http.delete("/messages/#{invite_id}").success (data) ->
          if data.success
            $scope["show_message_#{invite_id}"] = false

      $scope.invites = []
      $http.get('/messages').success (data) ->
        $scope.invites = data.invites
  ]
