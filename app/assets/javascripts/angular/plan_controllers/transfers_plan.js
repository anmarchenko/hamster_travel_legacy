angular.module('travel-components').controller('TransfersPlanController'
    , [
        '$scope', '$http', '$cookies'
        , function ($scope, $http, $cookies) {

            $scope.caterings = [];
            $scope.caterings_loaded = false;


            $scope.load = function () {
                $http.get('/api/caterings/' + $scope.trip_id).success( function(response) {
                    $scope.caterings = response.caterings;
                    $scope.caterings_loaded = true;
                })
            };

            $scope.savePlan = function () {
                if ($scope.saving) {
                    return;
                }
                $scope.saving = true;

                $http.put('/api/caterings/' + $scope.trip_id, {trip: {caterings: $scope.caterings}}).success(function () {
                    $scope.saving = false;

                    toastr["success"]($('#notification_saved').text());

                    $scope.loadBudget();
                })
            };


            $scope.cancelEdits = function () {
                $scope.cancelEditsPlan();
                $scope.load();
            }



            $scope.init = function (trip_id) {
                $scope.trip_id = trip_id;

                // TODO: ES6
                var column, i, len, ref;
                ref = ['show_place', 'show_transfers', 'show_hotel'];
                for (i = 0, len = ref.length; i < len; i++) {
                    column = ref[i];
                    $scope.restoreVisibilityFromCookie(column);
                }

                $scope.load();
            };

            $scope.transfersCollapsed = true;

            $scope.restoreVisibilityFromCookie = function(column) {
                var cookie_val, key;
                key = $scope.trip_id + "_" + column;
                cookie_val = $cookies.get(key);
                if (cookie_val === void 0) {
                    return $scope[column] = true;
                } else {
                    return $scope[column] = cookie_val === 'true';
                }
            };

            $scope.saveVisibilityToCookie = function(column) {
                var key;
                key = $scope.trip_id + "_" + column;
                return $cookies.put(key, $scope[column]);
            };

            $scope.changeVisibility = function(column) {
                $scope[column] = !$scope[column];
                return $scope.saveVisibilityToCookie(column);
            };

            $scope.fillAsPreviousPlace = function(place, place_index, day, day_index) {
                var prev_day, prev_place;
                if (day.places[place_index - 1]) {
                    prev_place = day.places[place_index - 1];
                } else {
                    prev_day = $scope.days[day_index - 1];
                    prev_place = prev_day.places[prev_day.places.length - 1];
                }
                place.city_id = prev_place.city_id;
                place.city_text = prev_place.city_text;
                return place.flag_image = prev_place.flag_image;
            };

            $scope.fillAsPreviousHotel = function(hotel, day_index) {
                var i, len, link, prev_day, prev_hotel, ref, results;
                prev_day = $scope.days[day_index - 1];
                prev_hotel = prev_day.hotel;
                if (prev_hotel) {
                    hotel.name = prev_hotel.name;
                    hotel.amount_cents = prev_hotel.amount_cents;
                    hotel.amount_currency = prev_hotel.amount_currency;
                    hotel.amount_currency_text = prev_hotel.amount_currency_text;
                    hotel.links = [];
                    ref = prev_hotel.links;
                    results = [];
                    for (i = 0, len = ref.length; i < len; i++) {
                        link = ref[i];
                        results.push(hotel.links.push(JSON.parse(JSON.stringify(link))));
                    }
                    return results;
                }
            };

        }
    ]
)
