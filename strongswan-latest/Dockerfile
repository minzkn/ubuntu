#
#   Copyright (C) 2022 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:22.04

ARG HWPORT_NAMESPACE=hwport
ARG HWPORT_IMAGE_NAME=ubuntu
ARG HWPORT_IMAGE_TAG=strongswan-latest
ARG HWPORT_VERSION=1.1
ARG HWPORT_URL=https://www.minzkn.com/
ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=xterm
ARG LC_ALL=C
ARG LANG=en_US.UTF-8

ENV \
  container="docker" \
  TERM="${TERM}" \
  LC_ALL="${LC_ALL}" \
  LANG="${LANG}" \
  EDITER="${EDITER}"

MAINTAINER HWPORT_MAINTAINER=JaeHyuk Cho <minzkn@minzkn.com>
LABEL \
  description="HWPORT ${HWPORT_IMAGE_NAME}:${HWPORT_IMAGE_TAG} dev environment" \
  name="${HWPORT_NAMESPACE}/${HWPORT_IMAGE_NAME}:${HWPORT_IMAGE_TAG}" \
  url="${HWPORT_URL}" \
  vendor="${HWPORT_NAMESPACE}" \
  version="${HWPORT_VERSION}"

WORKDIR /
RUN apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get update --list-cleanup \
  && DEBCONF_NOWARNINGS="yes" apt-get upgrade -y \
  && DEBCONF_NOWARNINGS="yes" apt-get install -y debconf-utils apt-utils software-properties-common \
  && apt-get install -y tzdata ca-certificates openssl ssl-cert

RUN apt-get install -y \
  iproute2 \
  iputils-ping \
  libgmp10

RUN DEV_PACKAGES="wget bzip2 make gcc libssl-dev libgmp-dev" VERSION=5.9.10 \
  && apt-get install -y $DEV_PACKAGES \ 
  && mkdir -p /strongswan-build \
  && cd /strongswan-build \
  && wget --no-check-certificate https://download.strongswan.org/strongswan-$VERSION.tar.bz2 \
  && tar -xjf strongswan-$VERSION.tar.bz2 \
  && cd strongswan-$VERSION \
  && ./configure --prefix=/usr --sysconfdir=/etc \
    --enable-charon --enable-ikev2 --enable-nonce --enable-random     \
    --enable-openssl --enable-pem --enable-x509 --enable-pubkey       \
    --enable-constraints --enable-pki --enable-socket-default         \
    --enable-kernel-netlink --enable-swanctl --enable-resolve         \
    --enable-eap-identity --enable-eap-md5 --enable-eap-mschapv2 --enable-eap-dynamic       \
    --enable-eap-tls --enable-updown --enable-vici                    \
    --enable-silent-rules \
   && make -j4 all && make install \
   && cd / && rm -R strongswan-build \
   && ln -s /usr/libexec/ipsec/charon charon \
   && apt-get remove -y --purge $DEV_PACKAGES
EXPOSE 500/udp 4500/udp

RUN apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

STOPSIGNAL SIGTERM
HEALTHCHECK NONE
CMD ["/usr/sbin/ipsec", "start", "--nofork"]

# End of Dockerfile
