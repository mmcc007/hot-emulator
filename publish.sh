#!/usr/bin/env bash

. docker-vars.env

if [ -z $DOCKER_USERNAME ]; then
  echo "DOCKER_USERNAME undefined"
  exit 1
fi

if [ -z $DOCKER_PASSWORD ]; then
  echo "DOCKER_PASSWORD undefined"
  exit 1
fi

#docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"
echo $DOCKER_PASSWORD | docker login --username "$DOCKER_USERNAME" --password-stdin

docker push $DOCKER_USERNAME/$DOCKER_IMAGE:$DOCKER_TAG