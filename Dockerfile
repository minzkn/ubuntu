#
#   Copyright (C) 2019 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:18.04
MAINTAINER JaeHyuk Cho <minzkn@minzkn.com>

LABEL description="HWPORT xrdp+kvm environment (Ubuntu 18.04 LTS base)"
LABEL name="hwport/ubuntu:kvm"
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
        sudo \
        vim \
        xfce4 \
        xfce4-terminal \
        libfontenc1 \
        libxfont2 \
        xfonts-encodings \
        xfonts-utils \
        xfonts-base \
        xfonts-75dpi \
        xrdp \
        language-pack-ko \
        fonts-unfonts-core \
        fonts-unfonts-extra \
        fonts-baekmuk \
        fonts-nanum \
        fonts-nanum-coding \
        fonts-nanum-extra \
        ibus \
        ibus-hangul \
        im-config \
        zenity \
        qemu-kvm \
        libvirt-bin \
        ovmf \
        ubuntu-vm-builder \
        bridge-utils \
        virt-manager \
        ssh-askpass-gnome \
        virtualbox \
        && \
    systemctl enable xrdp.service && \
    systemctl enable libvirtd.service && \
    apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

EXPOSE 22 3389 5900
#VOLUME ["/test-share1", "/test-share2", "/test-share3"]
#VOLUME ["/sys/fs/cgroup"]
#VOLUME ["/run"]
WORKDIR /
#STOPSIGNAL SIGTERM
#CMD ["/lib/systemd/systemd"]
#CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
#CMD ["/usr/sbin/sshd", "-D"]
CMD ["/sbin/init"]

# ----

# End of Dockerfile
