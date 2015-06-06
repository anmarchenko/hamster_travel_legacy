angular.module('travel-components').controller 'PlanController'
, [
    '$scope', 'Trip', '$location', '$window', '$interval'
  , ($scope, Trip, $location, $window, $interval) ->

      $scope.uuid = ->
        s4 = ->
          return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
        return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();

      # define controller
      $scope.trip_id = (/trips\/([a-zA-Z0-9]+)/.exec($location.absUrl())[1]);
      $scope.tripService = Trip.init($scope.trip_id)

      # tumblers
      $scope.activitiesCollapsed = true
      $scope.transfersCollapsed = true
      $scope.edit = false

      # show checkboxes
      $scope.show_place = true
      $scope.show_transfers = true
      $scope.show_hotel = true
      $scope.show_activities = true
      $scope.show_comments = true

      # budget
      $scope.budget = 0

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
        place.city_code = prev_place.city_code
        place.city_text = prev_place.city_text

      $scope.fillAsPreviousHotel = (hotel, day_index) ->
        prev_day = $scope.days[day_index - 1]
        prev_hotel = prev_day.hotel
        if prev_hotel
          hotel.name = prev_hotel.name
          hotel.price = prev_hotel.price
          hotel.links = []
          for link in prev_hotel.links
            hotel.links.push JSON.parse(JSON.stringify(link))

      # REST: methods using API
      $scope.loadBudget = ->
        $scope.tripService.getBudget($scope.trip_id).then (budget) ->
          $scope.budget = budget

      $scope.load = ->
        $scope.tripService.getTrip().then (trip) ->
          $scope.trip = trip
        $scope.loadBudget()

      $scope.savePlan = ->
        return if $scope.saving
        $scope.saving = true
        $scope.tripService.updateTrip($scope.trip).then ->
          $scope.saving = false unless $scope.days
        if $scope.days
          $scope.tripService.createDays($scope.days).then ->
            $scope.saving = false
            $scope.loadBudget()

      $scope.cancelEdits = ->
        $scope.setEdit(false)
        if $scope.days
          for day in $scope.days
            $scope.tripService.reloadDay day, (new_day) ->
              $scope.setDayCollapse(new_day, 'transfers')
              $scope.setDayCollapse(new_day, 'activities')
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

      $scope.downloadWord = ->
        url = "/trips/#{$scope.trip_id}.docx?"
        for field in ['show_place', 'show_transfers', 'show_hotel', 'show_activities', 'show_comments']
          url += "&cols[]=#{field}" if $scope[field]
        $window.open url, '_blank'
        return true

      $scope.changeVisibility = (column) ->
        $scope[column] = !$scope[column]
]
