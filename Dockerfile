#
#   Copyright (C) 2020 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:14.04
MAINTAINER JaeHyuk Cho <minzkn@minzkn.com>

LABEL description="HWPORT dev environment (Ubuntu 14.04 LTS base)"
LABEL name="hwport/ubuntu:14.04"
LABEL url="http://www.minzkn.com/"
LABEL vendor="HWPORT"
LABEL version="1.0"

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

RUN rm -rf /var/lib/apt/lists/* && \
    sed -i -e "s/archive\.ubuntu\.com/kr\.archive\.ubuntu\.com/g" "/etc/apt/sources.list" && \
    apt-get update --list-cleanup && \
    apt-get remove -y nano vim-tiny cloud-init && \
    apt-get install -y apt-utils debconf-utils locales ca-certificates && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get install -y vim ssh \
        bash \
        coreutils \
        diffutils \
        findutils \
        sudo \
        dpkg-dev \
        build-essential \
        kernel-package \
        gcc-multilib \
        linux-headers-generic \
        gdb \
        binutils \
        bin86 \
        bison \
        flex \
        autoconf \
        automake \
        autotools-dev \
        m4 \
        libtool \
        pkg-config \
        make \
        cmake \
        ccache \
        cpio \
        exuberant-ctags \
        cscope \
        libexpat-dev \
        libmnl-dev \
        libgmp3-dev \
        libltdl-dev \
        sed \
        gawk \
        grep \
        patch \
        wget \
        git-core \
        diffstat \
        texinfo \
        libelf-dev \
        chrpath \
        socat \
        perl \
        python \
        python3 \
        python-dev \
        python-software-properties \
        python-pip \
        python-pexpect \
        python3-dev \
        python3-pip \
        libsdl1.2-dev \
        subversion \
        ftp \
        vim \
        libperl-dev \
        libnl1 \
        libnl-dev \
        rats \
        nodejs \
        npm \
        dos2unix \
        ruby-uglifier \
        node-uglify \
        yui-compressor \
        guile-2.0-dev \
        scons \
        bvi \
        golang \
        sshpass \
        lrzsz \
        zlib1g-dev \
        lib32z1 \
        unzip \
        zip \
        gzip \
        bzip2 \
        xz-utils \
        unrar \
        p7zip-full \
        expect \
        libevent-dev \
        libnetaddr-ip-perl \
        libnet-dns-perl \
        linuxdoc-tools \
        sparse \
        libncurses5 \
        libncurses5-dev \
        ncurses-term \
        libaio-dev \
        gnutls-bin \
        libgnutls-dev \
        libgettextpo-dev \
        gettext \
        libkldap4 \
        gperf \
        libnfnetlink-dev \
        libnetfilter-conntrack-dev \
        libboost-dev \
        u-boot-tools \
        openssl \
        libssl-dev \
        net-tools \
        whois \
        xmlto \
        genromfs \
        rsync \
        screen \
        curl \
        groff \
        groff-base \
        dnsutils \
        && \
    mkdir -p /var/run/sshd && \
    sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd && \
    cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.org && \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config && \
    echo "GatewayPorts yes" >> /etc/ssh/sshd_config && \
    echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config && \
    echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config && \
    apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

EXPOSE 22
#VOLUME ["/test-share1", "/test-share2", "/test-share3"]
#STOPSIGNAL SIGTERM
#HEALTHCHECK --interval=1m --timeout=3s --retries=3 CMD curl -f http://localhost || exit 1
WORKDIR /
CMD ["/usr/sbin/sshd","-D"]

# ----

# End of Dockerfile
