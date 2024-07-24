#!/bin/bash

VERSION=$1

. ./common.sh $VERSION

working_directory=${ARTIFACTS}/page

mkdir -p "$working_directory"
pushd "$working_directory"

popd