angular.module('travel').controller('UserInfoController', [ '$scope', '$http', 'crop', 'Upload', function ($scope, $http, crop, Upload) {
    $scope.loaded = false;

    const upload = function (image) {
        $scope.uploading = true;

        Upload.upload({
            url: '/api/users/' + $scope.$ctrl.userId + '/upload_image',
            method: 'POST',
            file: image
        }).then(function (response) {
            // success
            $scope.uploading = false;

            $scope.user.image_url = response.data.image_url;
        }, function () {
            // error
            $scope.uploading = false;
        });
    };

    $scope.load = function () {
        $http.get('/' + LOCALE + '/api/users/' + $scope.$ctrl.userId).then(function (response) {
            $scope.user = response.data.user;
            $scope.loaded = true;
        });
    };
    $scope.deletePhoto = function () {
        $http.post('/api/users/' + $scope.$ctrl.userId + '/delete_image').then(function (response) {
            $scope.user.image_url = response.data.image_url;
        });
    };

    $scope.crop = function ($files) {
        crop.start($files, {areaType: 'circle', resultImageSize: '200', areaMinSize: '100'}, function (image) {
            upload(image);
        });
    };

    $scope.load();
}]);
