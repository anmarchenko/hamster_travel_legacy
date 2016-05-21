angular.module('travel-components').controller 'PlanController'
, [
    '$scope', 'Trip', '$window', '$interval', '$cookies', 'Days'
  , ($scope, Trip, $window, $interval, $cookies, Days) ->
      $scope.uuid = ->
        s4 = ->
          return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
        return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();

      # define controller
      $scope.trip_id = (/trips\/([a-zA-Z0-9]+)/.exec($window.location)[1]);
      $scope.tripService = Trip.init($scope.trip_id)

      # tumblers
      $scope.transfersCollapsed = true
      $scope.edit = false

      # show checkboxes

      $scope.restoreVisibilityFromCookie = (column) ->
        key = "#{$scope.trip_id}_#{column}"
        cookie_val = $cookies.get(key)
        if cookie_val == undefined
          $scope[column] = true
        else
          $scope[column] = cookie_val == 'true'

      $scope.saveVisibilityToCookie = (column) ->
        key = "#{$scope.trip_id}_#{column}"
        $cookies.put(key, $scope[column])

      $scope.changeVisibility = (column) ->
        $scope[column] = !$scope[column]
        $scope.saveVisibilityToCookie(column)

      for column in ['show_place', 'show_transfers', 'show_hotel']
        $scope.restoreVisibilityFromCookie(column)

      promise = $interval(
        () ->
          $.ajax({
            url: "/api/user_shows/#{$scope.trip_id}",
            type: 'GET',
            success: (data) ->
              $scope.users = data
            error: ->
              $interval.cancel(promise)
          })
      ,
        10000
      )

      $scope.init = (count) ->
        $scope.days = new Array(count) unless count == 0

      $scope.fillAsPreviousPlace = (place, place_index, day, day_index) ->
        if day.places[place_index - 1]
          prev_place = day.places[place_index - 1]
        else
          prev_day = $scope.days[day_index - 1]
          prev_place = prev_day.places[prev_day.places.length - 1]
        place.city_id = prev_place.city_id
        place.city_text = prev_place.city_text
        place.flag_image = prev_place.flag_image

      $scope.fillAsPreviousHotel = (hotel, day_index) ->
        prev_day = $scope.days[day_index - 1]
        prev_hotel = prev_day.hotel
        if prev_hotel
          hotel.name = prev_hotel.name
          hotel.amount_cents = prev_hotel.amount_cents
          hotel.amount_currency = prev_hotel.amount_currency
          hotel.amount_currency_text = prev_hotel.amount_currency_text
          hotel.links = []
          for link in prev_hotel.links
            hotel.links.push JSON.parse(JSON.stringify(link))

      # REST: methods using old API

      $scope.savePlan = ->
        return if $scope.saving
        $scope.saving = true
        if $scope.days
          $scope.tripService.createDays($scope.days).then ->
            $scope.saving = false
            $scope.loadBudget()
            $scope.loadCountries()

      $scope.cancelEdits = ->
        $scope.setEdit(false)
        if $scope.days
          for day in $scope.days
            $scope.tripService.reloadDay day

        $scope.loadBudget()
        $scope.loadCountries()

      # END OF API

      # NEW EPOCH CODE - WILL SURVIVE
      # Start code that will stay in big controller
      $scope.loadBudget = ->
        $scope.$broadcast('budget_updated')

      $scope.loadCountries = ->
        $scope.$broadcast('countries_updated')

      $scope.cancelEditsPlan = ->
        $scope.setEdit(false)
        $scope.loadBudget()
        $scope.loadCountries()

      $scope.add = (arr, template = {}) ->
        obj = {}
        angular.copy(template, obj)
        obj.id = new Date().getTime()
        arr.push(obj)

      $scope.remove = (field, index) ->
        field.splice(index, 1)

      $scope.setEdit = (val) ->
        $scope.edit = val
        # emit event
        $scope.$broadcast('whole_plan_edit', val)

      # END NEW EPOCH CODE

  ]
