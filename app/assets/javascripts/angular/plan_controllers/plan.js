angular.module('travel-components').controller('PlanController', [
    '$scope', function ($scope) {

        $scope.loadBudget = function () {
            $scope.$broadcast('budget_updated');
        };

        $scope.loadCountries = function () {
            $scope.$broadcast('countries_updated');
        };

        $scope.cancelEditsPlan = function () {
            $scope.setEdit(false);
            $scope.loadBudget();
            $scope.loadCountries();
        };

        $scope.add = function (arr, template) {
            if (template == null) {
                template = {};
            }
            var obj = {};
            angular.copy(template, obj);
            obj.id = new Date().getTime();
            return arr.push(obj);
        };

        $scope.remove = function (field, index) {
            return field.splice(index, 1);
        };

        $scope.edit = false;

        $scope.setEdit = function (val) {
            $scope.edit = val;
            return $scope.$broadcast('whole_plan_edit', val);
        };
    }
]);
