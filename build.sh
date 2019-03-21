#!/usr/bin/env bash

. docker-vars.env

if [ -z $DOCKER_USERNAME ]; then
  echo "DOCKER_USERNAME undefined"
  exit 1
fi

rm -f avd.tar.gz
wget http://155.94.195.190/avd.tar.gz

docker build --tag $DOCKER_USERNAME/$DOCKER_IMAGE:$DOCKER_TAG \
             --tag $DOCKER_USERNAME/$DOCKER_IMAGE:latest .
