angular.module('travel').controller('TripImageController', ['$scope', 'Upload', '$uibModal', function ($scope, Upload, $uibModal) {
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

    $scope.crop = function ($files) {
        if (!$files.length > 0) {
            return;
        }
        const file = $files[0];
        const reader = new FileReader();
        reader.readAsDataURL(file);

        reader.onload = function (evt) {
            $uibModal.open({
                animation: true,
                templateUrl: 'tripImageCropModal.html',
                controller: ['$scope', '$uibModalInstance', 'image', function ($scope, $uibModalInstance, image) {
                    $scope.resultImage = '';
                    $scope.image = image;

                    $scope.close = function () {
                        $uibModalInstance.close();
                    };

                    $scope.confirm = function () {
                        upload(dataURItoBlob($scope.resultImage));
                        $uibModalInstance.close();
                    }
                }],
                resolve: {
                    image: function() {
                        return evt.target.result;
                    }
                },
                size: 'lg',
                backdrop: false
            })
        };
    };

    function dataURItoBlob(dataURI) {
        var datas = dataURI.split(',')
        var byteString = atob(datas[1]);
        var type = datas[0].split(';')[0].replace('data:', '');
        var ab = new ArrayBuffer(byteString.length);
        var ia = new Uint8Array(ab);
        for (var i = 0; i < byteString.length; i++) {
            ia[i] = byteString.charCodeAt(i);
        }
        return new Blob([ab], { type: type });
    }

}]);