#!/usr/bin/env bash
docker-cloud container ps
docker-cloud container redeploy f0e6e078
docker-cloud container exec f0e6e078 bundle exec rake db:migrate
