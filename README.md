Hamster Travel
==============

Hamster Travel is opinionated travel planning application.

![App screenshot](http://amarchenko.de/img/posts/hamster-travel.png)

It is intended to be used by frequent travellers. The killer feature of this app
is budget counting - so when user enters any prices, trip budget gets recalculated.

## Current stack

* Ruby 2.4
* Rails 5.1.1
* Angularjs 1.6.2
* Postgresql 9.6
* Redis
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
