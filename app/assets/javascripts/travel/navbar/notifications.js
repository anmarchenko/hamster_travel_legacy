angular.module('travel').controller('NotificationsController', [
    '$scope', '$http', function($scope, $http) {
        $scope.invites = [];
        $scope.loadInvites = function() {
            $http.get('/messages').then(function(response) {
                $scope.invites = response.data.invites;
            });
        };
        $scope.accept = function(invite_id) {
            $http.put("/messages/" + invite_id).then(function() {
                $scope.loadInvites();
            });
        };
        $scope.decline = function(invite_id) {
            $http["delete"]("/messages/" + invite_id).then(function() {
                $scope.loadInvites();
            });
        };

        $scope.loadInvites();
    }
]);
