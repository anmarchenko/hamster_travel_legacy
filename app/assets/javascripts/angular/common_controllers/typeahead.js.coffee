angular.module('travel-components').controller 'TypeaheadController'
, [
    '$scope', '$timeout', '$http', '$window'
, ($scope, $timeout, $http, $window) ->

    $scope.locale = LOCALE

    $scope.getCities = (term) ->
      # TODO: pass trip_id as a parameter here
      trip_id = (/trips\/([a-zA-Z0-9]+)/.exec($window.location)[1]);
      $http.get('/api/cities?trip_id=' + trip_id + '&locale=' + $scope.locale + '&term=' + term).then (response) ->
        response.data

    $scope.getUsers = (term) ->
      $http.get('/api/users?term=' + term).then( (response) ->
        response.data
      )

    $scope.onSelect = ($item, $model, $label, bindings, callback) ->
      for model_key,item_property of bindings
        if model_key.indexOf('.') != -1
          keys = model_key.split('.')
          obj = $scope
          for key in keys[0...keys.length-1]
            obj = obj[key]
          obj[keys[keys.length-1]] = $item[item_property]
        else
          $scope[model_key] = $item[item_property]

      callback($item, $model, $label, $scope) if callback

    $scope.onFocus = (e) ->
      $timeout ->
        $(e.target).trigger('input')
  ]
