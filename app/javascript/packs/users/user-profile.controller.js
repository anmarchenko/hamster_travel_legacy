angular.module('travel').controller('UserProfileController', [ '$scope', '$location', function($scope, $location) {
    if(!$location.path()) {
        $location.path('/trips');
    }
  }
]);
