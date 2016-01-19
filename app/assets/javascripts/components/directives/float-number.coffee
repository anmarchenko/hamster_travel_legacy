angular.module('travel-components').directive 'floatNumber', ['$filter', ($filter) ->
  FLOAT_REGEXP = /^\-?\d+(\,\d+)?$/; #Numbers like: 1123,56

  {
    require: 'ngModel'
    link: (scope, elm, attrs, ctrl) ->
      toFloat = (str) ->
        parseFloat(str.replace(',', '.'))

      toInt = (str) ->
        parseInt(str)

      checkMax = (number) ->
        max = attrs.max || Infinity
        number <= max

      checkMin = (number) ->
        min = attrs.min || 0
        number >= min

      elm.blur ->
        viewValue = ctrl.$modelValue
        for formatter in ctrl.$formatters
          viewValue = formatter(viewValue)
        ctrl.$viewValue = viewValue;
        ctrl.$render()


      ctrl.$parsers.unshift (viewValue) ->
        if FLOAT_REGEXP.test(viewValue)
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