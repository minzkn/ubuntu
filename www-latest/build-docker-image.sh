#!/bin/sh

#docker buildx build --no-cache --push --platform linux/amd64,linux/arm64/v8,linux/ppc64le,linux/s390x --tag "hwport/ubuntu:www-latest" .
docker build --tag "hwport/ubuntu:www-latest" .
