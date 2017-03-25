Hamster Travel
==============

[![Build Status](https://travis-ci.org/altmer/hamster-travel.svg?branch=master)](https://travis-ci.org/altmer/hamster-travel)
[![Dependency Status](https://gemnasium.com/badges/github.com/altmer/hamster-travel.svg)](https://gemnasium.com/github.com/altmer/hamster-travel)

Hamster Travel is opinionated travel planning application.

<img src="http://amarchenko.de/img/posts/hamster-travel.png" alt="screen" width="500"/>

It is intended to be used by frequent travellers. The killer feature of this app
is budget counting - so when user enters any prices, trip budget gets recalculated.

## Current stack

* Ruby 2.4
* Rails 5.0.2
* Angularjs 1.6.2
* Postgresql 9.3
* Redis 3.2
* Docker

## Setup

Locally app can be run using docker-compose. The only prerequisite is docker installed (see [here](https://docs.docker.com/docker-for-mac/install/)).

First, run setup task:
```
./bin/docker/setup
```

After that application can be started/stopped using:

```
./bin/docker/start
./bin/docker/stop
./bin/docker/restart
```

See ./bin/docker folder for more convenient scripts.

## TODO

* [ ] Google auth
* [ ] Integrate rubocop into build process
* [ ] Introduce other code quality gems
* [ ] Use SSL on server
* [ ] Refactor more code to Angular components
* [ ] Use papertrail
* [ ] Use rollbar for js errors
* [ ] Consider using hash ids
* [ ] Support trips search by city name
* [ ] Travelled kilometers metric for user profile
* [ ] Allow to reorder documents
* [ ] Load trip lists with ajax
* [ ] For every day show start time
* [ ] Email notifications about trip invites
* [ ] Webpack, yarn
* [ ] Map interface for activities planning
* [ ] Export trip to PDF
