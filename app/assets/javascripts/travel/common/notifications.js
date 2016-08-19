angular.module('travel-components').controller('NotificationsController', [
    '$scope', '$http', function($scope, $http) {
        $scope.invites = [];
        $scope.loadInvites = function() {
            $http.get('/messages').success(function(data) {
                $scope.invites = data.invites;
            });
        };
        $scope.accept = function(invite_id) {
            $http.put("/messages/" + invite_id).success(function() {
                $scope.loadInvites();
            });
        };
        $scope.decline = function(invite_id) {
            $http["delete"]("/messages/" + invite_id).success(function() {
                $scope.loadInvites();
            });
        };

        $scope.loadInvites();
    }
]);
