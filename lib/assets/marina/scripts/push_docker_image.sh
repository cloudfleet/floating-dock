#!/bin/bash

set -e
IMAGE_NAME=$4
REGISTRY=$5
REGISTRY_USER=$6
REGISTRY_PASSWORD=$7

echo "logging into $REGISTRY"
docker login -u $REGISTRY_USER -p $REGISTRY_PASSWORD https://$REGISTRY:443
echo "pushing image"
docker push $REGISTRY/$IMAGE_NAME

./clean_docker_none_images.sh
