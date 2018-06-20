#!/usr/bin/env bash

set -e

sudo apt-get update 2>&1
sudo apt-get install -y --no-install-recommends python3-pip >&1

sudo -H pip3 -q install  --upgrade pip
sudo -H pip3 -q install -r requirements.txt

