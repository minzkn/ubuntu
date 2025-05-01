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

FROM ubuntu:22.04

ARG HWPORT_NAMESPACE=hwport
ARG HWPORT_IMAGE_NAME=ubuntu
ARG HWPORT_IMAGE_TAG=22.04
ARG HWPORT_VERSION=1.1
ARG HWPORT_URL=https://www.minzkn.com/
ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=xterm
ARG LC_ALL=C
ARG LANG=en_US.UTF-8
ARG EDITOR=vim

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
RUN apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get update --list-cleanup \
  && apt-get --fix-broken install -y \
  && DEBCONF_NOWARNINGS="yes" apt-get upgrade -y \
  && yes | unminimize \
  && apt-get install -y \
  tzdata debconf-utils locales \
  ca-certificates apt-transport-https gnupg2 ubuntu-keyring \
  sudo \
  ssh \
  sed \
  bash \
  file \
  time \
  aria2 \
  minicom \
  build-essential \
  binutils \
  gcc \
  g++ \
  libc-dev \
  musl-dev \
  gdb \
  perl \
  make \
  pkg-config \
  mtools m4 autoconf autotools-dev automake autopoint libtool libtool-bin intltool \
  cmake \
  meson \
  ninja-build \
  live-build \
  bison \
  flex \
  gawk \
  grep \
  gettext \
  patch patchelf \
  bc \
  linux-headers-generic \
  clang llvm \
  libreadline-dev \
  libelf-dev \
  libpcap-dev \
  dwarves \
  linux-tools-common \
  linux-tools-generic \
  device-tree-compiler \
  gperf \
  strace \
  vim \
  net-tools bridge-utils \
  ccache \
  git subversion cvs \
  screen \
  genromfs \
  rsync \
  uuid-dev \
  libncurses-dev ncurses-term \
  openssl ssl-cert \
  tar gzip bzip2 xz-utils unzip zlib1g-dev cpio lzip pigz p7zip-full zstd \
  man-db \
  cscope \
  exuberant-ctags \
  shellinabox \
  ftp \
  xmlto \
  help2man \
  libboost-dev \
  python3-dev python-dev-is-python3 python3-pip python3-pycryptodome python3-pyelftools python3-sphinx python3-sphinx-rtd-theme \
  libssl-dev libcurl4-openssl-dev curl wget \
  libssh-dev \
  sshfs \
  iproute2 \
  nmap \
  whois \
  dnsutils \
  inetutils-ping \
  dpkg-dev libpulse-dev \
  libconfig-dev \
  libmbedtls-dev \
  libmnl-dev \
  libnuma-dev \
  libnl-genl-3-dev \
  libnl-3-dev \
  liblzma-dev \
  libarchive-zip-perl \
  libfdt-dev \
  libpci-dev \
  libyaml-dev \
  libgmp-dev \
  cron \
  logrotate \
  kmod \
  parted \
  udev \
  u-boot-tools \
  dosfstools \
  mediainfo \
  exfatprogs \
  expect expect-dev \
  parallel \
  doxygen \
  asciidoc \
  android-sdk-libsparse-utils \
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
  remmina \
  virt-manager \
  librecad \
  gimp \
  ffmpeg \
  vlc \
  iverilog gtkwave \
  && (apt-get install -y libreoffice || true) \
  && echo 'tzdata tzdata/Areas select Asia' | debconf-set-selections \
  && echo 'tzdata tzdata/Zones/Asia select Seoul' | debconf-set-selections \
  && locale-gen en_US.UTF-8 \
  && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US \
  && mkdir -p /run/sshd \
  && sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd \
  && cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.org \
  && echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config \
  && echo "GatewayPorts yes" >> /etc/ssh/sshd_config \
  && echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config \
  && echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config \
  && sed -i \
    -e 's,^test -x /etc/X11/Xsession \&\& exec /etc/X11/Xsession$,test -x /usr/bin/xfce4-session \&\& exec /usr/bin/xfce4-session,g' \
    "/etc/xrdp/startwm.sh" \
  && echo "test -x /usr/bin/xfce4-session && exec /usr/bin/xfce4-session" >> /etc/skel/.Xsession

# additional repository setup : fix for 'mozilla-firefox without snap', 'android-studio'
RUN apt-get install -y software-properties-common \
  && add-apt-repository -y ppa:mozillateam/ppa \
  && echo 'Package: *' > /etc/apt/preferences.d/mozilla-firefox \
  && echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozilla-firefox \
  && echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozilla-firefox \
  && echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' > /etc/apt/apt.conf.d/51unattended-upgrades-firefox \
  && add-apt-repository -y ppa:maarten-fonville/android-studio \
  && apt-get update -y \
  && (apt-get install -y firefox || true) \
  && (apt-get install -y android-studio || true)

# pulseaudio module : for Audio XDRP redirection module
RUN git clone https://github.com/neutrinolabs/pulseaudio-module-xrdp.git /root/pulseaudio-module-xrdp \
  && sudo -i sh -c "cd /root/pulseaudio-module-xrdp && (./scripts/install_pulseaudio_sources_apt.sh || (cat /var/tmp/pa-build-root-schroot.log && false)) && ./bootstrap && ./configure PULSE_DIR=/root/pulseaudio.src && make && make install" \
  && rm -rf /root/pulseaudio-module-xrdp /root/pulseaudio.src /var/tmp/pa-build-*.log

RUN apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && (userdel -r ubuntu || true)

EXPOSE 22/tcp 3389/tcp 4200/tcp
STOPSIGNAL SIGTERM
HEALTHCHECK NONE
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]

# End of Dockerfile
