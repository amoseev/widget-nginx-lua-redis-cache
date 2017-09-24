#!/bin/bash

IMAGE=amoseev/widget
TAG='latest'
CONTAINER_NAME=widget-cache

docker build -t $IMAGE:$TAG .

#stop container and remove image
docker stop $CONTAINER_NAME #> /dev/null 2>&1
#remove the container
docker rm $CONTAINER_NAME #> /dev/null 2>&1

docker run -d -p 80:80 -p 6379:6379 --name $CONTAINER_NAME $IMAGE
# docker exec  -it  widget-cache  bash