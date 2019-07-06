#!/bin/bash
today=$(date +'%Y%m%d')
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker push "$DOCKER_IMAGE":"$today"-"$TRAVIS_COMMIT"