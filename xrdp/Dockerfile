#
#   Copyright (C) 2024 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

# reference : https://docs.docker.com/engine/reference/builder/
# FROM [--platform=<platform>] <image> [AS <name>]
# FROM [--platform=<platform>] <image>[:<tag>] [AS <name>]
# FROM [--platform=<platform>] <image>[@<digest>] [AS <name>]
# RUN <command> (shell form, the command is run in a shell, which by default is /bin/sh -c on Linux or cmd /S /C on Windows)
# RUN ["executable", "param1", "param2"] (exec form)
# RUN --mount=[type=<TYPE>][,option=<value>[,option=<value>]...]
# CMD ["executable","param1","param2"] (exec form, this is the preferred form)
# CMD ["param1","param2"] (as default parameters to ENTRYPOINT)
# CMD command param1 param2 (shell form)
# LABEL <key>=<value> <key>=<value> <key>=<value> ...
# EXPOSE <port> [<port>/<protocol>...]
# ENV <key>=<value> ...
# ADD [--chown=<user>:<group>] [--checksum=<checksum>] <src>... <dest>
# ADD [--chown=<user>:<group>] ["<src>",... "<dest>"]
# COPY [--chown=<user>:<group>] <src>... <dest>
# COPY [--chown=<user>:<group>] ["<src>",... "<dest>"]
# ENTRYPOINT ["executable", "param1", "param2"]
# ENTRYPOINT command param1 param2
# VOLUME ["/data"]
# USER <user>[:<group>]
# USER <UID>[:<GID>]
# WORKDIR /path/to/workdir
# ARG <name>[=<default value>]
# ONBUILD <INSTRUCTION>
# STOPSIGNAL signal
# HEALTHCHECK [OPTIONS] CMD command (check container health by running a command inside the container)
#     --interval=DURATION (default: 30s)
#     --timeout=DURATION (default: 30s)
#     --start-period=DURATION (default: 0s)
#     --retries=N (default: 3)
# HEALTHCHECK NONE (disable any healthcheck inherited from the base image)
# SHELL ["executable", "parameters"]

# ----

FROM ubuntu:24.04

ARG HWPORT_NAMESPACE=hwport
ARG HWPORT_IMAGE_NAME=ubuntu
ARG HWPORT_IMAGE_TAG=xrdp
ARG HWPORT_VERSION=1.1
ARG HWPORT_URL=https://www.minzkn.com/
ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=xterm
ARG LC_ALL=C
ARG LANG=en_US.UTF-8
ARG EDITOR=vim

ARG BUILDPLATFORM
ARG BUILDOS
ARG BUILDARCH
ARG BUILDVARIANT
ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH
ARG TARGETVARIANT

ENV \
  container="docker" \
  TERM="${TERM}" \
  LC_ALL="${LC_ALL}" \
  LANG="${LANG}" \
  EDITOR="${EDITOR}"

LABEL \
  maintainer="JaeHyuk Cho <minzkn@minzkn.com>" \
  description="HWPORT ${HWPORT_IMAGE_NAME}:${HWPORT_IMAGE_TAG} dev environment" \
  name="${HWPORT_NAMESPACE}/${HWPORT_IMAGE_NAME}:${HWPORT_IMAGE_TAG}" \
  url="${HWPORT_URL}" \
  vendor="${HWPORT_NAMESPACE}" \
  version="${HWPORT_VERSION}"

WORKDIR /
COPY --chown=root:root ["entrypoint.sh", "/entrypoint.sh"]
COPY --chown=root:root ["autostart", "/etc/skel/.config/autostart"]
RUN echo "# Powered by ${HWPORT_URL}" >> /entrypoint.sh \
  && echo "# BUILDPLATFORM: ${BUILDPLATFORM}" >> /entrypoint.sh \
  && echo "# BUILDOS: ${BUILDOS}" >> /entrypoint.sh \
  && echo "# BUILDARCH: ${BUILDARCH}" >> /entrypoint.sh \
  && echo "# BUILDVARIANT: ${BUILDVARIANT}" >> /entrypoint.sh \
  && echo "# TARGETPLATFORM: ${TARGETPLATFORM}" >> /entrypoint.sh \
  && echo "# TARGETOS: ${TARGETOS}" >> /entrypoint.sh \
  && echo "# TARGETARCH: ${TARGETARCH}" >> /entrypoint.sh \
  && echo "# TARGETVARIANT: ${TARGETVARIANT}" >> /entrypoint.sh \
  && echo "# buildx cores: $(nproc)" >> /entrypoint.sh \
  && (userdel -r ubuntu || true) \
  && apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* \
  && sed -i -e 's/^Types: deb$/Types: deb deb-src/g' /etc/apt/sources.list.d/ubuntu.sources \
  && apt-get update -y --list-cleanup \
  && apt-get --fix-broken install -y \
  && DEBCONF_NOWARNINGS="yes" apt-get upgrade -y
RUN apt-get install -y unminimize && yes | unminimize
RUN apt-get install -y \
  software-properties-common \
  tzdata debconf-utils locales \
  ca-certificates apt-transport-https gnupg2 ubuntu-keyring \
  && locale-gen en_US.UTF-8 \
  && locale-gen ko_KR.UTF-8 \
  && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US \
  && add-apt-repository -y ppa:mozillateam/ppa \
  && add-apt-repository -y ppa:maarten-fonville/android-studio \
  && echo 'Package: *' > /etc/apt/preferences.d/mozilla-firefox \
  && echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozilla-firefox \
  && echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozilla-firefox \
  && echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' > /etc/apt/apt.conf.d/51unattended-upgrades-firefox
RUN apt-get update -y --list-cleanup \
  && apt-get install -y \
  sudo \
  tar gzip bzip2 xz-utils unzip zlib1g-dev \
  iproute2 \
  inetutils-ping \
  vim \
  build-essential dpkg-dev libpulse-dev git autoconf libtool \
  cron \
  logrotate \
  ssh \
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
  dbus-x11 \
  language-selector-common language-selector-gnome language-pack-ko fonts-noto-cjk-extra fonts-noto-cjk hunspell-ko \
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
  flameshot \
  putty \
  remmina \
  virt-manager \
  librecad \
  gimp \
  ffmpeg \
  vlc \
  iverilog gtkwave \
  clamav \
  mesa-va-drivers mesa-vdpau-drivers mesa-vulkan-drivers mesa-common-dev mesa-utils \
  $(if [ "${TARGETARCH}" = "amd64" -o "${TARGETARCH}" = "arm64" ]; then echo "mesa-drm-shim"; fi) \
  $(if [ "${TARGETARCH}" = "amd64" -o "${TARGETARCH}" = "arm64" ]; then echo "libreoffice"; fi) \
  $(if [ "${TARGETARCH}" = "amd64" -o "${TARGETARCH}" = "arm64" ]; then echo "kicad"; fi) \
  $(if [ "${TARGETARCH}" = "amd64" -o "${TARGETARCH}" = "arm64" ]; then echo "firefox"; fi) \
  $(if [ "${TARGETARCH}" = "amd64" ]; then echo "android-studio"; fi) \
  $(if [ "${TARGETARCH}" = "amd64" ]; then echo "nvidia-cuda-toolkit" "libnvidia-compute-580-server" "libnvidia-encode-580-server" "libnvidia-decode-580-server" "xserver-xorg-video-nvidia-580-server"; fi) \
  && sed -i \
    -e 's,^test -x /etc/X11/Xsession \&\& exec /etc/X11/Xsession$,test -x /usr/bin/xfce4-session \&\& exec /usr/bin/xfce4-session,g' \
    "/etc/xrdp/startwm.sh" \
  && echo "test -x /usr/bin/xfce4-session && exec /usr/bin/xfce4-session" >> /etc/skel/.Xsession
RUN git clone https://github.com/neutrinolabs/pulseaudio-module-xrdp.git /root/pulseaudio-module-xrdp \
  && sudo -i sh -c "cd /root/pulseaudio-module-xrdp && (./scripts/install_pulseaudio_sources_apt.sh || (cat /var/tmp/pa-build-root-schroot.log && false)) && ./bootstrap && ./configure PULSE_DIR=/root/pulseaudio.src && make && make install" \
  && rm -rf /root/pulseaudio-module-xrdp /root/pulseaudio.src /var/tmp/pa-build-*.log
RUN apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 3389/tcp
STOPSIGNAL SIGTERM
HEALTHCHECK NONE
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

# End of Dockerfile
