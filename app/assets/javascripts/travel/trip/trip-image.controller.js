angular.module('travel').controller('TripImageController', ['$scope', 'Upload', '$uibModal', function ($scope, Upload, $uibModal) {
    $scope.upload = function ($files) {
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
                    $scope.image = image;
                    $scope.close = function () {
                        $uibModalInstance.close();
                    }
                }],
                resolve: {
                    image: function() {
                        return evt.target.result;
                    }
                }
            })
        };
    };
}]);