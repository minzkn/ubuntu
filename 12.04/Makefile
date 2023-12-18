###
### Copyright (C) MINZKN.COM
### All rights reserved.
### Author: JAEHYUK CHO <mailto:minzkn@minzkn.com>
###

TARGET_PLATFORM_LIST:=linux/amd64#
TARGET_TAG_NAME:=hwport/ubuntu:12.04#

.PHONY: all clean buildx

all:
	@docker build --tag "$(TARGET_TAG_NAME)" .

clean:
	@echo "clean?"

buildx:
	@docker buildx build --no-cache --push --platform "$(TARGET_PLATFORM_LIST)" --tag "$(TARGET_TAG_NAME)" .

.DEFAULT:
	@echo "unknown goal: $(@)"

# End of Makefile
