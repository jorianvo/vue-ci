#!/bin/bash
readonly _TODAY=$(date +'%Y%m%d')
readonly _TAG="$_TODAY"-"$TRAVIS_COMMIT"

function build () {
    docker build -t "$DOCKER_IMAGE":"$_TAG" .
}

function run () {
    docker run "$DOCKER_IMAGE":"$_TAG" npm run check4updates
}

function deploy () {
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
    docker push "$DOCKER_IMAGE":"$_TAG"
}

case $1 in
    build)
        build
        ;;
    
    run)
        run
        ;;

    deploy)
        deploy
        ;;

    *)
        echo -n "unknown command, exiting..."
        exit 1
        ;;
esac