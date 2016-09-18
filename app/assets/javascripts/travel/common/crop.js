angular.module('travel').factory('crop', ['$uibModal', function($uibModal) {
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

    return {
        start: function (files, params, onCrop) {
            if (!files.length > 0) {
                return;
            }
            const file = files[0];
            const reader = new FileReader();
            reader.readAsDataURL(file);

            reader.onload = function (evt) {
                $uibModal.open({
                    animation: true,
                    templateUrl: 'cropModal.html',
                    controller: ['$scope', '$uibModalInstance', 'image', 'params', function ($scope, $uibModalInstance, image, params) {
                        $scope.resultImage = '';

                        $scope.areaType = params.areaType;
                        $scope.resultImageSize = params.resultImageSize;
                        $scope.areaMinSize = params.areaMinSize;

                        $scope.image = image;

                        $scope.close = function () {
                            $uibModalInstance.close();
                        };

                        $scope.confirm = function () {
                            onCrop(dataURItoBlob($scope.resultImage));
                            $uibModalInstance.close();
                        }
                    }],
                    resolve: {
                        image: function() {
                            return evt.target.result;
                        },
                        params: function () {
                            return params;
                        }
                    },
                    size: 'lg',
                    backdrop: false
                })
            };

        }
    }
}]);