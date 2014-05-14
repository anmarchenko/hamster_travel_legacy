angular.module('travel-components').directive('onlydigits', () ->
  return {
    require: 'ngModel'
    link: (scope, element, attr, ngModelCtrl) ->
      fromUser = (text) ->
        transformedInput = text.replace(/[^0-9]/g, '');
        if(transformedInput != text)
          ngModelCtrl.$setViewValue(transformedInput);
          ngModelCtrl.$render();
        return transformedInput;
      ngModelCtrl.$parsers.push(fromUser);
  }
)
