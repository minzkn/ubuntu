#
#   Copyright (C) 2026 HWPORT.COM
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

FROM ubuntu:26.04

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
  version="${HWPORT_VERSION}" \
  build.platform="${BUILDPLATFORM}" \
  build.os="${BUILDOS}" \
  build.arch="${BUILDARCH}" \
  build.variant="${BUILDVARIANT}" \
  target.platform="${TARGETPLATFORM}" \
  target.os="${TARGETOS}" \
  target.arch="${TARGETARCH}" \
  target.variant="${TARGETVARIANT}"

WORKDIR /
COPY --chown=root:root ["entrypoint.sh", "/entrypoint.sh"]
COPY --chown=root:root ["autostart", "/etc/skel/.config/autostart"]
RUN (userdel -r ubuntu || true) \
  && sed -i -e 's/^Types: deb$/Types: deb deb-src/g' /etc/apt/sources.list.d/ubuntu.sources \
  && apt-get update -y --list-cleanup \
  && apt-get --fix-broken install -y \
  && DEBCONF_NOWARNINGS="yes" apt-get upgrade -y
RUN (apt-get install -y unminimize || true) && yes | unminimize
RUN apt-get install -y \
  software-properties-common \
  tzdata debconf-utils locales \
  ca-certificates gnupg2 ubuntu-keyring \
  wget \
  && locale-gen en_US.UTF-8 \
  && locale-gen ko_KR.UTF-8 \
  && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US \
  && install -d -m 0755 /etc/apt/keyrings \
  && wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O /etc/apt/keyrings/packages.mozilla.org.asc \
  && echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" > /etc/apt/sources.list.d/mozilla.list \
  && printf 'Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000\n' > /etc/apt/preferences.d/mozilla-firefox
RUN apt-get update -y --list-cleanup \
  && apt-get install -y \
  sudo \
  tar gzip bzip2 xz-utils unzip zlib1g-dev \
  iproute2 \
  inetutils-ping \
  vim \
  build-essential dpkg-dev libpulse-dev libpipewire-0.3-dev libspa-0.2-dev git autoconf libtool \
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
  fonts-nanum-eco \
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
  ffmpeg \
  vlc \
  iverilog gtkwave \
  clamav \
  xpdf \
  mesa-libgallium mesa-vulkan-drivers mesa-common-dev mesa-utils \
  mesa-drm-shim \
  libreoffice \
  $(if [ "${TARGETARCH}" != "s390x" ]; then echo "gimp"; fi) \
  $(if [ "${TARGETARCH}" != "s390x" ]; then echo "kicad"; fi) \
  $(if [ "${TARGETARCH}" = "amd64" -o "${TARGETARCH}" = "arm64" ]; then echo "wine64"; fi) \
  $(if [ "${TARGETARCH}" = "amd64" -o "${TARGETARCH}" = "arm64" ]; then echo "firefox"; fi) \
  $(if [ "${TARGETARCH}" = "amd64" ]; then echo "nvidia-cuda-toolkit libnvidia-compute-595-server libnvidia-encode-595-server libnvidia-decode-595-server xserver-xorg-video-nvidia-595-server"; fi) \
  && printf '#!/bin/sh\nif [ -r /etc/default/locale ]; then\n  . /etc/default/locale\n  export LANG LANGUAGE\nfi\nuid=$(id -u)\nexport XDG_RUNTIME_DIR="/tmp/runtime-${uid}"\nmkdir -p "${XDG_RUNTIME_DIR}"\nchmod 0700 "${XDG_RUNTIME_DIR}"\nunset DBUS_SESSION_BUS_ADDRESS SESSION_MANAGER\ntest -x /usr/bin/xfce4-session && exec dbus-launch --exit-with-session /usr/bin/xfce4-session\nexec /bin/sh /etc/X11/Xsession\n' > /etc/xrdp/startwm.sh \
  && chmod +x /etc/xrdp/startwm.sh \
  && echo "test -x /usr/bin/xfce4-session && exec /usr/bin/xfce4-session" >> /etc/skel/.Xsession \
  && adduser xrdp ssl-cert \
  && sed -i '/^\[Security\]/a SessionSockdirGroup=xrdp' /etc/xrdp/sesman.ini \
  && mkdir -p /etc/xdg/xfce4/xfconf/xfce-perchannel-xml /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml \
  && printf '<?xml version="1.0" encoding="UTF-8"?>\n<channel name="xfce4-session" version="1.0">\n  <property name="general" type="empty">\n    <property name="SaveOnExit" type="bool" value="false"/>\n    <property name="LogoutTimeout" type="int" value="10"/>\n  </property>\n  <property name="shutdown" type="empty">\n    <property name="ShowHibernate" type="bool" value="false"/>\n    <property name="ShowSuspend" type="bool" value="false"/>\n    <property name="ShowPowerOff" type="bool" value="false"/>\n    <property name="ShowRestart" type="bool" value="false"/>\n    <property name="ShowHybridSleep" type="bool" value="false"/>\n  </property>\n</channel>\n' > /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml \
  && cp /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-session.xml
RUN git clone https://github.com/neutrinolabs/pipewire-module-xrdp.git /root/pipewire-module-xrdp \
  && git -C /root/pipewire-module-xrdp checkout v0.2 \
  && sh -c "cd /root/pipewire-module-xrdp && ./bootstrap && ./configure && make && make install" \
  && rm -rf /root/pipewire-module-xrdp
RUN apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.npm

EXPOSE 3389/tcp
STOPSIGNAL SIGTERM
HEALTHCHECK NONE
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]

# End of Dockerfile
