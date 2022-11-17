#
#   Copyright (C) 2015 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:12.04.5
MAINTAINER JaeHyuk Cho <minzkn@minzkn.com>

LABEL description="HWPORT Ubuntu 12.04 dev environment"
LABEL name="hwport/ubuntu:12.04"
LABEL url="http://www.minzkn.com/"
LABEL vendor="HWPORT"
LABEL version="1.0"

ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=xterm
ARG LC_ALL=C
ARG LANG=en_US.UTF-8

ENV container docker
#ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LC_ALL C
ENV LANG en_US.UTF-8
ENV EDITER vim

# ----

# pre setup
COPY ["entrypoint.sh", "/entrypoint.sh"]
COPY init-fake.conf /etc/init/fake-container-events.conf

RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
# For old unsupported release patch
RUN sed -i -re 's/([a-z]{2}\.)?archive.ubuntu.com|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
RUN apt-get update --list-cleanup
RUN DEBCONF_NOWARNINGS="yes" apt-get install -y debconf-utils apt-utils
RUN apt-get upgrade -y
RUN LC_ALL=C apt-get install -y locales && \
    LC_ALL=C locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LANGUAGE=en_US
RUN apt-get install -y ca-certificates
#RUN apt-get install -y ssl-certs

RUN rm /usr/sbin/policy-rc.d && \
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
        /etc/init/module*.conf\
    ; do \
        dpkg-divert --local --rename --add "$f"; \
    done && \
    echo '# /lib/init/fstab: cleared out for bare-bones Docker' > /lib/init/fstab && \
    chown root:root /entrypoint.sh && \
    chmod u=rwx,g=r,o=r /entrypoint.sh

# sshd setup
RUN apt-get install -y ssh && \
    sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.org && \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config && \
    echo "GatewayPorts yes" >> /etc/ssh/sshd_config && \
    echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config && \
    echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config

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
        dnsutils

# cleanup
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN apt-get install -y openjdk-7-jdk

# ----

EXPOSE 22

#VOLUME ["/sys/fs/cgroup"]
#VOLUME ["/run"]

WORKDIR /

#STOPSIGNAL SIGTERM

#HEALTHCHECK --interval=1m --timeout=3s --retries=3 CMD curl -f http://localhost || exit 1

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D"]
#CMD ["/bin/bash"]
#CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
#CMD ["/sbin/init"]

# ----

# End of Dockerfile
