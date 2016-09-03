angular.module('travel').directive('focusOnClick', function () {
    return {
        restrict: 'A',
        priority: -100,
        link: function ($scope, $element) {
            $element.click(function () {
                const inputElement = $element.find('input');
                inputElement.focus();
            });
        }
    };
});
