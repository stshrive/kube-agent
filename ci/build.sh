#!/usr/bin/env bash

if [ $# -ne 3 ]
then 
    echo "$0 requires two arguments [Container Registry URL, Container Registry PORT, Dockerfiles (file)]"
    exit 1
fi

registry=$1
registry_port=$2
dockerfiles=$3

# Builds a docker image
build() {
    dockerfile=$1
    version=$2
    
    echo Dockerfile: $dockerfile
    echo Version: $version

    tag=$registry:$registry_port/kube-agent:$version

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
