angular.module('travel-components').controller 'CurrencyInputController'
, [
    '$scope',
    ($scope) ->

      $scope.selectCurrency = (selected_value, currency_model, object_model, currency_text, currency_text_model) ->
        if object_model
          obj = $scope[object_model]
          obj[currency_text_model] = currency_text
          if currency_model
            obj[currency_model] = selected_value

  ]
