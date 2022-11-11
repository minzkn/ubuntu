#
#   Copyright (C) 2020 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:20.04
MAINTAINER JaeHyuk Cho <minzkn@minzkn.com>

LABEL description="HWPORT strongswan (Ubuntu 20.04 LTS base)"
LABEL name="hwport/ubuntu:strongswan"
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

# ----

# pre setup
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update --list-cleanup
RUN apt-get upgrade -y

RUN apt-get install -y ca-certificates ssl-cert iproute2 iputils-ping strongswan
EXPOSE 500/udp 4500/udp

# cleanup
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

#VOLUME ["/sys/fs/cgroup"]
WORKDIR /

#STOPSIGNAL SIGTERM

CMD ["/usr/sbin/ipsec", "start", "--nofork"]

# ----

# End of Dockerfile
