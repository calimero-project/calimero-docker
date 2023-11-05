#!/bin/sh

targetJdk=$1
bootJdk="$(($targetJdk - 1))"
arch=amd64
# leave commented out to clone jdk in docker image
#skipCloneJdk=true

echo "Using boot JDK $bootJdk, configuring target JDK $targetJdk"

docker buildx build . -f compile/Dockerfile --platform linux/$arch \
    --build-arg bootJdk=$bootJdk --build-arg targetJdk=$targetJdk --build-arg skipCloneJdk=$skipCloneJdk \
    -t openjdk$targetJdk-builder $2 $3
