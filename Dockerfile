#
#   Copyright (C) 2019 HWPORT.COM
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

ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=xterm
ARG LC_ALL=C
ARG LANG=en_US.UTF-8

ENV container docker
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LC_ALL C
ENV LANG en_US.UTF-8
ENV EDITER vim

# ----

RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update --list-cleanup && \
    apt-get remove nano vim-tiny cloud-init && \
    apt-get install -y apt-utils debconf-utils locales dbus systemd ca-certificates vim && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get install -y \
        strongswan \
	&& \
    systemctl enable ipsec.service && \
    apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

EXPOSE 500 4500
#VOLUME ["/test-share1", "/test-share2", "/test-share3"]
#VOLUME ["/sys/fs/cgroup"]
#VOLUME ["/run"]
WORKDIR /
#STOPSIGNAL SIGTERM
#CMD ["/lib/systemd/systemd"]
#CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
#CMD ["/usr/sbin/sshd", "-D"]
#CMD ["/bin/bash", "-c", "/etc/init.d/ipsec start"]
CMD ["/sbin/init"]

# ----

# End of Dockerfile
