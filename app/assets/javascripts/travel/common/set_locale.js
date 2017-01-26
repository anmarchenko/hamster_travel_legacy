angular.module('travel').controller('SaveLocaleController', [
    '$scope', '$http', '$window', function($scope, $http, $window) {
        $scope.locale = LOCALE;

        var navigate = function(locale) {
            var href = $window.location.href.replace(
                '/' + $scope.locale + '/',
                '/' + locale + '/'
            );
            $window.location.href = href;
        }

        $scope.setUserId = function(userId) {
            $scope.userId = userId;
        }


        $scope.setLocale = function(locale) {
            if ($scope.userId) {
                $http.put('/api/users/' + $scope.userId, { locale: locale })
                     .then(function() {
                        navigate(locale);
                    }).catch(function(error) {
                        console.log(error);
                        navigate(locale);
                    })
            } else {
                navigate(locale);
            }
        }
    }
]);
