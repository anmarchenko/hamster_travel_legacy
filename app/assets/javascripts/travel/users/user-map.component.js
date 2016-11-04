angular.module('travel').component('userMap', {
    controller: 'UserMapController',
    templateUrl: 'userMap.html',
    bindings: {
        userId: '<'
    }
});

angular.module('travel').controller('UserMapController', ['$scope', '$http', '$timeout',
    function ($scope, $http, $timeout) {
        $scope.loaded = false;

        $http.get('/' + LOCALE + '/api/users/' + $scope.$ctrl.userId + '/visited')
             .then(function(response){
                $scope.loaded = true;
                $scope.visited_countries = response.data.countries;
                $scope.visited_cities = response.data.cities;

                $scope.visited_countries_codes = $scope.visited_countries.map(function(country){
                    return country.iso3_code;
                });

                $timeout(function(){
                    $scope.map = new mapboxgl.Map({
                        container: 'user_mapbox_container',
                        style: 'mapbox://styles/altmer/cijmn9d6y00lrbolxzss4sxp1',
                        minZoom: 2,
                        zoom: 2.0000001,
                        center: [13.4515, 51.1657]
                    });

                    $scope.map.addControl(new mapboxgl.Navigation());
                    $scope.map.on('load', function () {
                        $scope.map.setFilter(
                            'visited countries',
                            ['in', 'ADM0_A3_IS'].concat($scope.visited_countries_codes)
                        );
                        $scope.map.addSource("cities", {
                            "type": "geojson",
                            "data": {
                                "type": "FeatureCollection",
                                "features":
                                    $scope.visited_cities.map(function(city) {
                                        return {
                                            "type": "Feature",
                                            "geometry": {
                                                "type": "Point",
                                                "coordinates": [city.longitude, city.latitude]
                                            }
                                        }
                                    })
                            }
                        });

                        $scope.map.addLayer({
                            "id": "cities",
                            "type": "symbol",
                            "source": "cities",
                            "layout": {
                                "icon-image": "marker-15"
                            }
                        });
                    });
                }, 100)
            });
}]);
