angular.module('travel-components').controller('BudgetController'
    , [
        '$scope', '$http'
        , function ($scope, $http) {
            $scope.budget = {};
            $scope.budget_loaded = false;
            $scope.edit_persons_count = false;
            $scope.whole_plan_edit = false;

            $scope.initBudget = function (trip_id) {
                $scope.trip_id = trip_id;
                $scope.load();
            }

            $scope.load = function () {
                $http.get('/api/budgets/' + $scope.trip_id).success(function(response){
                    var budget = response.budget;
                    $scope.budget = budget.sum;
                    $scope.transfers_hotel_budget = budget.transfers_hotel_budget;
                    $scope.activities_other_budget = budget.activities_other_budget;
                    $scope.catering_budget = budget.catering_budget;
                    $scope.budget_for = budget.budget_for;

                    $scope.budget_loaded = true;
                });
            };

            $scope.saveBudget = function () {
                $scope.edit_persons_count = false;
                $http.post('/api/budgets/' + $scope.trip_id, {budget_for: $scope.budget_for}).success(function () {
                    toastr["success"]($('#notification_saved').text());
                });
            };

            $scope.cancelBudgetEdit = function () {
                $scope.edit_persons_count = false;
                $scope.load();
            }

            $scope.$on('budget_updated', function () {
                $scope.load();
            });

            $scope.$on('whole_plan_edit', function (event, edit) {
                if(!edit) {
                    $scope.cancelBudgetEdit();
                }
                $scope.edit_persons_count = edit;
                $scope.whole_plan_edit = edit;
            });

        }
    ]
)