#!/usr/bin/env bash

if [ $# -ne 2 ]
then 
    echo requires two arguments
    exit 1
fi

placeholder=$1
versionfile=$2

render() {
    sub="s~$placeholder~$2~g;"
    sed -r "$sub" $1
}

while IFS='' read -r line || [[ -n "$line" ]]; do
    for version in $line
    do
        mkdir $version
        echo rendering dockerfile for version $version
        render dockerfile.template $version > $version/dockerfile
    done
done < $versionfile
