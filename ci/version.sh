#!/usr/bin/env bash

# Add the scripts directory to the directory stack
# and set the root path to the scripts directory.
pushd $(dirname "$0") > /dev/null
ROOT_PATH=$(pwd)
popd > /dev/null

# get build versions
eval $(python3 $ROOT_PATH/scripts/get_version.py "$@")
