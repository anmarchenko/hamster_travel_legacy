angular.module('travel-services').factory('Days', [ '$http',
    function($http) {
        return {
            saveWithActivities: function(trip_id, days) {
                return $http.post("/api/v2/trips/" + trip_id + "/days_activities/", {days: days})
            },
            getActivities: function(trip_id) {
                return $http.get("/api/v2/trips/" + trip_id + "/days_activities/")
            }
        }
    }
])
