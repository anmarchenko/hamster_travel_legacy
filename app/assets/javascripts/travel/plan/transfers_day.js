angular.module('travel').controller('TransfersDayController'
    , [
        '$scope', '$http', '$timeout'
        , function ($scope, $http, $timeout) {

            $scope.day_loaded = false;

            $scope.new_transfer_template = {};

            var EDIT_VARIABLES = ['place', 'transfer', 'comment', 'hotel'];

            $scope.init = function (trip_id, day_id, day_index, new_transfer_template) {
                $scope.trip_id = trip_id;
                $scope.day_id = day_id;
                $scope.new_transfer_template = new_transfer_template;
                $scope.day_index = day_index;
                $scope.setEditAll(false);
            };

            $scope.apiUrl = function () {
                return "/api/trips/" + $scope.trip_id + "/days/" + $scope.day_id + "/transfers";
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

                        $scope.collapseTransfers(day);

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
                $http.get($scope.apiUrl()).success(function (day) {
                    $scope.day = day;

                    $scope.loadBudget();
                    $scope.loadCountries();
                    $scope.setEditAll(false);

                    $scope.collapseTransfers(day);

                    // send this day to parent controller
                    $scope.$emit('day_transfers_reloaded', day)
                })
            };
            $scope.setEditAll = function (val) {
                for (var i = 0, len = EDIT_VARIABLES.length; i < len; i++) {
                    $scope.setEdit(val, EDIT_VARIABLES[i]);
                }
            };

            $scope.setEdit = function (val, object) {
                if (val) {
                    $scope[object + "_edit"] = val;
                    if ($scope['transfer_edit']) {
                        $scope.setDefaults();
                    }
                } else {
                    $scope[object + "_edit"] = val;
                }
            };

            $scope.save = function () {
                $http.post($scope.apiUrl(),
                    {day: $scope.day}).success(function () {

                    $scope.reload();
                    toastr["success"]($('#notification_saved').text());

                })
            };

            $scope.copyPlace = function (from ,to) {
                if (from && to) {
                    to.city_id = from.city_id;
                    to.city_text = from.city_text;
                    to.flag_image = from.flag_image;
                }
            };

            $scope.fillAsPreviousPlace = function (place, place_index) {
                if ($scope.day.places[place_index - 1]) {
                    var prev_place = $scope.day.places[place_index - 1];
                    $scope.copyPlace(prev_place, place);
                } else {
                    $http.get($scope.apiUrl() + "/previous_place").success(function (data) {
                        $scope.copyPlace(data.place, place);
                    });
                }
            };

            $scope.copyHotel = function (from, to) {
                if (from && to) {
                    to.name = from.name;
                    to.amount_cents = from.amount_cents;
                    to.amount_currency = from.amount_currency;
                    to.amount_currency_text = from.amount_currency_text;
                    to.links = [];
                    for (var i = 0, len = from.links.length; i < len; i++) {
                        var link = from.links[i];
                        to.links.push(JSON.parse(JSON.stringify(link)));
                    }
                }
            };

            $scope.fillAsPreviousHotel = function (hotel) {
                $http.get($scope.apiUrl() + "/previous_hotel").success(function (data) {
                    $scope.copyHotel(data.hotel, hotel);
                });
            };

        }
    ]
)
