#!/bin/bash
readonly _IMAGE="jorianvo/vue-ci"

function _run () {
    local _TAG=$npm_package_version
    docker run -v "$PWD:/site" -w "/site" "$_IMAGE:${_TAG}" "$1"
}

function build () {
    local _TAG=$npm_package_version
    docker build -t "$_IMAGE:${_TAG}" .
}

function check4updates () {
    _run "npm outdated"
}

function upgrade () {
    _run "npm update"
    _run "npm install"
}

function push () {
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
    docker push "$_IMAGE"
}

case $1 in
    build)
        build
        ;;

    check4updates)
        check4updates
        ;;

    upgrade)
        upgrade
        ;;

    push)
        push
        ;;

    *)
        echo -n "unknown command, exiting..."
        exit 1
        ;;
esac