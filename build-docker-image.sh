#!/bin/sh

#docker buildx build --push --platform linux/386,linux/amd64,linux/arm/v7,linux/arm64/v8,linux/ppc64le,linux/s390x --tag "hwport/ubuntu:18.04" .
docker build --tag "hwport/ubuntu:18.04" .
