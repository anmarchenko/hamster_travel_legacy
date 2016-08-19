angular.module('travel').controller('CurrencyInputController', [
    '$scope', function($scope) {
        $scope.selectCurrency = function(object, selected_value, currency_text) {
            object['amount_currency_text'] = currency_text;
            object['amount_currency'] = selected_value;
        };
    }
]);