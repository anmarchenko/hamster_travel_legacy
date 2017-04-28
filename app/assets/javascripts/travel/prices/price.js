angular.module('travel').component('price', {
    controller: 'PriceController',
    templateUrl: 'price.html',
    bindings: {
        target: '<',
    }
});
angular.module('travel').controller('PriceController', ['$scope', function($scope) {}]);
