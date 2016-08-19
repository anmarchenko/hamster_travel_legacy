angular.module('travel-components').controller('TripEditController', [
    '$scope', function($scope) {
        $scope.initScope = function(attrs) {
            $scope.last_day_index = attrs['last_day_index'];
            $scope.planned_days_count = attrs['days_count'];
            $scope.dates_unknown = attrs['dates_unknown'];
            $scope.message = attrs['message'];
            return $scope.status = attrs['status'];
        };
        $scope.submit = function($event) {
            var diff, new_days;
            if ($scope.hideDates()) {
                new_days = $scope.planned_days_count - 1;
            } else if (!$scope.end_date || !$scope.start_date) {
                new_days = -1;
            } else {
                diff = moment.duration(moment($scope.end_date, 'DD.MM.YYYY').diff(moment($scope.start_date, 'DD.MM.YYYY')));
                new_days = diff.days();
            }
            if (new_days < $scope.last_day_index) {
                if (!confirm($scope.message)) {
                    return $event.preventDefault();
                }
            }
        };
        $scope.showDatesUnknown = function() {
            return $scope.status === '0_draft';
        };
        $scope.hideDates = function() {
            return $scope.showDatesUnknown() && $scope.dates_unknown;
        };
        return $scope.hideDaysSlider = function() {
            return !$scope.hideDates();
        };
    }
]);
