#!/bin/sh

targetJdk=$1
bootJdk="$(($targetJdk - 1))"
# leave commented out to clone jdk in docker image
#skipCloneJdk=true

echo "Using boot JDK $bootJdk, configuring target JDK $targetJdk"

docker buildx build --build-arg bootJdk=$bootJdk --build-arg targetJdk=$targetJdk --build-arg skipCloneJdk=$skipCloneJdk --platform linux/arm/v7 -t openjdk$targetJdk-builder -f compile/Dockerfile . $2 $3

