#!/bin/bash

IMAGE=amoseev/widget
TAG='latest'

docker build -t $IMAGE:$TAG .