#!/bin/bash

VERSION=$1
VERSION="${VERSION:1}" # substring from 1st character

. ./common.sh $VERSION

working_directory=${ARTIFACTS}/page

mkdir -p "$working_directory"
pushd "$working_directory"

popd