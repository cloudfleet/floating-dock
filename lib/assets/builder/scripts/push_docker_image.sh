#!/bin/bash

set -e
IMAGE_NAME=$1
REGISTRY=$2
REGISTRY_USER=$3
REGISTRY_PASSWORD=$4

echo "logging into $REGISTRY"
docker login -u $REGISTRY_USER -p $REGISTRY_PASSWORD $REGISTRY
echo "pushing image"
docker push $REGISTRY/$IMAGE_NAME

# remove all exited containers
if [[ -n $(docker ps -aq -f status=exited) ]]; then
    docker rm $(docker ps -aq -f status=exited)
fi

# remove <none> images
if [[ -n $(docker images -q --filter "dangling=true") ]]; then
    docker rmi -f $(docker images -q --filter "dangling=true")
    # docker rmi $(docker images | grep "^<none>" | awk '{print $3}')
fi
