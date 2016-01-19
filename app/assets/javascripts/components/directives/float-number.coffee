angular.module('travel-components').directive 'floatNumber', ['$filter', ($filter) ->
  FLOAT_REGEXP_1 = /^\-?\d+.(\d{3})*(\,\d{0,2})?$/; #Numbers like: 1.123,56
  FLOAT_REGEXP_2 = /^\-?\d+(\,\d{0,2})?$/; #Numbers like: 1123,56

  {
    require: 'ngModel'
    link: (scope, elm, attrs, ctrl) ->
      toFloat = (str) ->
        parseFloat(str)

      toInt = (str) ->
        parseInt(str)

      checkMax = (number) ->
        max = attrs.max || Infinity
        number <= max

      checkMin = (number) ->
        min = attrs.min || 0
        number >= min

      elm.blur ->
        return unless ctrl.$valid
        viewValue = ctrl.$modelValue
        for formatter in ctrl.$formatters
          viewValue = formatter(viewValue)
        ctrl.$viewValue = viewValue;
        ctrl.$render()

      ctrl.$parsers.unshift (viewValue) ->
        if FLOAT_REGEXP_1.test(viewValue) || FLOAT_REGEXP_2.test(viewValue)
          res = toFloat(viewValue)
          res_int = Math.round(res * 100)
          ctrl.$setValidity('floatFormat', true);
          ctrl.$setValidity('floatMin', checkMin(res_int))
          ctrl.$setValidity('floatMax', checkMax(res_int))
          return res_int
        else
          ctrl.$setValidity('floatFormat', false);
          ctrl.$setValidity('floatMax', true)
          ctrl.$setValidity('floatMin', true)
          return 0

      ctrl.$formatters.unshift (modelValue) ->
        $filter('number')(parseInt(modelValue) / 100.0, 2)
  }
]