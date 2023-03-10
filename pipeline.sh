#!/bin/bash

# set variables
APP_NAME=aperture-auto
PROFILE=dev
PORT=8080
VERSION=0.0.1
DOCKER_HUB_USERNAME=savvamenyaylo
DOCKER_HUB_PASSWORD=$(cat ~/.docker/password.txt)
DOCKER_HUB_IMAGE=$DOCKER_HUB_USERNAME/$APP_NAME:latest
SERVER_USER=root
SERVER_IP=176.124.206.136

echo "1. Build application $APP_NAME and create .jar file"
./gradlew clean build

echo "2. Build docker image $DOCKER_HUB_IMAGE"
docker rmi -f $DOCKER_HUB_IMAGE
docker build -t $DOCKER_HUB_IMAGE .

echo "3. Push $DOCKER_HUB_IMAGE to Docker Hub"
echo $DOCKER_HUB_PASSWORD | docker login --username $DOCKER_HUB_USERNAME --password-stdin
docker push $DOCKER_HUB_IMAGE
docker rmi -f $DOCKER_HUB_IMAGE

echo "4. Ssh to $SERVER and run docker container"
ssh $SERVER_USER@$SERVER_IP <<EOF
    docker stop $APP_NAME || true
    docker rm $APP_NAME || true
    docker rmi -f $DOCKER_HUB_IMAGE

    docker login --username $DOCKER_HUB_USERNAME --password "$DOCKER_HUB_PASSWORD"
    docker pull $DOCKER_HUB_IMAGE
    docker run -d -i -t \
               --name $APP_NAME \
               -e "SPRING_PROFILES_ACTIVE=$PROFILE" \
               --network host \
               -p $PORT:8080 \
               -v /var/log/aperture:/var/log/aperture \
               $DOCKER_HUB_IMAGE
EOF
