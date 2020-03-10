#
#   Copyright (C) 2019 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:18.04
MAINTAINER JaeHyuk Cho <minzkn@minzkn.com>

LABEL description="HWPORT Ubuntu 18.04 dev environment"
LABEL name="hwport/ubuntu:18.04"
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
    apt-get install -y apt-utils debconf-utils locales dbus systemd ssh ca-certificates && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    find /etc/systemd/system \
        /lib/systemd/system \
        -path '*.wants/*' \
        -not -name '*journald*' \
        -not -name '*systemd-tmpfiles*' \
        -not -name '*systemd-user-sessions*' \
        -exec rm \{} \; && \
    systemctl set-default multi-user.target && \
    sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd && \
    mkdir /run/sshd && \
    cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.org && \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config && \
    echo "GatewayPorts yes" >> /etc/ssh/sshd_config && \
    echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config && \
    echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config && \
    systemctl enable ssh.service && \
    apt-get install -y \
        dpkg-dev \
        sudo \
        build-essential \
        kernel-package \
        binutils \
        gcc \
        g++ \
        libc-dev \
        gdb \
        perl \
        make \
        m4 \
        autoconf \
        automake \
        libtool \
        cmake \
        scons \
        bison \
        gawk \
        gettext \
        grep \
        sed \
        patch \
        linux-headers-generic \
        vim \
        net-tools \
        ccache \
        subversion \
        git \
        wget \
        curl \
        screen \
        genromfs \
        rsync \
        texinfo \
        libncurses5-dev \
        ncurses-term \
        openssl \
        tar \
        gzip \
        bzip2 \
        xz-utils \
        unzip \
        zlib1g-dev \
        lib32z1 \
        man-db \
        cscope \
        exuberant-ctags \
        ftp \
        xmlto \
        libboost-dev \
        python-dev \
        nodejs \
        libjpeg-dev \
        libpng-dev \
        libgif-dev \
        libssl-dev libcurl4-openssl-dev \
        libssh2-1-dev \
        libsqlite3-dev \
        freetds-dev \
        libpq-dev \
        libmysqlclient-dev \
        default-jdk \
        iproute2 \
        whois \
        dnsutils \
	&& \
    apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

EXPOSE 22
#VOLUME ["/test-share1", "/test-share2", "/test-share3"]
#VOLUME ["/sys/fs/cgroup"]
#VOLUME ["/run"]
WORKDIR /
#STOPSIGNAL SIGTERM
#CMD ["/lib/systemd/systemd"]
#CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
CMD ["/usr/sbin/sshd", "-D"]
#CMD ["/sbin/init"]

# ----

# End of Dockerfile
