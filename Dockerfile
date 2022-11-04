#
#   Copyright (C) 2015 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:16.04
MAINTAINER JaeHyuk Cho <minzkn@minzkn.com>

LABEL description="HWPORT Ubuntu 16.04 dev environment"
LABEL name="hwport/ubuntu:16.04"
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
COPY ["init-fake.conf", "/etc/init/fake-container-events.conf"]
RUN apt autoclean -y && \
    apt clean && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    sed -i -e "s/archive\.ubuntu\.com/kr\.archive\.ubuntu\.com/g" "/etc/apt/sources.list"; \
    apt update --list-cleanup && \
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
    sed -ri "s/^PermitRootLogin\s+.*/PermitRootLogin yes/" /etc/ssh/sshd_config && \
    sed -i -e "s/^Port\s22$/Port 22\nPort 2222/g" /etc/ssh/sshd_config && \
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config && \
    echo "GatewayPorts yes" >> /etc/ssh/sshd_config && \
    echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config && \
    echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config && \
    systemctl enable ssh.service

# set a cheap, simple password for great convenience
#RUN echo 'root:docker.io' | chpasswd
#RUN /usr/sbin/useradd \
#    -c "Default dev account" \
#    -d "/home/dev" \
#    -g users \
#    -G users,adm,sudo \
#    -m \
#    -s /bin/bash \
#    dev
#RUN echo "dev:duftlagl" | chpasswd

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
    cscope \
    exuberant-ctags \
    ftp \
    xmlto \
    libboost-dev \
    python-dev \
    python-software-properties

# installing ftp server
RUN echo "proftpd-basic shared/proftpd/inetd_or_standalone select standalone" | debconf-set-selections; \
    apt-get install -y \
    proftpd
RUN cp -f /etc/proftpd/proftpd.conf /etc/proftpd/proftpd.conf.org
COPY ["proftpd.conf", "/etc/proftpd/proftpd.conf"]
#COPY ["xproftpd", "/etc/xinet.d/xproftpd"]

# installing xinetd service (with tftpd)
RUN apt-get install -y xinetd tftpd tftp
COPY ["tftp", "/etc/xinet.d/tftp"]

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
##COPY ["mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2", "/tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2"]
#RUN tar -xjf /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2 -C /opt; \
#    rm -f /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2

# cleanup
RUN apt autoclean -y && \
    apt clean && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

EXPOSE 21 22 69 2222 65000 65001 65002 65003 65004 65005 65006 65007 65008 65009

#VOLUME ["/test-share1", "/test-share2", "/test-share3"]
#VOLUME ["/sys/fs/cgroup"]
#VOLUME ["/run"]

WORKDIR /

#STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D"]
#CMD ["/bin/bash"]
#CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
#CMD ["/sbin/init"]

# ----

# End of Dockerfile
