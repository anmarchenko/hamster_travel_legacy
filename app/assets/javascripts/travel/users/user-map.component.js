angular.module('travel').component('userMap', {
    controller: 'UserMapController',
    templateUrl: 'userMap.html',
    bindings: {
        userId: '<'
    }
});

angular.module('travel').controller('UserMapController', ['$scope', '$http', function ($scope, $http) {
    $scope.map = new mapboxgl.Map({
        container: 'user_mapbox_container',
        style: 'mapbox://styles/altmer/cijmn9d6y00lrbolxzss4sxp1',
        minZoom: 2,
        zoom: 2.0000001,
        center: [51.1657, 10.4515]
    })
}]);
