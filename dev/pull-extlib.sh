#!/usr/bin/env zsh

BUILD_DIR=./build
SCRIPT_DIR=./dev
RELEASE_SCRIPT=${SCRIPT_DIR}/release.sh

_Release() {
    if [[ "$1" = "" ]]; then
        echo "Usage: ./release <pkgmeta-file.yml>"
        return 0
    fi
    local pkgmeta="$1"
    local args="-duz -r ${BUILD_DIR} -m ${SCRIPT_DIR}/${pkgmeta}"
    local cmd="${RELEASE_SCRIPT} ${args}"
    echo "Executing: ${cmd}"
    eval "${cmd}" && echo "Execution Complete: ${cmd}"
}

#_Release pkgmeta-kapresoftlibs-interface.yaml
_Release pkgmeta-dev.yaml
