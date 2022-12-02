#
#   Copyright (C) 2022 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:22.04
MAINTAINER JaeHyuk Cho <minzkn@minzkn.com>

LABEL description="HWPORT strongswan (Ubuntu 22.04 LTS base)"
LABEL name="hwport/ubuntu:strongswan-latest"
LABEL url="http://www.minzkn.com/"
LABEL vendor="HWPORT"
LABEL version="1.1"

# environment for build
ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=xterm
ARG LC_ALL=C
ARG LANG=en_US.UTF-8

# environment for run
ENV container docker
#ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LC_ALL C
ENV LANG en_US.UTF-8
ENV EDITER vim

# strongswan build version
ENV VERSION="5.9.8"

# ----

# pre setup
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y --purge && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update --list-cleanup
RUN apt-get upgrade -y

RUN apt-get install -y \
    ca-certificates \
    ssl-cert \
    openssl \
    iproute2 \
    iputils-ping \
    libgmp10

# build strongswan
RUN DEV_PACKAGES="wget bzip2 make gcc libssl-dev libgmp-dev" && \
  apt-get install -y $DEV_PACKAGES && \ 
  mkdir -p /strongswan-build && \
  cd /strongswan-build && \
  wget --no-check-certificate https://download.strongswan.org/strongswan-$VERSION.tar.bz2 && \
  tar -xjf strongswan-$VERSION.tar.bz2 && \
  cd strongswan-$VERSION && \
  ./configure --prefix=/usr --sysconfdir=/etc \
    --enable-charon --enable-ikev2 --enable-nonce --enable-random     \
    --enable-openssl --enable-pem --enable-x509 --enable-pubkey       \
    --enable-constraints --enable-pki --enable-socket-default         \
    --enable-kernel-netlink --enable-swanctl --enable-resolve         \
    --enable-eap-identity --enable-eap-md5 --enable-eap-mschapv2 --enable-eap-dynamic       \
    --enable-eap-tls --enable-updown --enable-vici                    \
    --enable-silent-rules  && \
   make all && make install && \
   cd / && rm -R strongswan-build && \
   ln -s /usr/libexec/ipsec/charon charon && \
   apt-get remove -y --purge $DEV_PACKAGES
EXPOSE 500/udp 4500/udp

# cleanup
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y --purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

#VOLUME ["/sys/fs/cgroup"]
WORKDIR /

#STOPSIGNAL SIGTERM

CMD ["/usr/sbin/ipsec", "start", "--nofork"]

# ----

# End of Dockerfile
