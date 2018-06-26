#!/usr/bin/env bash

if [ $# -ne 3 ]
then 
    echo "$0 requires two arguments [placehoder, versions (file), outputfile]"
    exit 1
fi

versionfile=$1
outputfile=$2
placeholder=$3

pushd $(dirname "$0") > /dev/null
WORKING_DIR=$(pwd)
ROOT_DIR=../$(pwd)
popd > /dev/null

render() {
    template=$1
    version_number=$2

    sub="s~$placeholder~$version_number~g;"
    sed -r "$sub" $template
}

# The file containing the version information gets piped into
# the loop below.
while IFS='' read -r line || [[ -n "$line" ]]; do
    for version in $line
    do
        mkdir $WORKING_DIR/$version
        echo rendering dockerfile for version $version
        render $ROOT_DIR/dockerfile.template $version > $version/dockerfile

        pushd $WORKING_DIR/$version > /dev/null
        echo $(pwd)/dockerfile $version >> $WORKING_DIR/$outputfile
        popd > /dev/null
    done
done < $versionfile
