#!/usr/bin/env bash

set -e

# Add the scripts directory to the directory stack
# and set the root path to the scripts directory.
pushd $(dirname "$0") > /dev/null
ROOT_PATH=$(pwd)
popd > /dev/null


sudo apt-get update 2>&1
sudo apt-get install -y --no-install-recommends python3-pip >&1

pip3 -q install  --upgrade pip
pip3 -q install -r $ROOT_PATH/requirements.txt

