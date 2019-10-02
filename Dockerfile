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
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive
ENV EDITER vim

# ----

RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update --list-cleanup && \
    apt-get install -y apt-utils debconf-utils locales dbus systemd && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

# Don't start any optional services except for the few we need.
RUN find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -exec rm \{} \;

#RUN rm -f \
#    /lib/systemd/system/multi-user.target.wants/* \
#    /etc/systemd/system/*.wants/* \
#    /lib/systemd/system/local-fs.target.wants/* \
#    /lib/systemd/system/sockets.target.wants/*udev* \
#    /lib/systemd/system/sockets.target.wants/*initctl* \
#    /lib/systemd/system/basic.target.wants/* \
#    /lib/systemd/system/anaconda.target.wants/* \
#    /lib/systemd/system/plymouth* \
#    /lib/systemd/system/systemd-update-utmp*

RUN systemctl set-default multi-user.target

# we're going to want this bad boy installed so we can connect :)
RUN apt-get install -y ssh ca-certificates && \
    sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd && \
    mkdir /run/sshd && \
    cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.org && \
    cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.org && \
    sed -ri "s/^PermitRootLogin\s+.*/PermitRootLogin yes/" /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config && \
    echo "GatewayPorts yes" >> /etc/ssh/sshd_config && \
    echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config && \
    echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config && \
    systemctl enable ssh.service
EXPOSE 22

# set a cheap, simple password for great convenience
#RUN echo 'root:docker.io' | chpasswd
#RUN /usr/sbin/useradd \
#    -c "Default dev account" \
#    -d "/home/dev" \
#    -g users \
#    -G users,adm,sudo \
#    -m \
#    -s /bin/bash \
#    dev && \
#    echo "dev:docker.io" | chpasswd

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
    default-jdk
#RUN apt-get install -y python-software-properties

# install mips toolchain
#ADD https://sourcery.mentor.com/public/gnu_toolchain/mips-linux-gnu/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2 /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2
##COPY ./mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2 /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2
#RUN tar -xjf /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2 -C /opt && \
#    rm -f /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2

# clean meta
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

STOPSIGNAL SIGRTMIN+3

# ----

#VOLUME ["/test-share1", "/test-share2", "/test-share3"]
VOLUME ["/sys/fs/cgroup"]
VOLUME ["/run"]

# ----

WORKDIR /
#CMD ["/lib/systemd/systemd"]
#CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
CMD ["/sbin/init"]

# ----

# End of Dockerfile
