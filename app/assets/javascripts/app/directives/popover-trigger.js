angular.module('travel-components')

    .config(['$uibTooltipProvider', function($uibTooltipProvider) {
        $uibTooltipProvider.setTriggers({'open': 'close'});
    }])

    .directive('travelPopoverToggle', ['$timeout', function($timeout) {
        return {
            scope: true,
            link: function(scope, element) {
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
