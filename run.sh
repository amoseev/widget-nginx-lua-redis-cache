#!/bin/bash

IMAGE=amoseev/widget
TAG='latest'
CONTAINER_NAME=widget-cache

#stop container and remove image
docker stop $CONTAINER_NAME #> /dev/null 2>&1
#remove the container
docker rm $CONTAINER_NAME #> /dev/null 2>&1

#!! run the redis container first
#docker run -d --name redis redis
docker run -d --link redis:redis -p 9090:80 --name $CONTAINER_NAME $IMAGE
