angular.module('travel-components').controller('TransfersDayController'
    , [
        '$scope', '$http', '$timeout'
        , function ($scope, $http, $timeout) {

            $scope.day_loaded = false;

            $scope.new_transfer_template = {};

            var EDIT_VARIABLES = ['place', 'transfer', 'comment', 'hotel'];

            $scope.init = function (trip_id, day_id, new_transfer_template) {
                $scope.trip_id = trip_id;
                $scope.day_id = day_id;
                $scope.new_transfer_template = new_transfer_template;
                $scope.setEditAll(false);
            };

            $scope.$on('day_transfers_updated', function (event, day) {
                    if ($scope.day_id == day.id) {
                        $scope.day = day;
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

            $scope.setDefaults = function () {
                if ($scope.day.transfers.length == 0) {
                    var obj = {};
                    angular.copy($scope.new_transfer_template, obj);
                    $scope.day.transfers = [obj];
                }
            };

            $scope.reload = function () {
                $http.get("/api/v2/trips/" + $scope.trip_id + "/days/" + $scope.day_id + "/transfers").success(function (day) {
                    $scope.day = day;

                    $scope.loadBudget();
                    $scope.loadCountries();
                    $scope.setEditAll(false);

                    // send this day to parent controller
                    $scope.$emit('day_transfers_reloaded', day)
                })
            };
            $scope.setEditAll = function(val) {
                 for (var i = 0, len = EDIT_VARIABLES.length; i < len; i++) {
                     $scope.setEdit(val, EDIT_VARIABLES[i]);
                 }
            };

            $scope.setEdit = function(val, object) {
                if (val) {
                    $scope[object + "_edit"] = val;
                    if ($scope['transfers_edit']) {
                        $scope.setDefaults();
                    }
                } else {
                    $scope[object + "_edit"] = val;
                }
            };

            $scope.save = function () {
                $http.post("/api/v2/trips/" + $scope.trip_id + "/days/" + $scope.day.id + "/transfers",
                    {day: $scope.day}).success(function () {

                    $scope.reload();
                    toastr["success"]($('#notification_saved').text());

                })
            };



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
