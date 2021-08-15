#!/bin/sh

GET_DB=${GET_DB:-0}

TAG=$(git rev-parse --short HEAD || echo 'latest')
if [ "$GET_DB" != "1" ]; then
    TAG="${TAG}-nodb"
fi

# To use fixed IP for mirror.centos.org, run
# EXTRA_OPTS="--add-host=mirror.centos.org:113.29.189.165" GET_DB=1 ./build.sh

set -ex

DOCKER_BUILDKIT=1 docker build $EXTRA_OPTS --build-arg GET_DB=$GET_DB -t libc:$TAG .
docker tag libc:$TAG libc:latest
