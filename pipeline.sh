#!/bin/bash

# set variables
APP_NAME=aperture-auto
VERSION=0.0.1
IMAGE_NAME=$APP_NAME:$VERSION
DOCKER_HUB_USERNAME=savvamenyaylo
DOCKER_HUB_PASSWORD=$(cat ~/.docker/password.txt)
DOCKER_HUB_REPO_NAME=aperture
DOCKER_HUB_IMAGE=$DOCKER_HUB_USERNAME/$DOCKER_HUB_REPO_NAME:latest
USERNAME=root
SERVER_IP=176.124.206.136

echo "1. Build application $APP_NAME and create .jar file"
./gradlew clean build

echo "2. Build docker image $IMAGE_NAME"
docker rmi -f $IMAGE_NAME $DOCKER_HUB_IMAGE
docker build -t $IMAGE_NAME -t $DOCKER_HUB_IMAGE .

echo "3. Push $DOCKER_HUB_IMAGE to Docker Hub"
echo $DOCKER_HUB_PASSWORD | docker login --username $DOCKER_HUB_USERNAME --password-stdin
docker push $DOCKER_HUB_IMAGE
docker rmi -f $IMAGE_NAME $DOCKER_HUB_IMAGE

echo "4. Ssh to $SERVER and run docker container"
ssh $USERNAME@$SERVER_IP <<EOF
    docker login --username $DOCKER_HUB_USERNAME --password "$DOCKER_HUB_PASSWORD"
    docker rmi -f $DOCKER_HUB_IMAGE
    docker pull $DOCKER_HUB_IMAGE
    docker stop $APP_NAME || true
    docker rm $APP_NAME || true
    docker run --network host --name $APP_NAME -d $DOCKER_HUB_IMAGE
EOF
