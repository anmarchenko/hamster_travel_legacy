angular.module('travel-components').controller 'TypeaheadController'
, [
    '$scope', 'City', 'User'
, ($scope, City, User) ->

    $scope.getCities = (term) ->
      City.query(term: term)

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
]
