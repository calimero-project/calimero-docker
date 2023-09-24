#!/bin/sh

docker buildx build . --platform=arm64 --build-arg LIBERICA_IMAGE_VARIANT=base -t liberica-openjdk-alpine-musl-base $1
docker buildx build . --platform=arm64 --build-arg LIBERICA_IMAGE_VARIANT=base-minimal -t liberica-openjdk-alpine-musl-base-minimal $1
