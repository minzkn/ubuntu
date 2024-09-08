###
### Copyright (C) MINZKN.COM
### All rights reserved.
### Author: JAEHYUK CHO <mailto:minzkn@minzkn.com>
###

TARGET_PLATFORM_LIST:=linux/amd64,linux/arm/v7,linux/arm64/v8,linux/ppc64le,linux/riscv64,linux/s390x#
TARGET_TAG_NAME:=hwport/ubuntu:20.04#

.PHONY: all clean buildx

all:
	@docker build --tag "$(TARGET_TAG_NAME)" .

clean:
	@echo "clean?"

buildx:
	@docker buildx build --push --platform "$(TARGET_PLATFORM_LIST)" --tag "$(TARGET_TAG_NAME)" .

.DEFAULT:
	@echo "unknown goal: $(@)"

# End of Makefile
