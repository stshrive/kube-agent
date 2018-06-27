#!/usr/bin/env bash

if [ $# -ne 4 ]
then
    if [ $# -eq 1 ]
    then
        login=false  
    else
        echo "arguments for $0 are [Dockerfiles (file), <Registry>, <Username>, <Password>]"
        exit 1
    fi
else
    login=true
fi

set -e

pushd $(dirname "$0") > /dev/null
WORKING_DIR=$(pwd)
popd > /dev/null

dockerfiles=$WORKING_DIR/$1

if [ $login ]; then
    registry=$2/
    username=$3
    password=$4
fi

# Builds a docker image
build() {
    dockerfile=$1
    version=$2

    tag=${registry}kube-agent:$version

    echo Building image $tag
    docker build $(dirname "$dockerfile") -f $dockerfile -t $tag 

    echo Pushing image $tag
    docker push $tag
}


if [ $login ]; then
    # Login to custom docker registries.
    echo $password | docker login $registry --username $username --password-stdin
fi

# The file containing the generated dockerfiles gets piped into
# the loop below.
while IFS='' read -r line || [[ -n "$line" ]]; do
    build ${line[@]}
done < $dockerfiles
