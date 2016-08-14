angular.module('travel-components')
    .directive('datetimepickerNeutralTimezone', function() {
        return {
            restrict: 'A',
            priority: 1,
            require: 'ngModel',
            link: function (scope, element, attrs, ctrl) {
                ctrl.$formatters.push(function (value) {
                    if (!value){
                        return 0;
                    }
                    var date = new Date(Date.parse(value));
                    date = new Date(date.getTime() + (60000 * date.getTimezoneOffset()));
                    return date;
                });

                ctrl.$parsers.push(function (value) {
                    var date = new Date(value.getTime() - (60000 * value.getTimezoneOffset()));
                    return date;
                });
            }
        };
    });
