#!/bin/bash
readonly _IMAGE="jorianvo/vue-ci"

function _run () {
    docker run -v "$PWD:/site" -w "/site" "$_IMAGE":"$_TAG" $1
}

function build () {
    # Locally we don't have node installed (or access to travis the build env variables)
    # so we just build the image using the latest tag
    if command -v node >/dev/null 2>&1; then
        _VUE_VERSION=$(node vueVersion.js)
        _TAG_MAJOR_PATCH=$(node vueVersion.js --short)
        docker build -t "$_IMAGE:${_VUE_VERSION}-b${TRAVIS_BUILD_NUMBER}" -t "$_IMAGE:${_TAG_MAJOR_PATCH}" .
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