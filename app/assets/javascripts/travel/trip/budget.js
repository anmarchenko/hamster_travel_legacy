angular.module('travel').controller('BudgetController'
    , [
        '$scope', '$http'
        , function ($scope, $http) {
            $scope.budget = {};
            $scope.budget_loaded = false;
            $scope.edit_persons_count = false;

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
                $http.put('/api/budgets/' + $scope.trip_id, {budget_for: $scope.budget_for}).success(function () {
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

        }
    ]
)