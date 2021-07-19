#!/bin/sh

TAG=$(git rev-parse --short HEAD || echo 'latest')

GET_DB=${GET_DB:-0}

DOCKER_BUILDKIT=1 docker build --build-arg GET_DB=$GET_DB -t libc:$TAG .
docker tag libc:$TAG libc:latest
