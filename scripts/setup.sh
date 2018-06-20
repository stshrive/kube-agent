#!/usr/bin/env bash

set -e

sudo add-apt-repository -y ppa:deadsnakes/ppa #> /dev/null 2>&1
sudo apt-get update
sudo apt-get install -y --no-install-recommends python3.6

