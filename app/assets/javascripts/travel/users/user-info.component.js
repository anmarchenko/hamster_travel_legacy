angular.module('travel').component('userInfo', {
    controller: 'UserInfoController',
    templateUrl: 'userInfo.html',
    bindings: {
        userId: '<',
        edit: '<'
    }
});

angular.module('travel').controller('UserInfoController', [ '$scope', '$http', 'crop', 'Upload',
function ($scope, $http, crop, Upload) {
    $scope.loaded = false;
    $scope.editing = false;
    $scope.saving = false;

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

    const populateForm = function() {
        $scope.userForm = {
            first_name: $scope.user.first_name,
            last_name: $scope.user.last_name,
            home_town_id: $scope.user.home_town_id,
            home_town_text: $scope.user.home_town_text,
            currency: $scope.user.currency,
        }
    }

    $scope.load = function () {
        $http.get('/' + LOCALE + '/api/users/' + $scope.$ctrl.userId).then(function (response) {
            $scope.user = response.data.user;
            $scope.loaded = true;
            $scope.editing = false;
            $scope.saving = false;
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

    $scope.edit = function() {
        $scope.userFormErrors = {};
        populateForm()
        $scope.editing = true;
    }

    $scope.save = function() {
        if ($scope.saving) {
            return;
        }
        $scope.saving = true;
        $scope.userFormErrors = {};
        $http.put('/api/users/' + $scope.$ctrl.userId, { user: $scope.userForm })
             .then(function() {
                 $scope.load();
             })
             .catch(function(response) {
                 $scope.saving = false;
                 console.log(response);
                 $scope.userFormErrors = response.data.errors;
             });
    }

    $scope.cancel = function() {
        $scope.userFormErrors = {};
        $scope.editing = false;
    }

    $scope.load();
}]);
