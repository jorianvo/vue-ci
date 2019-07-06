#!/bin/bash
readonly today=$(date +'%Y%m%d')

function build () {
    docker build -t "$DOCKER_IMAGE":"$today"-"$TRAVIS_COMMIT" .
}

function deploy () {
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
    docker push "$DOCKER_IMAGE":"$today"-"$TRAVIS_COMMIT"
}

case $1 in
    build)
        build
        ;;

    deploy)
        deploy
        ;;

    *)
        echo -n "unknown command, exiting..."
        exit 1
        ;;
esac