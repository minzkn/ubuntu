#
#   Copyright (C) 2022 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

# ----

FROM hwport/ubuntu:12.04

ARG HWPORT_NAMESPACE=hwport
ARG HWPORT_IMAGE_NAME=ubuntu
ARG HWPORT_IMAGE_TAG=smp86xx
ARG HWPORT_VERSION=1.1
ARG HWPORT_URL=https://www.minzkn.com/
ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=xterm
ARG LC_ALL=C
ARG LANG=en_US.UTF-8
ARG EDITOR=vim

ENV \
  container="docker" \
  TERM="${TERM}" \
  LC_ALL="${LC_ALL}" \
  LANG="${LANG}" \
  EDITOR="${EDITOR}"

LABEL \
  maintainer="JaeHyuk Cho <minzkn@minzkn.com>" \
  description="HWPORT ${HWPORT_IMAGE_NAME}:${HWPORT_IMAGE_TAG} dev environment" \
  name="${HWPORT_NAMESPACE}/${HWPORT_IMAGE_NAME}:${HWPORT_IMAGE_TAG}" \
  url="${HWPORT_URL}" \
  vendor="${HWPORT_NAMESPACE}" \
  version="${HWPORT_VERSION}"

WORKDIR /
#ADD https://sourcery.mentor.com/public/gnu_toolchain/mips-linux-gnu/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2 /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2
ADD http://www.minzkn.com/public/thirdparty/mips-linux-gnu/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2 /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2
#COPY mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2 /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2
RUN tar -xjf /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2 -C /opt/ \
  && rm -f /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2

EXPOSE 22/tcp
STOPSIGNAL SIGTERM
HEALTHCHECK NONE
CMD ["/usr/sbin/sshd", "-D"]

# End of Dockerfile
