#!/usr/bin/env bash
docker build -t "altmer/hamster-travel-web:latest" -f Dockerfile.production .
docker push altmer/hamster-travel-web
