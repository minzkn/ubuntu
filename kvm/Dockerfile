#
#   Copyright (C) 2020 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:20.04
MAINTAINER JaeHyuk Cho <minzkn@minzkn.com>

LABEL description="HWPORT Ubuntu 20.04 systemd+kvm+xrdp environment"
LABEL name="hwport/ubuntu:kvm"
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
RUN DEBCONF_NOWARNINGS="yes" apt-get install -y debconf-utils apt-utils
RUN apt-get upgrade -y
RUN LC_ALL=C apt-get install -y locales && \
    LC_ALL=C locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LANGUAGE=en_US
RUN apt-get install -y ca-certificates ssl-cert
RUN apt-get install -y systemd systemd-sysv
RUN (cd /lib/systemd/system/sysinit.target.wants/ && ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1) && \
    rm -f \
        /lib/systemd/system/multi-user.target.wants/* \
        /etc/systemd/system/*.wants/* \
        /lib/systemd/system/local-fs.target.wants/* \
        /lib/systemd/system/sockets.target.wants/*udev* \
        /lib/systemd/system/sockets.target.wants/*initctl* \
        /lib/systemd/system/basic.target.wants/* \
        /lib/systemd/system/anaconda.target.wants/* \
        /lib/systemd/system/plymouth* \
        /lib/systemd/system/systemd-update-utmp*
RUN systemctl set-default multi-user.target

RUN apt-get install -y ssh

RUN apt-get install -y \
        qemu-kvm ovmf \
        bridge-utils \
        libvirt-daemon-system

# cleanup
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

EXPOSE 22 5900

VOLUME ["/sys/fs/cgroup"]
WORKDIR /

#STOPSIGNAL SIGTERM

CMD ["/lib/systemd/systemd"]
#CMD ["/usr/sbin/init"]

# ----

# End of Dockerfile
