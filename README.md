Hamster Travel
==============

[![Build Status](https://travis-ci.org/altmer/hamster-travel.svg?branch=master)](https://travis-ci.org/altmer/hamster-travel)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/d914b00a63a9403b84445c4e7eafbfd1)](https://www.codacy.com/app/igendou/travel-planner?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=altmer/travel-planner&amp;utm_campaign=Badge_Grade)
[![Codacy Badge](https://api.codacy.com/project/badge/Coverage/d914b00a63a9403b84445c4e7eafbfd1)](https://www.codacy.com/app/igendou/travel-planner?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=altmer/travel-planner&amp;utm_campaign=Badge_Coverage)
[![Dependency Status](https://gemnasium.com/badges/github.com/altmer/hamster-travel.svg)](https://gemnasium.com/github.com/altmer/hamster-travel)

Hamster Travel is opinionated travel planning application.

<img src="http://amarchenko.de/img/posts/hamster-travel.png" alt="screen" style="width: 500px;"/>

It is intended to be used by frequent travellers. The killer feature of this app
is budget counting - so when user enters any prices, trip budget gets recalculated.

## Current techonological stack

* Ruby 2.4
* Rails 5.0.1
* Angularjs 1.5.8
* Postgresql 9.3
* Redis 3.2
* Docker 1.13

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
