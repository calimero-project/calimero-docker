#!/bin/sh

docker build . --build-arg LIBERICA_IMAGE_VARIANT=base -t liberica-openjdk-alpine-musl-base $1
