angular.module('travel-services').factory 'City', [ 'railsResourceFactory',

   (railsResourceFactory) ->
      railsResourceFactory(
        url: '/api/cities',
        name: 'city'
      )
  ]
