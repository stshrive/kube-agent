#!/usr/bin/env bash

set -e

# Add the scripts directory to the directory stack
# and set the root path to the scripts directory.
pushd $(dirname "$0") > /dev/null
ROOT_PATH=$(pwd)
popd > /dev/null

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository -y \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update 2>&1

sudo apt-get install docker-ce

# uninstall pip to prevent import main issue in pip module
sudo python3 -m pip uninstall pip

# reinstall pip and upgrade pip
sudo apt-get -y --no-install-recommends install python3-pip --reinstall
python3 -m pip install pip --upgrade

# install our requirements
python3 -m pip install -r $ROOT_PATH/requirements.txt

