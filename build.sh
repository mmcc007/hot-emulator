#!/usr/bin/env bash

. docker-vars.env

if [ -z $DOCKER_USERNAME ]; then
  echo "DOCKER_USERNAME undefined"
  exit 1
fi

if [ -z $AVD_IMAGE_IP ]; then
  echo "AVD_IMAGE_IP undefined"
  exit 1
fi

rm -f avd.tar.gz
wget http://$AVD_IMAGE_IP/avd.tar.gz

docker build --tag $DOCKER_USERNAME/$DOCKER_IMAGE:$DOCKER_TAG \
             --tag $DOCKER_USERNAME/$DOCKER_IMAGE:latest .
