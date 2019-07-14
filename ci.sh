#!/bin/bash
readonly _IMAGE="jorianvo/vue-ci"

if command -v node >/dev/null 2>&1; then
    _TAG=$(node vueVersion.js)
else
    _TAG="latest"
fi

function _run () {
    docker run -v "$PWD:/site" -w "/site" "$_IMAGE":"$_TAG" $1
}

function build () {
    docker build -t "$_IMAGE":"$_TAG" .
}

function check4updates () {
    _run "npm run check4updates"
}

function upgrade () {
    _run "npm run update"
    _run "npm install"
}

function push () {
    local TAG_MAJOR_PATCH=$(node vueVersion.js --short)

    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
    docker push "$_IMAGE":"${_TAG}-b${TRAVIS_BUILD_NUMBER}"
    docker push "$_IMAGE":"$TAG_MAJOR_PATCH"
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