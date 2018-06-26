#!/usr/bin/env bash

if [ $# -ne 2 ]
then 
    echo "$0 requires two arguments [Container Registry URL, Dockerfiles (file)]"
    exit 1
fi

set -e

pushd $(dirname "$0") > /dev/null
WORKING_DIR=$(pwd)
popd > /dev/null

registry=$1
dockerfiles=$WORKING_DIR/$2

# Builds a docker image
build() {
    dockerfile=$1
    version=$2

    tag=$registry/kube-agent:$version

    echo Building image $tag
    docker build $(dirname "$dockerfile") -f $dockerfile -t $tag 

    echo Pushing image $tag
    docker push $tag
}

# The file containing the generated dockerfiles gets piped into
# the loop below.
while IFS='' read -r line || [[ -n "$line" ]]; do
    build ${line[@]}
done < $dockerfiles
