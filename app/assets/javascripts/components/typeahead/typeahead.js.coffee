angular.module('travel-components').controller 'TypeaheadController'
, [
    '$scope', 'City'
, ($scope, City) ->

    $scope.getCities = (term) ->
      City.query(term: term)

    $scope.onSelect = ($item, $model, $label, bindings) ->
      for model_key,item_property of bindings
        $scope[model_key] = $item[item_property]

]
