angular.module('travel-services').factory('Activities', [ '$http',
    function($http) {
        return {
            get: function(trip_id, day_id) {
                return $http.get("/api/v2/trips/" + trip_id + "/days/" + day_id + "/activities")
            },

            saveAll: function(trip_id, day) {
                return $http.post("/api/v2/trips/" + trip_id + "/days/" + day.id + "/activities", {day: day})
            }
        }
    }
])
