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

        $http.get('/api/users/' + $scope.$ctrl.userId + '/visited_countries').then(function(response){
            $scope.loaded = true;
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
                        'visited countries', ['in', 'ADM0_A3_IS'].concat(response.data.countries)
                    );
                });
            }, 100)
        })
}]);
