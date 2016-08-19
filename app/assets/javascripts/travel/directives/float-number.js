angular.module('travel-components').directive('floatNumber', [
    '$filter', function($filter) {
        var FLOAT_DOT_REGEXP, FLOAT_REGEXP;
        FLOAT_REGEXP = /^\-?\d+(\,\d+)?$/;
        FLOAT_DOT_REGEXP = /^\-?\d+(\.\d+)?$/;
        return {
            require: 'ngModel',
            link: function(scope, elm, attrs, ctrl) {
                var checkMax, checkMin, toFloat, toInt;
                toFloat = function(str) {
                    return parseFloat(str.replace(',', '.'));
                };
                toInt = function(str) {
                    return parseInt(str);
                };
                checkMax = function(number) {
                    var max;
                    max = attrs.max || Infinity;
                    return number <= max;
                };
                checkMin = function(number) {
                    var min;
                    min = attrs.min || 0;
                    return number >= min;
                };
                elm.blur(function() {
                    var formatter, i, len, ref, viewValue;
                    viewValue = ctrl.$modelValue;
                    ref = ctrl.$formatters;
                    for (i = 0, len = ref.length; i < len; i++) {
                        formatter = ref[i];
                        viewValue = formatter(viewValue);
                    }
                    ctrl.$viewValue = viewValue;
                    return ctrl.$render();
                });
                ctrl.$parsers.unshift(function(viewValue) {
                    var res, res_int;
                    if (FLOAT_REGEXP.test(viewValue) || FLOAT_DOT_REGEXP.test(viewValue)) {
                        res = toFloat(viewValue);
                        res_int = Math.round(res * 100);
                        ctrl.$setValidity('floatFormat', true);
                        ctrl.$setValidity('floatMin', checkMin(res_int));
                        ctrl.$setValidity('floatMax', checkMax(res_int));
                        if (!checkMin(res_int) || !checkMax(res_int)) {
                            res_int = 0;
                        }
                        return res_int;
                    } else {
                        ctrl.$setValidity('floatFormat', false);
                        ctrl.$setValidity('floatMax', true);
                        ctrl.$setValidity('floatMin', true);
                        return 0;
                    }
                });
                ctrl.$formatters.unshift(function(modelValue) {
                    return $filter('number')(parseInt(modelValue) / 100.0, 2).replace(/\s+/g, '');
                });
            }
        };
    }
]);
