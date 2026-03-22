#!/bin/sh
# Run this to upload all images built by build-images.sh (server, tools, testnetwork) to docker hub

if [ "$#" -ne 2 ]; then
    echo "Script expects 2 parameters: arch {amd64, arm64, armv7} and version"
    exit 1
fi

arch=$1
version=$2

for image in server tools testnetwork; do
  ./push-image.sh "$image" "$arch" "$version"
  echo
done
