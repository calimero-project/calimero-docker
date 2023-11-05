#!/bin/bash

targetJdk=$1
bootJdk="$(($targetJdk - 1))"

export skipCloneJdk=true
./configure-target-jdk.sh $targetJdk $2 $3

if [ ! -d "jdk${targetJdk}u" ]; then
  repo=https://github.com/openjdk/jdk"${targetJdk}"u.git
  git clone --depth 1 --single-branch $repo
fi 

echo "Mounting volume with JDK from $(pwd)/jdk${targetJdk}u"

docker run -it -v $(pwd)/jdk${targetJdk}u:/jdk openjdk$targetJdk-builder
