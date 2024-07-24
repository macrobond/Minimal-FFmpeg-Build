#!/bin/bash

set -e
set -o pipefail

NAME=$1
VERSION=$2
TARGET=$3

if [[ $TARGET == win64 ]]; then
    export CC=x86_64-w64-mingw32-gcc
    export CXX="x86_64-w64-mingw32-g++"
    export AR=x86_64-w64-mingw32-gcc-ar
    export RANLIB=x86_64-w64-mingw32-gcc-ranlib
    export NM=x86_64-w64-mingw32-gcc-nm
fi

export FFBUILD_PREFIX=/opt/ffbuild

ROOT_DIR="$(pwd)"
export ARTIFACTS_NO_NAME="$ROOT_DIR/artifacts"
export ARTIFACTS="$ARTIFACTS_NO_NAME/$NAME"
export SUBMODULES="$ROOT_DIR/submodules"

export PKG_CONFIG=pkg-config
export PKG_CONFIG_LIBDIR=/opt/ffbuild/lib/pkgconfig:/opt/ffbuild/share/pkgconfig