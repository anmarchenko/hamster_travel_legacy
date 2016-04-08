angular.module('travel-services').factory('Activities', [ '$http',
    function($http) {
        return {
            index: function(trip_id, day_id) {
                return $http.get("/api/v2/trips/" + trip_id + "/days/" + day_id + "/activities")
            }
        }
    }
])
