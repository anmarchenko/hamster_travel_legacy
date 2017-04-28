angular.module('travel').component('priceInput', {
    controller: 'PriceInputController',
    templateUrl: 'priceInput.html',
    bindings: {
        target: '=',
        placeholder: '@',
        name: '@'
    }
});
angular.module('travel').controller('PriceInputController', ['$scope', function($scope) {
    $scope.selectCurrency = function(object, selected_value, currency_text) {
        object['amount_currency_text'] = currency_text;
        object['amount_currency'] = selected_value;
    };
}]);
