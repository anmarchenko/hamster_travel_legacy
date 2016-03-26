angular.module('travel-components').controller 'PlanController'
, [
    '$scope', 'Trip', '$window', '$interval', '$cookies'
  , ($scope, Trip, $window, $interval, $cookies) ->
      $scope.uuid = ->
        s4 = ->
          return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
        return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();

      # define controller
      $scope.trip_id = (/trips\/([a-zA-Z0-9]+)/.exec($window.location)[1]);
      $scope.tripService = Trip.init($scope.trip_id)

      # tumblers
      $scope.activitiesCollapsed = true
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

      for column in ['show_place', 'show_transfers', 'show_hotel', 'show_activities', 'show_comments']
        $scope.restoreVisibilityFromCookie(column)

      # budget
      $scope.budget = 0

      $scope.tripService.getCountries($scope.trip_id).then (data) ->
        $scope.countries = data.countries

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
        5000
      )

      $scope.setEdit = (val) ->
        if val
          $scope.activitiesCollapsed = false
          $scope.toggleActivities(false)
        else
          $scope.activitiesCollapsed = true
          $scope.toggleActivities(false)
        $scope.edit = val

      $scope.createDays = (count, trip, budget) ->
        $scope.days = new Array(count) unless count == 0
        $scope.trip = trip
        $scope.budget = budget

      $scope.loadCatering = (trip, budget) ->
        $scope.trip = trip
        $scope.budget = budget

        $scope.tripService.getCaterings().then (caterings) ->
          $scope.caterings = caterings

      $scope.add = (field, obj = {}) ->
        obj['id'] = new Date().getTime()
        field.push(obj)

      $scope.remove = (field, index) ->
        field.splice(index, 1)

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

      # REST: methods using API
      $scope.loadBudget = ->
        $scope.tripService.getBudget($scope.trip_id).then (budget) ->
          $scope.budget = budget
          $scope.transfers_hotel_budget = 0
          $scope.activities_other_budget = 0
          $scope.catering_budget = 0

        $scope.tripService.getCountries($scope.trip_id).then (data) ->
          $scope.countries = data.countries

      $scope.load = ->
        $scope.tripService.getTrip().then (trip) ->
          $scope.trip = trip
        $scope.loadBudget()

      $scope.savePlan = ->
        return if $scope.saving
        $scope.saving = true
        $scope.tripService.updateTrip($scope.trip).then ->
          $scope.saving = false unless $scope.days || $scope.caterings
        if $scope.days
          $scope.tripService.createDays($scope.days).then ->
            $scope.saving = false
            $scope.loadBudget()
        if $scope.caterings
          $scope.tripService.createCaterings($scope.caterings).then ->
            $scope.saving = false
            $scope.loadBudget()

      $scope.cancelEdits = ->
        $scope.setEdit(false)
        if $scope.days
          for day in $scope.days
            $scope.tripService.reloadDay day, (new_day) ->
              $scope.setDayCollapse(new_day, 'transfers')
              $scope.setDayCollapse(new_day, 'activities')
        if $scope.caterings
          $scope.tripService.getCaterings().then (caterings) ->
            $scope.caterings = caterings

        $scope.load()
      # END OF API

      $scope.setDayCollapse = (day, collection_name) ->
        return if !day
        if day[collection_name]
          for object in day[collection_name]
            object.isCollapsed = $scope["#{collection_name}Collapsed"]

      $scope.toggleCollapse = (is_change = true, collection_name) ->
        $scope["#{collection_name}Collapsed"] = !$scope["#{collection_name}Collapsed"] if is_change
        return unless $scope.days
        for day in $scope.days
          $scope.setDayCollapse(day, collection_name)

      $scope.toggleActivities = (is_change = true) ->
        $scope.toggleCollapse(is_change, 'activities')

      $scope.toggleTransfers = (is_change = true) ->
        $scope.toggleCollapse(is_change, 'transfers')


  ]
