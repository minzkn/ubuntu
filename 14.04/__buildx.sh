#!/bin/sh

#docker buildx build --push --no-cache --platform "linux/386,linux/amd64,linux/arm/v7,linux/arm64/v8,linux/ppc64le" --tag "hwport/ubuntu:14.04" .
docker buildx build --push --no-cache --platform "linux/amd64" --tag "hwport/ubuntu:14.04" .
