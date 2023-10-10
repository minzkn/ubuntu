#
#   Copyright (C) 2022 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:22.04

ARG HWPORT_NAMESPACE=hwport
ARG HWPORT_IMAGE_NAME=ubuntu
ARG HWPORT_IMAGE_TAG=xrdp
ARG HWPORT_VERSION=1.1
ARG HWPORT_URL=https://www.minzkn.com/
ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=xterm
ARG LC_ALL=C
ARG LANG=en_US.UTF-8

ENV \
  container="docker" \
  TERM="${TERM}" \
  LC_ALL="${LC_ALL}" \
  LANG="${LANG}" \
  EDITER="${EDITER}"

MAINTAINER HWPORT_MAINTAINER=JaeHyuk Cho <minzkn@minzkn.com>
LABEL \
  description="HWPORT ${HWPORT_IMAGE_NAME}:${HWPORT_IMAGE_TAG} dev environment" \
  name="${HWPORT_NAMESPACE}/${HWPORT_IMAGE_NAME}:${HWPORT_IMAGE_TAG}" \
  url="${HWPORT_URL}" \
  vendor="${HWPORT_NAMESPACE}" \
  version="${HWPORT_VERSION}"

WORKDIR /
COPY --chown=root:root ["entrypoint.sh", "/entrypoint.sh"]
RUN apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get update --list-cleanup \
  && DEBCONF_NOWARNINGS="yes" apt-get upgrade -y \
  && DEBCONF_NOWARNINGS="yes" apt-get install -y debconf-utils apt-utils software-properties-common apt-transport-https ca-certificates gnupg2 ubuntu-keyring \
  && yes | unminimize \
  && apt-get install -y tzdata ca-certificates openssl ssl-cert locales wget curl \
  && locale-gen en_US.UTF-8 \
  && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US

# COPY META...
COPY --chown=root:root ["autostart", "/etc/skel/.config/autostart"]

# additional repository setup : fix for 'mozilla-firefox without snap', 'android-studio'
RUN add-apt-repository -y ppa:mozillateam/ppa \
  && echo 'Package: *' > /etc/apt/preferences.d/mozilla-firefox \
  && echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozilla-firefox \
  && echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozilla-firefox \
  && echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' > /etc/apt/apt.conf.d/51unattended-upgrades-firefox

# additional repository setup : for android-studio (need 'sudo apt update && sudo apt install android-studio')
RUN add-apt-repository -y ppa:maarten-fonville/android-studio

RUN apt-get update --list-cleanup \
  && apt-get install -y \
  sudo \
  tar gzip bzip2 xz-utils unzip zlib1g-dev \
  iproute2 \
  inetutils-ping \
  vim \
  build-essential dpkg-dev libpulse-dev git autoconf libtool \
  cron \
  logrotate \
  xfce4 \
  xfce4-terminal \
  xfce4-clipman-plugin \
  xfce4-cpugraph-plugin \
  xfce4-netload-plugin \
  xfce4-screenshooter \
  xfce4-taskmanager \
  xfce4-xkb-plugin \
  xfce4-goodies \
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
  fonts-naver-d2coding \
  ibus \
  ibus-hangul \
  im-config \
  zenity \
  gvfs-backends smbclient \
  ssh-askpass-gnome \
  putty \
  virt-manager \
  libreoffice \
  librecad \
  gimp \
  ffmpeg \
  vlc \
  firefox \
  && sed -i \
    -e 's,^test -x /etc/X11/Xsession \&\& exec /etc/X11/Xsession$,test -x /usr/bin/xfce4-session \&\& exec /usr/bin/xfce4-session,g' \
    "/etc/xrdp/startwm.sh" \
  && echo "test -x /usr/bin/xfce4-session && exec /usr/bin/xfce4-session" >> /etc/skel/.Xsession

# pulseaudio module : for Audio XDRP redirection module
#RUN git clone https://github.com/neutrinolabs/pulseaudio-module-xrdp.git /root/pulseaudio-module-xrdp \
#  && sudo -i sh -c "cd /root/pulseaudio-module-xrdp && (./scripts/install_pulseaudio_sources_apt_wrapper.sh || (cat /var/tmp/pa-build-root-schroot.log && false)) && ./bootstrap && ./configure PULSE_DIR=/root/pulseaudio.src && make && make install" \
#  && rm -rf /root/pulseaudio-module-xrdp /root/pulseaudio.src /var/tmp/pa-build-*.log
RUN git clone https://github.com/neutrinolabs/pulseaudio-module-xrdp.git /root/pulseaudio-module-xrdp \
  && sudo -i sh -c "cd /root/pulseaudio-module-xrdp && (./scripts/install_pulseaudio_sources_apt.sh || (cat /var/tmp/pa-build-root-schroot.log && false)) && ./bootstrap && ./configure PULSE_DIR=/root/pulseaudio.src && make && make install" \
  && rm -rf /root/pulseaudio-module-xrdp /root/pulseaudio.src /var/tmp/pa-build-*.log

RUN apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3389
STOPSIGNAL SIGTERM
HEALTHCHECK NONE
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

# End of Dockerfile
