angular.module('travel-services').config(["railsSerializerProvider",
  (railsSerializerProvider) ->
    railsSerializerProvider.underscore(angular.identity).camelize(angular.identity);
]
).service 'Trip', [ 'railsResourceFactory', (railsResourceFactory) ->

  {
    init: (trip_id) ->

      {
        trip_id: trip_id

        Days: railsResourceFactory(
          url: "/api/trips/#{trip_id}/days",
          name: 'days'
        )

        Trips: railsResourceFactory(
          url: "/api/trips",
          name: 'trip'
        )

        getDays:  ->
          this.Days.query()

        getDay: (day_id) ->
          this.Days.get(day_id)

        createDays: (days) ->
          new this.Days(days).create()

        updateDay: (day) ->
          day.update()

        reloadDay: (day, callback = null) ->
          this.getDay(day.id).then (new_day) ->
            for prop in ['places', 'transfers', 'hotel', 'comment', 'activities', 'add_price']
              day[prop] = new_day[prop]

            callback(day) if callback

        getTrip: ->
          this.Trips.get(this.trip_id)

        updateTrip: (trip) ->
          new this.Trips(trip).update()
      }

  }
]