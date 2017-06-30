angular.module('travel').controller('ParticipantsController', [
    '$scope', '$window', '$http', function($scope, $window, $http) {
        $scope.participants_loaded = false;
        $scope.init = function(trip_id) {
            $scope.trip_id = trip_id;
            $scope.loadParticipants();
        };

        $scope.loadParticipants = function() {
            return $http.get("/api/participants?id=" + $scope.trip_id).then(function(response) {
                $scope.participants = response.data.users;
                $scope.invited = response.data.invited_users;
                $scope.participants_loaded = true;
            });
        };

        $scope.selectUser = function($item, $model, $label, $scope) {
            $scope.toggle();
            $http.post('/api/trip_invites', {
                id: $scope.trip_id,
                user_id: $item.code
            }).then(function() {
                $scope.loadParticipants();
            });
        };

        $scope.deleteUser = function(user_id) {
            $http["delete"]("/api/trip_invites/" + $scope.trip_id + "?user_id=" + user_id).then( function() {
                $scope.loadParticipants();
            });
        };

        $scope.deleteInvitedUser = function(user_id) {
            $http["delete"]("/api/trip_invites/" + $scope.trip_id + "?trip_invite_id=" + user_id).then( function() {
                $scope.loadParticipants();
            });
        };
    }
]);
