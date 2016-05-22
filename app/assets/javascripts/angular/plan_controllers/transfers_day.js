angular.module('travel-components').controller('TransfersDayController'
    , [
        '$scope', '$http', '$timeout'
        , function ($scope, $http, $timeout) {

            $scope.day_loaded = false;

            $scope.reloading = false;
            $scope.saving = false;

            var EDIT_VARIABLES = ['place', 'transfer', 'comment', 'hotel'];

            $scope.init = function (trip_id, day_id) {
                $scope.trip_id = trip_id;
                $scope.day_id = day_id;
            };

            $scope.$on('day_transfers_updated', function (event, day) {
                    if ($scope.day_id == day.id) {
                        $scope.day = day;

                        $scope.reloading = false;
                    }
                }
            );

            $scope.$on('day_transfers_loaded', function (event, day) {
                    if ($scope.day_id == day.id) {
                        $scope.day = day;

                        $timeout(function () {
                            $scope.day_loaded = true;
                        }, Math.random() * 1000
                        )
                    }
                }
            );

            // $scope.setEdit = function(val, object, new_object) {
            //     if (val) {
            //         return $scope.reload(function(day) {
            //             $scope[object + "_edit"] = val;
            //             if (object === 'transfer' && day.transfers.length === 0) {
            //                 day.transfers = [new_object];
            //             }
            //         });
            //     } else {
            //         $scope[object + "_edit"] = val;
            //     }
            // };
            //
            // $scope.reload = function(callback) {
            //     if (callback == null) {
            //         callback = null;
            //     }
            //     return $scope.tripService.reloadDay($scope.day, function() {
            //         $scope.setEditAll(false);
            //         $scope.loadBudget();
            //         $scope.loadCountries();
            //         if (callback) {
            //             callback($scope.day);
            //         }
            //     });
            // };
            //
            // $scope.save = function() {
            //     return $scope.tripService.updateDay($scope.day).then(function() {
            //         $scope.reload();
            //     });
            // };
            //
            // $scope.setEditAll = function(val) {
            //     for (var i = 0, len = EDIT_VARIABLES.length; i < len; i++) {
            //         $scope.setEdit(val, EDIT_VARIABLES[i]);
            //     }
            // };
            //
            // $scope.setEditAll(false);



            // $scope.fillAsPreviousPlace = function(place, place_index, day, day_index) {
            //     var prev_day, prev_place;
            //     if (day.places[place_index - 1]) {
            //         prev_place = day.places[place_index - 1];
            //     } else {
            //         prev_day = $scope.days[day_index - 1];
            //         prev_place = prev_day.places[prev_day.places.length - 1];
            //     }
            //     place.city_id = prev_place.city_id;
            //     place.city_text = prev_place.city_text;
            //     place.flag_image = prev_place.flag_image;
            // };
            //
            // $scope.fillAsPreviousHotel = function(hotel, day_index) {
            //     var link, prev_day, prev_hotel, ref;
            //     prev_day = $scope.days[day_index - 1];
            //     prev_hotel = prev_day.hotel;
            //     if (prev_hotel) {
            //         hotel.name = prev_hotel.name;
            //         hotel.amount_cents = prev_hotel.amount_cents;
            //         hotel.amount_currency = prev_hotel.amount_currency;
            //         hotel.amount_currency_text = prev_hotel.amount_currency_text;
            //         hotel.links = [];
            //         ref = prev_hotel.links;
            //         for (var i = 0, len = ref.length; i < len; i++) {
            //             link = ref[i];
            //             hotel.links.push(JSON.parse(JSON.stringify(link)));
            //         }
            //     }
            // };

        }
    ]
)
