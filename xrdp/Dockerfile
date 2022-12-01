#
#   Copyright (C) 2020 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:20.04
MAINTAINER JaeHyuk Cho <minzkn@minzkn.com>

LABEL description="HWPORT Ubuntu 20.04 xrdp environment"
LABEL name="hwport/ubuntu:xrdp"
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
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update --list-cleanup
RUN DEBCONF_NOWARNINGS="yes" apt-get install -y debconf-utils apt-utils
RUN apt-get upgrade -y
RUN apt-get install -y ca-certificates ssl-cert
RUN apt-get install -y systemd systemd-sysv
RUN (cd /lib/systemd/system/sysinit.target.wants/ && ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1) && \
    rm -f \
        /lib/systemd/system/multi-user.target.wants/* \
        /etc/systemd/system/*.wants/* \
        /lib/systemd/system/local-fs.target.wants/* \
        /lib/systemd/system/sockets.target.wants/*udev* \
        /lib/systemd/system/sockets.target.wants/*initctl* \
        /lib/systemd/system/basic.target.wants/* \
        /lib/systemd/system/anaconda.target.wants/* \
        /lib/systemd/system/plymouth* \
        /lib/systemd/system/systemd-update-utmp*
RUN systemctl set-default multi-user.target

# install
RUN apt-get install -y \
        xfce4 \
        xfce4-terminal \
        xfce4-clipman-plugin \
        xfce4-cpugraph-plugin \
        xfce4-netload-plugin \
        xfce4-screenshooter \
        xfce4-taskmanager \
        xfce4-xkb-plugin \
        libfontenc1 \
        libxfont2 \
        xfonts-encodings \
        xfonts-utils \
        xfonts-base \
        xfonts-75dpi \
        xorgxrdp \
        xprintidle \
        xrdp \
        language-pack-ko \
        fonts-nanum \
        fonts-nanum-coding \
        fonts-nanum-extra \
        ibus \
        ibus-hangul \
        im-config \
        zenity
RUN sed -i -e 's,^test -x /etc/X11/Xsession \&\& exec /etc/X11/Xsession$,test -x /usr/bin/xfce4-session \&\& exec /usr/bin/xfce4-session,g' "/etc/xrdp/startwm.sh"
RUN echo "test -x /usr/bin/xfce4-session && exec /usr/bin/xfce4-session" >> /etc/skel/.Xsession

# Additional packages
RUN apt-get install -y firefox
RUN apt-get install -y putty
RUN apt-get install -y virt-manager ssh-askpass-gnome

# cleanup
RUN apt-get remove -y --purge avahi-daemon cups network-manager modemmanager wpasupplicant light-locker xscreensaver
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y --purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

EXPOSE 3389

VOLUME ["/sys/fs/cgroup"]
WORKDIR /

#STOPSIGNAL SIGTERM

CMD ["/lib/systemd/systemd"]

# ----

# End of Dockerfile
