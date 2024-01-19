#!/bin/bash
HASH=`docker image ls | awk '{ if ($1 == "zephyr_tester") print $3; }'`
if [ -n "$HASH" ]; then
    docker image rm $HASH
fi
docker build . -f Dockerfile --build-arg "USER_ID=$(id -u)" --build-arg "USER_GID=$(id -g)" -t zephyr_tester:v1
