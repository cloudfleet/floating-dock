#!/bin/bash

set -e

DIR=$( cd "$( dirname $0 )" && pwd )

echo "Creating working directory ..."
WORK_DIR=$(mktemp -d)
echo " - working directory is $WORK_DIR"

REPO_URL=$1
REPO_BRANCH=$2
DOCKERFILE_PATH=$3
IMAGE_NAME=$4
REGISTRY=$5
LIBRARY_ARCH=$6

echo "Building image: $IMAGE_NAME" && echo "------------------------------"
echo " - fetching $REPO_URL ($REPO_BRANCH) to $WORK_DIR"
git clone --depth=1 --branch $REPO_BRANCH $REPO_URL $WORK_DIR
cd $WORK_DIR/$DOCKERFILE_PATH

echo " - patching Dockerfile"
PARENT_IMAGE=$(grep -i "^from" Dockerfile | awk '{print $2}')

echo $PARENT_IMAGE | grep "library"
LIBRARY_PREFIXED=$?
echo $PARENT_IMAGE | grep -v "/"
NO_PREFIX=$?

if [ $LIBRARY_PREFIXED -eq 0 ] ; then
  sed -ri "s/^FROM\ library/^FROM\ $LIBRARY_ARCH/g" Dockerfile
elif [ $NO_PREFIX -eq 0 ] ; then
  sed -ri "s/FROM\ (.*)/FROM\ $LIBRARY_ARCH\/\1/g" Dockerfile
else
  sed -ri "s/FROM\ (.*)/FROM\ $REGISTRY\/\1/g" Dockerfile
fi


echo " - building Docker image as $IMAGE_NAME"
docker build -t $REGISTRY/$IMAGE_NAME .
echo " - image built"

rm -rf $WORK_DIR
