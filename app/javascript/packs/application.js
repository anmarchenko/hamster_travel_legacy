/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// older dependencies:
require('jquery-ui');

import angular from 'angular';

require('angular-i18n/angular-locale_ru.js');

// require angular-bootstrap-slider
// require angular-ui-bootstrap
// require angular-ui-router
// require angular-ui-sortable
// require moment
// require ng-file-upload
// require ng-rollbar
// require ngsticky
// require sweetalert2
// require toastr
// require wowjs
// window.WOW = require('wowjs')

angular.module('helloworld', []);

console.log('Hello World from Webpacker')
