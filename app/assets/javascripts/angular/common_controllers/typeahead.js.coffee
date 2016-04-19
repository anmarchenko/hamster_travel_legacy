angular.module('travel-components').controller 'TypeaheadController'
, [
    '$scope', 'City', 'User', '$timeout'
, ($scope, City, User, $timeout) ->

    $scope.locale = LOCALE

    $scope.getCities = (term) ->
      City.query(term: term, locale: $scope.locale, trip_id: $scope.trip_id)

    $scope.getUsers = (term) ->
      User.query(term: term)

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
