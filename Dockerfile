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

# let Upstart know it's in a container
ENV container docker
ENV EDITER vim

# ----

RUN apt-get autoclean -y; \
    apt-get clean; \
    apt-get autoremove -y; \
    rm -rf /var/lib/apt/lists/*; \
    apt-get update --list-cleanup; \
    apt-get install -y apt-utils debconf-utils

# we're going to want this bad boy installed so we can connect :)
RUN apt-get install -y ssh; \
    sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd; \
    mkdir /run/sshd; \
    cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.org; \
    cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.org; \
    sed -ri "s/^PermitRootLogin\s+.*/PermitRootLogin yes/" /etc/ssh/sshd_config; \
    sed -i -e "s/^Port\s22$/Port 22\nPort 2222/g" /etc/ssh/sshd_config; \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config; \
    echo "GatewayPorts yes" >> /etc/ssh/sshd_config; \
    echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config; \
    echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config; \
    service ssh start
EXPOSE 22 2222

## undo some leet hax of the base image
#RUN rm /usr/sbin/policy-rc.d; \
#    rm /sbin/initctl; \
#    dpkg-divert --rename --remove /sbin/initctl

# generate a nice UTF-8 locale for our use
RUN apt-get install -y locales; \
    locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8

## remove some pointless services
#RUN /usr/sbin/update-rc.d -f ondemand remove; \
#    for f in \
#        /etc/init/u*.conf \
#        /etc/init/mounted-dev.conf \
#        /etc/init/mounted-proc.conf \
#        /etc/init/mounted-run.conf \
#        /etc/init/mounted-tmp.conf \
#        /etc/init/mounted-var.conf \
#        /etc/init/hostname.conf \
#        /etc/init/networking.conf \
#        /etc/init/tty*.conf \
#        /etc/init/plymouth*.conf \
#        /etc/init/hwclock*.conf \
#        /etc/init/module*.conf\
#    ; do \
#        dpkg-divert --local --rename --add "$f"; \
#    done; \
#    echo '# /lib/init/fstab: cleared out for bare-bones Docker' > /lib/init/fstab

# set a cheap, simple password for great convenience
RUN echo 'root:docker.io' | chpasswd
RUN /usr/sbin/useradd \
    -c "Default dev account" \
    -d "/home/dev" \
    -g users \
    -G users,adm,sudo \
    -m \
    -s /bin/bash \
    dev
RUN echo "dev:docker.io" | chpasswd

# installing essential
# already installed ? bash coreutils diffutils findutils
RUN apt-get install -y \
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
    vim \
    net-tools \
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
    ftp
RUN apt-get install -y xmlto
RUN apt-get install -y libboost-dev
RUN apt-get install -y python-dev
#RUN apt-get install -y python-software-properties
RUN apt-get install -y nodejs

# install misc (optional)
RUN apt-get install -y \
    libjpeg-dev \
    libpng-dev \
    libgif-dev \
    libssl-dev libcurl4-openssl-dev \
    libssh2-1-dev \
    libsqlite3-dev \
    freetds-dev \
    libpq-dev \
    libmysqlclient-dev \
    default-jdk

# install mips toolchain
#ADD https://sourcery.mentor.com/public/gnu_toolchain/mips-linux-gnu/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2 /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2
##COPY ./mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2 /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2
#RUN tar -xjf /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2 -C /opt; \
#    rm -f /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2

# clean meta
RUN apt-get autoclean -y
RUN apt-get clean
RUN apt-get autoremove -y
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

#VOLUME ["/test-share1", "/test-share2", "/test-share3"]

# ----

WORKDIR /
CMD ["/sbin/init"]

# ----

# End of Dockerfile
