#!/bin/sh

#docker build --tag "hwport/ubuntu:www" .
docker build --push --platform linux/amd64,linux/arm64/v8,linux/ppc64le,linux/s390 --tag "hwport/ubuntu:www" .
