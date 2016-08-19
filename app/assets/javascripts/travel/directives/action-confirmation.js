angular.module('travel-components').directive('actionConfirmation', [
    '$filter', function($filter) {
        return {
            restrict: 'A',
            link: function(scope, elm, attrs) {
                return elm.click(function() {
                    var message;
                    message = attrs.confirmationText;
                    return swal({
                        title: $('#confirmation_header').text(),
                        text: message,
                        confirmButtonText: $('#confirmation_ok').text(),
                        cancelButtonText: $('#confirmation_cancel').text(),
                        type: 'warning',
                        showCancelButton: true
                    }).then(function() {
                        return scope.$eval(attrs.actionConfirmation);
                    }, function() {});
                });
            }
        };
    }
]);
