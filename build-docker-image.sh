#!/bin/sh

#docker buildx build --push --platform linux/amd64,linux/arm64/v8,linux/ppc64le,linux/s390x --tag "hwport/ubuntu:www" .
docker build --tag "hwport/ubuntu:www" .
