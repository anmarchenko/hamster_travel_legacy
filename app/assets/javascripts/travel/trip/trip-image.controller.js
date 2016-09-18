angular.module('travel').controller('TripImageController', ['$scope', 'Upload', 'crop', '$http', function ($scope, Upload, crop, $http) {
    $scope.imageUrl = $scope.$ctrl.imageUrl;

    const upload = function (image) {
        $scope.uploading = true;
        $scope.progress = 0;
        Upload.upload({
            url: '/api/trips/' + $scope.$ctrl.tripId + '/upload_image',
            method: 'POST',
            file: image
        }).then(function (response) {
            // success
            $scope.uploading = false;
            $scope.processing = false;
            $scope.imageUrl = response.data.image_url;
        }, function () {
            // error
            $scope.uploading = false;
            $scope.processing = false;
        }, function (evt) {
            $scope.progress = parseInt(100.0 * evt.loaded / evt.total);
            if ($scope.progress == 100) {
                $scope.processing = true;
            }
        });
    };

    $scope.delete = function () {
        $http.post('/api/trips/' + $scope.$ctrl.tripId + '/delete_image').then(function (response) {
            $scope.imageUrl = response.data.image_url;
        });
    };

    $scope.crop = function ($files) {
        crop.start($files, {areaType: 'square', resultImageSize: '500', areaMinSize: '300'}, function (image) {
            upload(image);
        });
    };
}]);