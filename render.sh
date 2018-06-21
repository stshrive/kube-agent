#!/usr/bin/env bash

render() {
    sub="s~%%MSFTKUBE_VERSION%%~$version~g;"
    sed -r "$sub" $1
}

#versions=$(echo $MSFTKUBE_VERSIONS | tr ";" " ")

for version in $verions
do
    mkdir $version
    echo rendering dockerfile for version $version
    render dockerfile.template > $version/dockerfile
done
