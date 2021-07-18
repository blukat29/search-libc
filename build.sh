#!/bin/sh

TAG=$(git rev-parse --short HEAD || echo 'latest')

docker build -t libc:$TAG .
docker tag libc:$TAG libc:latest
