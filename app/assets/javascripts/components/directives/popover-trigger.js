angular.module('travel-components')

    .config(function($tooltipProvider) {
        $tooltipProvider.setTriggers({'open': 'close'});
    })

    .directive('popoverToggle', ['$timeout', function($timeout) {
        return {
            scope: true,
            link: function(scope, element, attrs) {
                scope.toggle = function() {
                    $timeout(function() {
                        element.triggerHandler(scope.$parent.popover_opened ? 'close' : 'open');
                        scope.$parent.popover_opened = !scope.$parent.popover_opened;
                    });
                };
                return element.on('click', scope.toggle);
            }
        };
    }]);
