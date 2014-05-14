angular.module('travel-services').config(["railsSerializerProvider",
  (railsSerializerProvider) ->
    railsSerializerProvider.underscore(angular.identity).camelize(angular.identity);
]
).service 'Trip', [ 'railsResourceFactory', (railsResourceFactory) ->

  {
    getDays: (trip_id) ->
      Days = railsResourceFactory(
        url: "/api/trips/#{trip_id}/days.json",
        name: 'days'
      )
      Days.query()

    createDays: (trip_id, days) ->
      Days = railsResourceFactory(
        url: "/api/trips/#{trip_id}/days.json",
        name: 'days'
      )
      new Days(days).create()

  }
]