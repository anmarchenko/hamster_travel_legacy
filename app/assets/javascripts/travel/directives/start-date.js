angular.module('travel-components').directive('startdate', function() {
    return {
        require: 'ngModel',
        link: function(scope, element, attr, ngModelCtrl) {
            return scope.$watch(attr['ngModel'], function(v) {
                if (!v) {
                    return;
                }
                $(attr.startdate).datepicker('setStartDate', v);
                $(attr.startdate).datepicker('setEndDate', moment(v, "DD.MM.YYYY").add(29, 'days').format("DD.MM.YYYY"));
                if (!$(attr.startdate).val()) {
                    return $(attr.startdate).datepicker('show');
                }
            });
        }
    };
});