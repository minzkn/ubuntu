###
### Copyright (C) MINZKN.COM
### All rights reserved.
### Author: JAEHYUK CHO <mailto:minzkn@minzkn.com>
###

TARGET_PLATFORM_LIST:=linux/amd64#
TARGET_TAG_NAME:=hwport/ubuntu:smp86xx#

.PHONY: all clean buildx

all:
	@docker build --tag "$(TARGET_TAG_NAME)" .

clean:
	@echo "clean?"

buildx:
	@docker buildx build --push --no-cache --platform "$(TARGET_PLATFORM_LIST)" --tag "$(TARGET_TAG_NAME)" .
	@docker buildx build --push --no-cache --platform "$(TARGET_PLATFORM_LIST)" --tag "hwport/sigmadesigns:smp86xx" .
	@docker buildx build --push --no-cache --platform "$(TARGET_PLATFORM_LIST)" --tag "hwport/sigmadesigns:latest" .

.DEFAULT:
	@echo "unknown goal: $(@)"

# End of Makefile
