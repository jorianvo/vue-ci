#!/bin/bash
readonly _IMAGE="jorianvo/vue-ci"

function _run () {
    docker run -v "$PWD:/site" -w "/site" "$_IMAGE:${_TAG}" $1
}

function build () {
    local _VUE_VERSION=$(node vueVersion.js)
    local _TAG_MAJOR_PATCH=$(node vueVersion.js --short)
    
    # Locally we don't have node installed (or access to travis the build env variables)
    # so we just build the image using the latest tag
    if command -v node >/dev/null 2>&1; then
        _TAG="${_VUE_VERSION}-b${TRAVIS_BUILD_NUMBER}"
        docker build -t "$_IMAGE:${_TAG}" -t "$_IMAGE:${_TAG_MAJOR_PATCH}" .
    else
        docker build -t "$_IMAGE:latest" .
    fi
}

function check4updates () {
    _run "npm run check4updates"
}

function upgrade () {
    _run "npm run update"
    _run "npm install"
}

function push () {
    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
    docker push "$_IMAGE"
}

case $1 in
    check4updates)
        build
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