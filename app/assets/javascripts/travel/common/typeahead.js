angular.module('travel').controller('TypeaheadController', [
    '$scope', '$timeout', '$http', '$window', function($scope, $timeout, $http, $window) {
        $scope.locale = LOCALE;
        $scope.getCities = function(term) {
            var trip_id = null;
            var trip_id_catch = /trips\/([a-zA-Z0-9]+)/.exec($window.location);
            if (trip_id_catch) {
                trip_id = trip_id_catch[1];
            }
            return $http.get('/api/cities?trip_id=' + trip_id + '&locale=' + $scope.locale + '&term=' + term).then(function(response) {
                return response.data;
            });
        };
        $scope.getUsers = function(term) {
            return $http.get('/api/users?term=' + term).then(function(response) {
                return response.data;
            });
        };
        $scope.onSelect = function($item, $model, $label, bindings, callback) {
            var i, item_property, key, keys, len, model_key, obj, ref;
            for (model_key in bindings) {
                item_property = bindings[model_key];
                if (model_key.indexOf('.') !== -1) {
                    keys = model_key.split('.');
                    obj = $scope;
                    ref = keys.slice(0, keys.length - 1);
                    for (i = 0, len = ref.length; i < len; i++) {
                        key = ref[i];
                        obj = obj[key];
                    }
                    obj[keys[keys.length - 1]] = $item[item_property];
                } else {
                    $scope[model_key] = $item[item_property];
                }
            }
            if (callback) {
                return callback($item, $model, $label, $scope);
            }
        };
        $scope.onFocus = function(e) {
            $timeout(function() {
                $(e.target).trigger('input');
            });
        };
    }
]);
