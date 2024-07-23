#!/bin/bash

TARGET=$1
VERSION=$2

. ./common.sh $TARGET $VERSION

if [[ "$(id -u)" != 0 ]]; then
    echo Please run this script as root!
    exit 1
fi

[[ -d $FFBUILD_PREFIX ]] || mkdir -p "$FFBUILD_PREFIX"

[[ -d $ARTIFACTS ]] || mkdir -p "$ARTIFACTS"
rm -fr "${ARTIFACTS}"/*

if [[ $TARGET == linux64 ]]; then
    echo linux64 is not implemented
    exit 1
fi

apt-get update -y

test -x "$(command -v x86_64-w64-mingw32-gcc)" || apt-get install -y mingw-w64

test -x "$(command -v nasm)" || apt-get install -y nasm

test -x "$(command -v make)" || apt-get install -y make

test -x "$(command -v pkg-config)" || apt-get install -y pkg-config

test -x "$(command -v gcc)" || apt-get install -y gcc

test -x "$(command -v convert)" || apt-get install -y imagemagick

if [[ ! "$(command -v wine)" ]]; then
    apt install -y wine64
    wineboot
fi

apt-get install -y gsfonts
