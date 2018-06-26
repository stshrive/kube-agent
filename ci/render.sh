#!/usr/bin/env bash

if [ $# -ne 3 ]
then 
    echo "$0 requires two arguments [placehoder, versions (file), outputfile]"
    exit 1
fi

versionfile=$1
outputfile=$2
placeholder=$3

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
        mkdir $version
        echo rendering dockerfile for version $version
        render ../dockerfile.template $version > $version/dockerfile

        pushd $(dirname "$0")/$version > /dev/null
        echo $(pwd)/dockerfile $version >> ../$outputfile
        popd > /dev/null
    done
done < $versionfile
