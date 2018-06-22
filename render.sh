#!/usr/bin/env bash

if [ $# > 1 ]; then exit 1; fi
if [ $# < 1 ]; then exit 2; fi

placeholder=$1
versions=$2


render() {
    sub="s~$placeholder~$2~g;"
    sed -r "$sub" $1
}

#versions=$(echo $MSFTKUBE_VERSIONS | tr ";" " ")

for version in $versions
do
    mkdir $version
    echo rendering dockerfile for version $version
    render dockerfile.template $version > $version/dockerfile
done
