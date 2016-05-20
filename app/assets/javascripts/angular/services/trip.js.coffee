angular.module('travel-services').config(["railsSerializerProvider",
    (railsSerializerProvider) ->
      railsSerializerProvider.underscore(angular.identity).camelize(angular.identity);
  ]
).service 'Trip', ['railsResourceFactory', (railsResourceFactory) ->
  {
  init: (trip_id) ->
    {
    trip_id: trip_id

    Days: railsResourceFactory(
      url: "/api/trips/#{trip_id}/days",
      name: 'days'
    )

    Caterings: railsResourceFactory(
      url: "/api/trips/#{trip_id}/caterings",
      name: 'caterings'
    )

    Trips: railsResourceFactory(
      url: "/api/trips",
      name: 'trip'
    )

    Countries: railsResourceFactory(
      url: '/api/countries',
      name: 'country'
    )

    getDays: ->
      this.Days.query(locale: LOCALE)

    getDay: (day_id) ->
      this.Days.get(day_id, locale: LOCALE)

    createDays: (days) ->
      new this.Days(days).create()

    updateDay: (day) ->
      new this.Days(day).update()

    reloadDay: (day, callback = null) ->
      this.getDay(day.id).then (new_day) ->
        for prop in ['places', 'transfers', 'hotel', 'comment', 'activities', 'add_price']
          day[prop] = new_day[prop]

        callback(day) if callback

    getCaterings: ->
      this.Caterings.query()

    createCaterings: (caterings) ->
      new this.Caterings(caterings).create()

    getTrip: ->
      this.Trips.get(this.trip_id, locale: LOCALE)

    updateTrip: (trip) ->
      new this.Trips(trip).update()

    getCountries: (trip_id) ->
      this.Countries.get(trip_id)
    }

  }
]