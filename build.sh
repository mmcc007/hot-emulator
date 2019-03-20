#!/usr/bin/env bash

. docker-vars.env

if [ -z $DOCKER_USERNAME ]; then
  echo "DOCKER_USERNAME undefined"
  exit 1
fi

docker build --tag $DOCKER_USERNAME/$DOCKER_IMAGE:$DOCKER_TAG \
             --tag $DOCKER_USERNAME/$DOCKER_IMAGE:latest .