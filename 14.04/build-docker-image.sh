#!/bin/sh

#docker buildx build --no-cache --push --platform linux/amd64,linux/arm/v7,linux/arm64/v8,linux/ppc64le --tag "hwport/ubuntu:14.04" .
docker build --tag "hwport/ubuntu:14.04" .
