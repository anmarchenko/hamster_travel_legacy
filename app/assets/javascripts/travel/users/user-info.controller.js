angular.module('travel').controller('UserInfoController', [ '$scope', '$http', 'crop', function ($scope, $http, crop) {
    $scope.loaded = false;

    $scope.load = function () {
        $http.get(`/${LOCALE}/api/users/${$scope.$ctrl.userId}`).then(function (response) {
            $scope.user = response.data.user;

            $scope.loaded = true;
        });
    };

    $scope.crop = function ($files) {
        crop.start($files, {areaType: 'circle', resultImageSize: '200', areaMinSize: '100'}, function (image) {
            // upload(image);
            console.log('cropped')
        });
    };

    $scope.load();
}]);
