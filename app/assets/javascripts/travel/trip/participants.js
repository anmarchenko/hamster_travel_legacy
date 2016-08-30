angular.module('travel').controller('ParticipantsController', [
    '$scope', '$window', '$http', function($scope, $window, $http) {
        $scope.participants_loaded = false;
        $scope.init = function(trip_id) {
            $scope.trip_id = trip_id;
            $scope.loadParticipants();
        };
        $scope.loadParticipants = function() {
            return $http.get("/api/participants?id=" + $scope.trip_id).success(function(data) {
                $scope.participants = data.users;
                $scope.invited = data.invited_users;
                $scope.participants_loaded = true;
            });
        };
        $scope.selectUser = function($item, $model, $label, $scope) {
            $scope.toggle();
            $http.post('/api/trip_invites', {
                id: $scope.trip_id,
                user_id: $item.code
            }).success(function() {
                $scope.loadParticipants();
            });
        };
        $scope.deleteUser = function(user_id) {
            $http["delete"]("/api/trip_invites/" + $scope.trip_id + "?user_id=" + user_id).success(function(data) {
                $scope.loadParticipants();
            });
        };
        return $scope.deleteInvitedUser = function(user_id) {
            $http["delete"]("/api/trip_invites/" + $scope.trip_id + "?trip_invite_id=" + user_id).success(function(data) {
                $scope.loadParticipants();
            });
        };
    }
]);
