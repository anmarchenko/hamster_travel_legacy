angular.module('travel-components').directive('focusOn', function ($timeout) {
    return {
        restrict: 'A',
        priority: -100,
        link: function ($scope, $element, $attr) {

            $scope.$watch($attr.focusOn,
                function (_focusVal) {
                    $timeout( function () {
                        var inputElement = $element.is('input')
                            ? $element
                            : $element.find('input');

                        _focusVal ? inputElement.focus()
                            : inputElement.blur();
                    });
                }
            );

        }
    };
});