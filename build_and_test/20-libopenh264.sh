#!/bin/bash

NAME=$1
VERSION=$2
TARGET=$3

. ./common.sh $NAME $VERSION $TARGET

pushd $SUBMODULES/openh264

myconf=(
    PREFIX="$FFBUILD_PREFIX"
    INCLUDE_PREFIX="$FFBUILD_PREFIX"/include/wels
    BUILDTYPE=Release
    DEBUGSYMBOLS=False
    LIBDIR_NAME=lib
    CC="$CC"
    CXX="$CXX"
    AR="$AR"
    CFLAGS="-static-libgcc -static-libstdc++ -O2 -pipe -D_FORTIFY_SOURCE=2 -fstack-protector-strong"
    CXXFLAGS="-static-libgcc -static-libstdc++ -O2 -pipe -D_FORTIFY_SOURCE=2 -fstack-protector-strong"
    LDFLAGS="-static -static-libstdc++ -static-libgcc -O2 -pipe -fstack-protector-strong"
)

if [[ $TARGET == win64 ]]; then
    myconf+=(
        OS=mingw_nt
        ARCH=x86_64
    )
elif [[ $TARGET == winarm64 ]]; then
    myconf+=(
        OS=mingw_nt
        ARCH=aarch64
    )
elif [[ $TARGET == linux64 ]]; then
    myconf+=(
        OS=linux
        ARCH=x86_64
    )
else
    echo "Unknown target"
    exit 1
fi

make -j$(nproc) "${myconf[@]}" install-static

popd