angular.module('travel-components').directive('startdate', () ->
  return {
    require: 'ngModel'
    link: (scope, element, attr, ngModelCtrl) ->
      scope.$watch attr['ngModel'], (v) ->
        return unless v
        $(attr.startdate).datepicker('setStartDate', v)
        $(attr.startdate).datepicker('setEndDate', moment(v, "DD.MM.YYYY").add(29, 'days').format("DD.MM.YYYY"))
        $(attr.startdate).datepicker('show') unless $(attr.startdate).val()
  }
)
