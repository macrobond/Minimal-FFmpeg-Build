#!/bin/bash

NAME=$1
VERSION=$2
VERSION="${VERSION:1}" # substring from 1st character

. ./common.sh $NAME $VERSION

working_directory=${ARTIFACTS}/page

mkdir -p "$working_directory"
pushd "$working_directory"

cp -fr $ARTIFACTS/nuget/nuget.csproj.zip nuget.csproj.zip

APi="\
{\
\"version\":\"$VERSION\",\
\"major\":$(echo $VERSION | cut -d. -f1),\
\"minor\":$(echo $VERSION | cut -d. -f2),\
\"patch\":$(echo $VERSION | cut -d. -f3),\
\"url\":\"https://macrobond.github.io/Minimal-FFmpeg-Build/nuget.csproj.zip\"\
}"

echo "$APi" > api.json

popd