#
#   Copyright (C) 2015 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:12.04
MAINTAINER JaeHyuk Cho <minzkn@minzkn.com>

LABEL description="HWPORT Ubuntu 12.04 dev environment"
LABEL name="hwport/ubuntu:12.04"
LABEL url="http://www.minzkn.com/"
LABEL vendor="HWPORT"
LABEL version="1.0"

ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=xterm
ARG LC_ALL=C
ARG LANG=un_US.UTF-8

ENV container docker
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LC_ALL C
ENV LANG un_US.UTF-8
ENV EDITER vim

# ----

RUN apt-get autoclean -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i -e "s/archive\.ubuntu\.com/kr\.archive\.ubuntu\.com/g" "/etc/apt/sources.list" && \
    apt-get update --list-cleanup && \
    apt-get install -y apt-utils debconf-utils ssh && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd && \
    cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.org && \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config && \
    echo "GatewayPorts yes" >> /etc/ssh/sshd_config && \
    echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config && \
    echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config && \
    rm /usr/sbin/policy-rc.d && \
    rm /sbin/initctl && \
    dpkg-divert --rename --remove /sbin/initctl && \
    /usr/sbin/update-rc.d -f ondemand remove && \
    for f in \
        /etc/init/u*.conf \
        /etc/init/mounted-dev.conf \
        /etc/init/mounted-proc.conf \
        /etc/init/mounted-run.conf \
        /etc/init/mounted-tmp.conf \
        /etc/init/mounted-var.conf \
        /etc/init/hostname.conf \
        /etc/init/networking.conf \
        /etc/init/tty*.conf \
        /etc/init/plymouth*.conf \
        /etc/init/hwclock*.conf \
        /etc/init/module*.conf; \
    do \
        dpkg-divert --local --rename --add "$f"; \
    done && \
    echo '# /lib/init/fstab: cleared out for bare-bones Docker' > /lib/init/fstab && \
    apt-get install -y \
        dpkg-dev \
        sudo \
        build-essential \
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
        net-tools \
        vim \
        ccache \
        subversion \
        git \
        wget \
        curl \
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
        cscope \
        exuberant-ctags \
        ftp \
        xmlto \
        libboost-dev \
        python-dev \
        python-software-properties \
        libjpeg-dev \
        libpng-dev \
        libgif-dev \
        libssl-dev libcurl4-openssl-dev \
        libssh2-1-dev \
        libsqlite3-dev \
        freetds-dev \
        libpq-dev \
        libmysqlclient-dev \
        openjdk-7-jdk

ADD init-fake.conf /etc/init/fake-container-events.conf

## set a cheap, simple password for great convenience
#RUN echo 'root:docker.io' | chpasswd
#RUN /usr/sbin/useradd \
#    -c "Default dev account" \
#    -d "/home/dev" \
#    -g users \
#    -G users,adm,sudo \
#    -m \
#    -s /bin/bash \
#    dev
#RUN echo "dev:docker.io" | chpasswd

## installing ftp server
#RUN echo "proftpd-basic shared/proftpd/inetd_or_standalone select standalone" | debconf-set-selections; \
#    apt-get install -y \
#    proftpd
#RUN cp -f /etc/proftpd/proftpd.conf /etc/proftpd/proftpd.conf.org
#COPY ./proftpd.conf /etc/proftpd/proftpd.conf
##COPY ./xproftpd /etc/xinet.d/xproftpd
#EXPOSE 21 65000 65001 65002 65003 65004 65005 65006 65007 65008 65009

# installing xinetd service (with tftpd)
#RUN apt-get install -y --no-install-recommends xinetd
#RUN apt-get install tftpd
#COPY ./tftp /etc/xinet.d/tftp
#EXPOSE 69

# install mips toolchain
ADD https://sourcery.mentor.com/public/gnu_toolchain/mips-linux-gnu/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2 /opt

# clean meta
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

EXPOSE 22
#VOLUME ["/test-share1", "/test-share2", "/test-share3"]
WORKDIR /
CMD ["/sbin/init"]

# ----

# End of Dockerfile
