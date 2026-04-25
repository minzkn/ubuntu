#
#   Copyright (C) 2026 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:26.04

ARG HWPORT_NAMESPACE=hwport
ARG HWPORT_IMAGE_NAME=ubuntu
ARG HWPORT_IMAGE_TAG=strongswan
ARG HWPORT_VERSION=1.2
ARG HWPORT_URL=https://www.minzkn.com/
ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=xterm
ARG LC_ALL=C
ARG LANG=en_US.UTF-8

ARG BUILDPLATFORM
ARG BUILDOS
ARG BUILDARCH
ARG BUILDVARIANT
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

ENV \
  container="docker" \
  TERM="${TERM}" \
  LC_ALL="${LC_ALL}" \
  LANG="${LANG}"

LABEL \
  maintainer="JaeHyuk Cho <minzkn@minzkn.com>" \
  description="HWPORT ${HWPORT_IMAGE_NAME}:${HWPORT_IMAGE_TAG} dev environment" \
  name="${HWPORT_NAMESPACE}/${HWPORT_IMAGE_NAME}:${HWPORT_IMAGE_TAG}" \
  url="${HWPORT_URL}" \
  vendor="${HWPORT_NAMESPACE}" \
  version="${HWPORT_VERSION}" \
  build.platform="${BUILDPLATFORM}" \
  build.os="${BUILDOS}" \
  build.arch="${BUILDARCH}" \
  build.variant="${BUILDVARIANT}" \
  target.platform="${TARGETPLATFORM}" \
  target.os="${TARGETOS}" \
  target.arch="${TARGETARCH}" \
  target.variant="${TARGETVARIANT}"

WORKDIR /
RUN (userdel -r ubuntu || true) \
  && apt-get update -y --list-cleanup \
  && apt-get --fix-broken install -y \
  && DEBCONF_NOWARNINGS="yes" apt-get upgrade -y
RUN apt-get install -y \
  tzdata \
  ca-certificates openssl ssl-cert \
  iproute2 \
  iputils-ping \
  strongswan \
  strongswan-starter \
  libcharon-extra-plugins \
  libstrongswan-extra-plugins
RUN apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 500/udp 4500/udp
STOPSIGNAL SIGTERM
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD /usr/sbin/ipsec statusall >/dev/null 2>&1 || exit 1
CMD ["/usr/sbin/ipsec", "start", "--nofork"]

# End of Dockerfile
