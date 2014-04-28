angular.module('travel-services').service 'Trip', [ 'railsResourceFactory', (railsResourceFactory) ->

  {
    getDays: (trip_id) ->
      Days = railsResourceFactory(
        url: "/api/trips/#{trip_id}/days.json",
        name: 'city'
      )
      Days.query()
  }
]