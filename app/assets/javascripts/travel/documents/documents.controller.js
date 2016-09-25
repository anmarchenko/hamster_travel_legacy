angular.module('travel').controller('DocumentsController', ['$scope', '$http', 'Upload', function($scope, $http, Upload) {
    $scope.documents_loaded = false;
    $scope.loadDocuments = function () {
        $http.get('/api/trips/' + $scope.$ctrl.tripId + '/documents').then(function (response) {
            $scope.documents = response.data.documents;
            $scope.documents_loaded = true;
        });
    };

    $scope.upload = function ($files) {
        if (!$files || $files.length == 0) {
            return;
        }
        $scope.uploading = true;
        Upload.upload({
            url: '/api/trips/' + $scope.$ctrl.tripId + '/documents',
            method: 'POST',
            data: {
                files: $files
            }
        }).then(function () {
            // success
            $scope.uploading = false;
            toastr["success"]($('#notification_saved').text());
            $scope.loadDocuments();
        }, function () {
            // error
            $scope.uploading = false;
            $scope.loadDocuments();
        }, function () {
            // progress
        });

    };

    $scope.loadDocuments();
}]);