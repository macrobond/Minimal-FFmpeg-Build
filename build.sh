#!/bin/bash

set -xe

version="v0.0.0"

ROOT_DIR="$(pwd)"

cleanup() {
    echo ""
    cd $ROOT_DIR
    
    echo "git reset submodules"
    git submodule foreach --recursive git reset --hard

    echo "git clean submodules"
    git submodule foreach --recursive git clean -df
}

trap cleanup EXIT
# cleanup

[[ -d "$ROOT_DIR"/artifacts ]] || mkdir -p "$ROOT_DIR"/artifacts
rm -fr "$ROOT_DIR"/artifacts/*

for target in win64; do
    for name in $(ls -1d "$ROOT_DIR"/build_and_test/??-* | sort -u); do
        sudo $name build_and_test $version $target
    done
done

for name in $(ls -1d "$ROOT_DIR"/nuget/??-* | sort -u); do
    # sudo $name nuget $version
done
