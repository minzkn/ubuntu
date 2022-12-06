#!/bin/sh

#docker buildx build --push --platform linux/amd64 --tag "hwport/ubuntu:12.04" .
docker build --tag "hwport/ubuntu:12.04" .
