#!/bin/bash

set -e
set -o pipefail

TARGET=$1

set -e
set -o pipefail

if [[ "$(id -u)" != 0 ]]; then
    echo Please run this script as root!
    exit 1
fi

apt-get update -y

test -x "$(command -v dotnet)" || apt-get install -y dotnet-sdk-8.0