#!/bin/bash

# Define variables
SERVER_IP=176.124.206.136
APP_NAME=aperture-auto

# Build the Docker image
./gradlew clean build buildDocker

# Copy the image to the server
docker save ${APP_NAME} | bzip2 | pv | ssh -i ~/.ssh/id_rsa user@${SERVER_IP} "bunzip2 | docker load"

# SSH into the server and run the container
ssh -i ~/.ssh/id_rsa user@${SERVER_IP} << EOF
    docker stop ${APP_NAME}
    docker rm ${APP_NAME}
    docker run -d --name ${APP_NAME} -p 8080:8080
EOF
