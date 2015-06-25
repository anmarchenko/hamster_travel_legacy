angular.module('travel-components').controller 'CurrencyInputController'
, [
    '$scope',
    ($scope) ->

      $scope.selectCurrency = (selected_value, currency_model, currency_text) ->
        $scope.currency_text = currency_text
        if currency_model
          $scope.$parent[currency_model] = selected_value

  ]
