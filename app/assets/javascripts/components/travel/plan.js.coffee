angular.module('travel-components').controller 'PlanController'
, [
    '$scope', 'Trip', '$location', '$window'
  , ($scope, Trip, $location, $window) ->

      # define controller
      $scope.trip_id = (/trips\/(.+)/.exec($location.absUrl())[1]);
      $scope.tripService = Trip.init($scope.trip_id)

      # tumblers
      $scope.activitiesCollapsed = true
      $scope.transfersCollapsed = true
      $scope.edit = false

      # show transfers checkboxes
      $scope.show_place = true
      $scope.show_transfers = true
      $scope.show_hotel = true
      $scope.show_activities = true
      $scope.show_comments = true

      $scope.setEdit = (val) ->
        $scope.edit = val
        $scope.activitiesCollapsed = true
        $scope.transfersCollapsed = true
        $scope.toggleActivities(false)
        $scope.toggleTransfers(false)

      $scope.createDays = (count) ->
        $scope.days = new Array(count)

      $scope.load = ->
        $scope.tripService.getTrip().then (trip) ->
          $scope.trip = trip

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

      $scope.budget = ->
        price = 0
        return 0 if !$scope.days
        for day in $scope.days
          continue if !day
          price += parseInt(day.add_price || 0, 10)
          if day.hotel
            price += parseInt(day.hotel.price || 0, 10)
          if day.transfers
            for transfer in day.transfers
              price += parseInt(transfer.price || 0, 10)
          if day.activities
            for activity in day.activities
              price += parseInt(activity.price || 0, 10)

        price || 0

      $scope.savePlan = ->
        return if $scope.saving
        $scope.saving = true
        $scope.tripService.updateTrip($scope.trip).then ->
          # nothing
        $scope.tripService.createDays($scope.days).then ->
          $scope.saving = false

      $scope.cancelEdits = ->
        $scope.setEdit(false)
        for day in $scope.days
          $scope.tripService.reloadDay day, (new_day) ->
            $scope.setDayCollapse(new_day, 'transfers')
            $scope.setDayCollapse(new_day, 'activities')

        $scope.load()

      $scope.setDayCollapse = (day, collection_name) ->
        return if !day
        if day[collection_name]
          for object in day[collection_name]
            object.isCollapsed = $scope["#{collection_name}Collapsed"]

      $scope.toggleCollapse = (is_change = true, collection_name) ->
        $scope["#{collection_name}Collapsed"] = !$scope["#{collection_name}Collapsed"] if is_change
        for day in $scope.days
          $scope.setDayCollapse(day, collection_name)

      $scope.toggleActivities = (is_change = true) ->
        $scope.toggleCollapse(is_change, 'activities')

      $scope.toggleTransfers = (is_change = true) ->
        $scope.toggleCollapse(is_change, 'transfers')

      $scope.downloadWord = ->
        url = $location.absUrl() + '.docx?'
        for field in ['show_place', 'show_transfers', 'show_hotel', 'show_activities', 'show_comments']
          url += "&cols[]=#{field}" if $scope[field]
        $window.open url, '_blank'
        return true

      # init controller
      $scope.load()

  ]
