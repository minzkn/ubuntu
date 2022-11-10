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
#ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LC_ALL C
ENV LANG en_US.UTF-8
ENV EDITER vim

# ----

# pre setup
COPY ["entrypoint.sh", "/entrypoint.sh"]
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i -e "s/archive\.ubuntu\.com/kr\.archive\.ubuntu\.com/g" "/etc/apt/sources.list" && \
    apt-get update --list-cleanup && \
    apt-get install -y \
        apt-utils \
        debconf-utils \
        locales \
        dbus \
        systemd \
        ssh \
        ca-certificates && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
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
        /etc/init/module*.conf\
    ; do \
        dpkg-divert --local --rename --add "$f"; \
    done && \
    echo '# /lib/init/fstab: cleared out for bare-bones Docker' > /lib/init/fstab && \
    chown root:root /entrypoint.sh && \
    chmod u=rwx,g=r,o=r /entrypoint.sh

# sshd setup
RUN sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd && \
    mkdir /run/sshd && \
    cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.org && \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config && \
    echo "GatewayPorts yes" >> /etc/ssh/sshd_config && \
    echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config && \
    echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config

RUN apt-get install -y vim ssh \
        bash \
        coreutils \
        diffutils \
        findutils \
        sudo \
        dpkg-dev \
        build-essential \
        kernel-package \
        linux-headers-generic \
        gdb \
        binutils \
        bin86 \
        bison \
        flex \
        autoconf \
        automake \
        autotools-dev \
        autopoint \
        m4 \
        libtool \
        pkg-config \
        make \
        cmake3 \
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
        dos2unix \
        yui-compressor \
        guile-2.0-dev \
        scons \
        bvi \
        golang \
        sshpass \
        lrzsz \
        zlib1g-dev \
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
        dnsutils

#RUN pip3 install jsmin

# cleanup
RUN apt-get autoclean -y && \
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

#HEALTHCHECK --interval=1m --timeout=3s --retries=3 CMD curl -f http://localhost || exit 1

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D"]
#CMD ["/bin/bash"]
#CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
#CMD ["/sbin/init"]

# ----

# End of Dockerfile
