angular.module('travel-components').directive 'actionConfirmation', ['$filter', ($filter) ->
  {
    restrict: 'A'
    link: (scope, elm, attrs) ->
      elm.click ->
        message = attrs.confirmationText

        swal({
          title: $('#confirmation_header').text(),
          text: message,
          confirmButtonText: $('#confirmation_ok').text(),
          cancelButtonText: $('#confirmation_cancel').text(),
          type: 'warning',
          showCancelButton: true
        }).then( ->
          scope.$eval attrs.actionConfirmation
        ,
          ->
            # dismissed
        )

  }
]