angular.module('travel').component('userInfo', {
    controller: 'UserInfoController',
    templateUrl: 'userInfo.html',
    bindings: {
        userId: '<'
    }
});
