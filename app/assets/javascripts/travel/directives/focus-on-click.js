angular.module('travel').directive('focusOnClick', [ '$timeout', function ($timeout) {
    return {
        restrict: 'A',
        priority: -100,
        link: function ($scope, $element) {
            $element.click(function () {
                $timeout(function () {
                    const inputElement = $element.find('input');
                    inputElement.focus();
                }, 100);
            });
        }
    };
}]);
