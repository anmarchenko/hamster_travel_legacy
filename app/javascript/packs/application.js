/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

require('bootstrap');

require('bootstrap-datepicker');

require('./utils/delay');
require('./utils/flash_mesages');
require('./utils/tooltip');

import angular from 'angular';

require('sweetalert2')

require('angular-i18n/angular-locale_ru.js');
require('angular-ui-bootstrap');
require('angular-ui-sortable');
require('angular-cookies');
require('angular-animate');
require('angular-sanitize');
require('./lib/angular-slider');
require('ngsticky');
require('angular-ui-router');
require('ng-file-upload');
require('./lib/ng-img-crop');
require('ng-rollbar');

window.Slider = require('bootstrap-slider');

window.toastr = require('toastr');
toastr.options = {
    "closeButton": false,
    "debug": false,
    "newestOnTop": false,
    "progressBar": false,
    "positionClass": "toast-top-center",
    "preventDuplicates": false,
    "onclick": null,
    "showDuration": "300",
    "hideDuration": "1000",
    "timeOut": "1500",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
};

angular.module('travel', ['ui.bootstrap', 'ui.sortable', 'ngCookies', 'ngAnimate', 'ngSanitize',
    'ui.bootstrap-slider', 'sticky', 'ui.router', 'ngFileUpload', 'ngImgCrop',
    'tandibar/ng-rollbar']
).config(['$compileProvider', function ($compileProvider) {
    $compileProvider.debugInfoEnabled(false);
}]).config(['RollbarProvider', function(RollbarProvider) {
    RollbarProvider.init({
      accessToken: '9e8f6681c68340a2a1e65cf1476e50b8',
      captureUncaught: true,
      payload: {
        environment: ENVIRONMENT
      }
    });
}]);

require('./common/crop');
require('./common/set_locale');
require('./common/typeahead');

require('./config/routes');

require('./directives/action-confirmation');
require('./directives/empty-typeahead');
require('./directives/float-number');
require('./directives/focus-on');
require('./directives/neutral-timezone');
require('./directives/number-input');
require('./directives/popover-trigger');
require('./directives/press-enter');
require('./directives/start-date');

require('./activities/activities_day');
require('./activities/activities_plan');
require('./activities/activity_move_popup');
require('./activities/activity');

require('./caterings/caterings');

require('./documents/document.controller');
require('./documents/document.component');

require('./documents/documents.controller');
require('./documents/documents.component');

require('./forms/trip_edit');

require('./navbar/global-search.controller');
require('./navbar/global-search.component');
require('./navbar/notifications');

require('./prices/price_input');
require('./prices/price');

require('./report/report');

require('./transfers/transfers_day');
require('./transfers/transfers_plan');

require('./trip/budget');
require('./trip/countries_list');
require('./trip/day_sorter_modal');
require('./trip/day_sorter');
require('./trip/delete-link.component');
require('./trip/editing_users');
require('./trip/participants');
require('./trip/plan');
require('./trip/trip-description.component');
require('./trip/trip-image.component');

require('./users/manual-cities.component');
require('./users/user-info.component');
require('./users/user-map.component');
require('./users/user-profile.controller');
require('./users/user-trips.component');

import { WOW } from 'wowjs';
new WOW().init();
