#!/bin/bash

version=0.0.0

ROOT_DIR="$(pwd)"

cleanup() {
   rm -f $temp_file
   echo "Temporary file $temp_file removed"
}

trap cleanup EXIT

for target in win64; do
    for file_name in $(ls -1d "$ROOT_DIR"/build_and_test/??-* | sort -u); do
        . $file_name $target $version
    done
done

for file_name in $(ls -1d "$ROOT_DIR"/nuget/??-* | sort -u); do
    # . $file_name $version
done
