#
#   Copyright (C) 2022 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:22.04
MAINTAINER JaeHyuk Cho <minzkn@minzkn.com>

LABEL description="HWPORT Ubuntu 22.04 xrdp environment"
LABEL name="hwport/ubuntu:xrdp-latest"
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
RUN chown root:root /entrypoint.sh && \
    chmod u=rwx,g=r,o=r /entrypoint.sh
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y --purge && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update --list-cleanup
RUN DEBCONF_NOWARNINGS="yes" apt-get install -y debconf-utils apt-utils
RUN apt-get upgrade -y
#RUN yes | unminimize
RUN LC_ALL=C apt-get install -y locales && \
    LC_ALL=C locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LANGUAGE=en_US
RUN apt-get install -y ca-certificates ssl-cert

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
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y --purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

EXPOSE 3389

WORKDIR /

#STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

# ----

# End of Dockerfile
