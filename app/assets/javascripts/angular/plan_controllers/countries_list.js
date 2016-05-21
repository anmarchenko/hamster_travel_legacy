angular.module('travel-components').controller('CountriesListController'
    , [
        '$scope', '$http'
        , function ($scope, $http) {
            $scope.countries = [];
            $scope.countries_loaded = false;

            $scope.initCountries = function (trip_id) {
                $scope.trip_id = trip_id;
                $scope.load();
            }

            $scope.load = function () {
                $http.get('/api/countries/' + $scope.trip_id).success(function(response){
                    $scope.countries = response.countries;

                    $scope.countries_loaded = true;
                });
            };

            $scope.$on('countries_updated', function () {
                $scope.load();
            });

        }
    ]
)