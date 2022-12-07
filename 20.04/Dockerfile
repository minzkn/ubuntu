#
#   Copyright (C) 2022 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:20.04
MAINTAINER JaeHyuk Cho <minzkn@minzkn.com>

LABEL description="HWPORT Ubuntu 20.04 dev environment"
LABEL name="hwport/ubuntu:20.04"
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
COPY ["entrypoint.sh", "/entrypoint.sh"]
RUN chown root:root /entrypoint.sh && \
    chmod u=rwx,g=r,o=r /entrypoint.sh
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y --purge && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update --list-cleanup
RUN DEBCONF_NOWARNINGS="yes" apt-get install -y debconf-utils apt-utils
RUN apt-get upgrade -y
RUN yes | unminimize
RUN LC_ALL=C apt-get install -y locales && \
    LC_ALL=C locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LANGUAGE=en_US
RUN apt-get install -y ca-certificates ssl-cert

# sshd setup
RUN apt-get install -y \
	ssh \
        sed && \
    sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd && \
    mkdir -p /run/sshd && \
    cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.org && \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config && \
    echo "GatewayPorts yes" >> /etc/ssh/sshd_config && \
    echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config && \
    echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config

# dev packages install
RUN apt-get install -y \
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
	pkg-config \
        m4 autoconf automake libtool \
        cmake \
        bison \
        flex \
        gawk \
        grep \
        gettext \
        patch \
        linux-headers-generic \
	clang llvm \
	libelf-dev \
	libpcap-dev \
	dwarves \
	linux-tools-common \
	linux-tools-generic \
        vim \
        net-tools \
        ccache \
        git subversion \
        wget curl \
        screen \
        genromfs \
        rsync \
        texinfo \
        libncurses-dev ncurses-term \
        openssl \
        tar gzip bzip2 xz-utils unzip zlib1g-dev \
        man-db \
        cscope \
        exuberant-ctags \
        ftp \
        xmlto \
        libboost-dev \
        python3-dev \
        libssl-dev libcurl4-openssl-dev \
        libssh-dev \
        iproute2 \
        whois \
	dnsutils \
        inetutils-ping

# cleanup
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y --purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

EXPOSE 22

#VOLUME ["/sys/fs/cgroup"]
#VOLUME ["/run"]

WORKDIR /

#STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D"]

# ----

# End of Dockerfile
