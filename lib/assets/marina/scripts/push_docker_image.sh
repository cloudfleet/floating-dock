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

./clean_docker_none_images.sh
