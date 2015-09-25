angular.module('travel-services').factory 'User', [ 'railsResourceFactory',

  (railsResourceFactory) ->
    railsResourceFactory(
      url: '/api/users',
      name: 'users'
    )
]
