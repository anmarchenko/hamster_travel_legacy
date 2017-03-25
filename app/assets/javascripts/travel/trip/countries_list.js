angular.module('travel').controller('CountriesListController'
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
                $http.get('/api/countries/' + $scope.trip_id).then(function(response){
                    $scope.countries = response.data.countries;

                    $scope.countries_loaded = true;
                });
            };

            $scope.$on('countries_updated', function () {
                $scope.load();
            });

        }
    ]
)
