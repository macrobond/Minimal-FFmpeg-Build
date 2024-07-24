#!/bin/bash

NAME=$1
VERSION=$2

. ./common.sh $NAME $VERSION

if [[ "$(id -u)" != 0 ]]; then
    echo Please run this script as root!
    exit 1
fi

apt-get update -y

test -x "$(command -v zip)" || apt-get install -y zip

test -x "$(command -v dotnet)" || apt-get install -y dotnet-sdk-8.0