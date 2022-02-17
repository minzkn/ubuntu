#
#   Copyright (C) 2020 HWPORT.COM
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
RUN apt autoclean -y && \
    apt clean && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    apt update --list-cleanup && \
    yes | unminimize && \
    apt install -y \
        apt-utils \
        debconf-utils \
        locales \
        dbus \
        systemd \
        ssh \
        ca-certificates && \
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
    chown root:root /entrypoint.sh && \
    chmod u=rwx,g=r,o=r /entrypoint.sh

# sshd setup
RUN sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd && \
    mkdir /run/sshd && \
    cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.org && \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config && \
    echo "GatewayPorts yes" >> /etc/ssh/sshd_config && \
    echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config && \
    echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config && \
    systemctl enable ssh.service

# dev packages install
RUN apt install -y \
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
	pkg-config \
        m4 \
        autoconf \
        automake \
        libtool \
        cmake \
        scons \
        bison \
        flex \
        gawk \
        gettext \
        grep \
        sed \
        patch \
        linux-headers-generic \
	clang \
	llvm \
	libelf-dev \
	libpcap-dev \
	gcc-multilib \
	build-essential \
	linux-tools-common \
	linux-tools-generic \
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
        libelf-dev \
        libncurses-dev \
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
        python3-dev \
        nodejs \
        libjpeg-dev \
        libpng-dev \
        libgif-dev \
        libssl-dev libcurl4-openssl-dev \
        libssh-dev \
        libsqlite3-dev \
        freetds-dev \
        libpq-dev \
        libmysqlclient-dev \
        default-jdk \
        iproute2 \
        whois \
	dnsutils \
        inetutils-ping

# cleanup
RUN apt autoclean -y && \
    apt clean && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

EXPOSE 22

#VOLUME ["/test-share1", "/test-share2", "/test-share3"]
#VOLUME ["/sys/fs/cgroup"]
#VOLUME ["/run"]

WORKDIR /

#STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D"]
#CMD ["/bin/bash"]
#CMD ["/lib/systemd/systemd"]
#CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
#CMD ["/sbin/init"]

# ----

# End of Dockerfile
