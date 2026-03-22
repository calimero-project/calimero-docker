#!/bin/bash
set -e

if [ "$#" -ne 2 ]; then
    echo "Script expects parameters <target-jdk-version> <arch>={armv7 arm64 amd64}"
    exit 1
fi

targetJdk=$1
arch=$2

if [ ! -d "jdk${targetJdk}u" ]; then
  repo=https://github.com/openjdk/jdk"${targetJdk}"u.git
  git clone --depth 1 --single-branch $repo
fi

export skipCloneJdk=true
./configure-target-jdk.sh $targetJdk $arch

echo "Mounting volume with JDK from $(pwd)/jdk${targetJdk}u"
docker run -it -v $(pwd)/jdk${targetJdk}u:/jdk \
               -v $(pwd)/jdk-configure-make-targets.sh:/jdk/run-configure.sh \
               openjdk$targetJdk-builder:$arch \
               bash -c "./run-configure.sh && exec bash"
