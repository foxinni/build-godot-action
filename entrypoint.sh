#!/bin/sh
set -e

# Move godot templates already installed from the docker image to home
mv -n /root/.local ~

if [ "$3" != "" ]
then
    SubDirectoryLocation="$3/"
fi

mode="export-pack"
if [ "$6" = "true" ]
then
    echo "Exporting in debug mode!"
    mode="export-debug"
fi

# Export for project
echo "Building $1 for $2 - Test"
mkdir -p $GITHUB_WORKSPACE/build/${SubDirectoryLocation:-""}
cd ${5-"$GITHUB_WORKSPACE"}
echo "Before Build"
godot --${mode} $2 $GITHUB_WORKSPACE/build/${SubDirectoryLocation:-""}$1
echo "Build Done"

echo ::set-output name=build::build/${SubDirectoryLocation:-""}


if [ "$4" = "true" ]
then
    echo "Packing Build"
    mkdir -p $GITHUB_WORKSPACE/package
    cd $GITHUB_WORKSPACE/build
    zip $GITHUB_WORKSPACE/package/artifact.zip ${SubDirectoryLocation:-"."} -r
    echo ::set-output name=artifact::package/artifact.zip
    echo "Done"
fi
