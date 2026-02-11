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
ARG HWPORT_IMAGE_TAG=24.04
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

# Security: Set proper permissions on entrypoint
RUN chmod 755 /entrypoint.sh \
  && echo "# Powered by ${HWPORT_URL}" >> /entrypoint.sh \
  && echo "# BUILDPLATFORM: ${BUILDPLATFORM}" >> /entrypoint.sh \
  && echo "# BUILDOS: ${BUILDOS}" >> /entrypoint.sh \
  && echo "# BUILDARCH: ${BUILDARCH}" >> /entrypoint.sh \
  && echo "# BUILDVARIANT: ${BUILDVARIANT}" >> /entrypoint.sh \
  && echo "# TARGETPLATFORM: ${TARGETPLATFORM}" >> /entrypoint.sh \
  && echo "# TARGETOS: ${TARGETOS}" >> /entrypoint.sh \
  && echo "# TARGETARCH: ${TARGETARCH}" >> /entrypoint.sh \
  && echo "# TARGETVARIANT: ${TARGETVARIANT}" >> /entrypoint.sh \
  && echo "# buildx cores: $(nproc)" >> /entrypoint.sh

# Clean up default ubuntu user and prepare system
RUN (userdel -r ubuntu || true) \
  && apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/*

# Configure apt sources and update system
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    sed -i -e 's/^Types: deb$/Types: deb deb-src/g' /etc/apt/sources.list.d/ubuntu.sources \
  && apt-get update -y --list-cleanup \
  && apt-get --fix-broken install -y \
  && DEBCONF_NOWARNINGS="yes" apt-get upgrade -y
# Unminimize Ubuntu
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    (apt-get install -y unminimize || true) && yes | unminimize

# Install base system packages and configure SSH
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y \
  software-properties-common \
  tzdata debconf-utils locales \
  ca-certificates apt-transport-https gnupg2 ubuntu-keyring \
  openssh-server \
  && locale-gen en_US.UTF-8 \
  && locale-gen ko_KR.UTF-8 \
  && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US

# Configure SSH with security best practices
RUN mkdir -p /run/sshd \
  && sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd \
  && cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.org \
  && echo "# Security and connection settings" >> /etc/ssh/sshd_config \
  && echo "PermitRootLogin no" >> /etc/ssh/sshd_config \
  && echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config \
  && echo "GatewayPorts yes" >> /etc/ssh/sshd_config \
  && echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config \
  && echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config

# Add PPAs for additional software
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    add-apt-repository -y ppa:mozillateam/ppa \
  && add-apt-repository -y ppa:maarten-fonville/android-studio \
  && echo 'Package: *' > /etc/apt/preferences.d/mozilla-firefox \
  && echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozilla-firefox \
  && echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozilla-firefox \
  && echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' > /etc/apt/apt.conf.d/51unattended-upgrades-firefox
# Install core development tools and compilers
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update -y --list-cleanup \
  && apt-get install -y \
  sudo bash sed file time \
  build-essential binutils gcc g++ clang llvm \
  libc-dev musl-dev gdb perl make pkg-config \
  mtools m4 autoconf autotools-dev automake autopoint libtool libtool-bin intltool \
  cmake meson ninja-build bison flex gawk grep gettext patch patchelf bc

# Install kernel development tools
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y \
  linux-headers-generic linux-tools-common linux-tools-generic \
  device-tree-compiler u-boot-tools \
  libelf-dev libpcap-dev dwarves \
  kmod parted udev

# Install version control and collaboration tools
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y \
  git subversion cvs gh \
  ccache distcc \
  cscope exuberant-ctags doxygen asciidoc

# Install network and system utilities
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y \
  ssh aria2 minicom ftp \
  net-tools bridge-utils iproute2 \
  nmap whois dnsutils inetutils-ping \
  openssl ssl-cert curl wget \
  rsync screen vim strace gperf

# Install compression and archiving tools
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y \
  tar gzip bzip2 xz-utils unzip zlib1g-dev \
  cpio lzip pigz p7zip-full zstd

# Install development libraries
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y \
  libreadline-dev libncurses-dev ncurses-term uuid-dev \
  libssl-dev libcurl4-openssl-dev libssh-dev \
  libconfig-dev libmbedtls-dev libmnl-dev libnuma-dev \
  libnl-genl-3-dev libnl-3-dev liblzma-dev \
  libarchive-zip-perl libfdt-dev libpci-dev libyaml-dev libgmp-dev \
  libboost-dev dpkg-dev libpulse-dev

# Install Python development environment
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y \
  python3-dev python-dev-is-python3 python3-pip \
  python3-pycryptodome python3-pyelftools \
  python3-sphinx python3-sphinx-rtd-theme

# Install XFCE4 desktop environment
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y \
  xfce4 xfce4-terminal xfce4-goodies \
  xfce4-clipman-plugin xfce4-cpugraph-plugin \
  xfce4-netload-plugin xfce4-screenshooter \
  xfce4-taskmanager xfce4-xkb-plugin \
  dbus-x11 zenity

# Install X11 and remote desktop components
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y \
  libfontenc1 libxfont2 \
  xfonts-encodings xfonts-utils xfonts-base xfonts-75dpi \
  xorgxrdp xprintidle xrdp shellinabox

# Install Korean language support
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y \
  language-selector-common language-selector-gnome language-pack-ko \
  fonts-noto-cjk-extra fonts-noto-cjk hunspell-ko \
  fonts-nanum fonts-nanum-coding fonts-nanum-extra fonts-naver-d2coding \
  ibus ibus-hangul im-config

# Install desktop applications
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y \
  gvfs-backends smbclient ssh-askpass-gnome \
  flameshot putty remmina virt-manager

# Install multimedia and graphics tools
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y \
  gimp ffmpeg vlc \
  librecad iverilog gtkwave \
  mediainfo dosfstools exfatprogs

# Install system services and utilities
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y \
  cron logrotate sshfs \
  man-db xmlto help2man \
  expect expect-dev parallel \
  genromfs live-build android-sdk-libsparse-utils \
  clamav

# Install Mesa graphics drivers
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y \
  mesa-va-drivers mesa-vdpau-drivers mesa-vulkan-drivers \
  mesa-common-dev mesa-utils \
  $(if [ "${TARGETARCH}" != "riscv64" ]; then echo "mesa-drm-shim"; fi)

# Install architecture-specific packages
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y \
  $(if [ "${TARGETARCH}" = "amd64" -o "${TARGETARCH}" = "arm64" ]; then echo "libreoffice kicad firefox"; fi) \
  $(if [ "${TARGETARCH}" = "amd64" ]; then echo "android-studio"; fi) \
  $(if [ "${TARGETARCH}" = "amd64" ]; then echo "nvidia-cuda-toolkit libnvidia-compute-580-server libnvidia-encode-580-server libnvidia-decode-580-server xserver-xorg-video-nvidia-580-server"; fi)

# Configure XRDP for XFCE4
RUN sed -i \
    -e 's,^test -x /etc/X11/Xsession \&\& exec /etc/X11/Xsession$,test -x /usr/bin/xfce4-session \&\& exec /usr/bin/xfce4-session,g' \
    "/etc/xrdp/startwm.sh" \
  && echo "test -x /usr/bin/xfce4-session && exec /usr/bin/xfce4-session" >> /etc/skel/.Xsession
RUN git clone https://github.com/neutrinolabs/pulseaudio-module-xrdp.git /root/pulseaudio-module-xrdp \
  && sudo -i sh -c "cd /root/pulseaudio-module-xrdp && (./scripts/install_pulseaudio_sources_apt.sh || (cat /var/tmp/pa-build-root-schroot.log && false)) && ./bootstrap && ./configure PULSE_DIR=/root/pulseaudio.src && make && make install" \
  && rm -rf /root/pulseaudio-module-xrdp /root/pulseaudio.src /var/tmp/pa-build-*.log /root/pulseaudio*.xz /root/pulseaudio*.dsc
# Final cleanup and security hardening
RUN apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && find /var/log -type f -exec truncate -s 0 {} \; \
  && rm -f /var/cache/ldconfig/aux-cache \
  && rm -rf /root/.cache

EXPOSE 22/tcp 3389/tcp 4200/tcp
STOPSIGNAL SIGTERM
HEALTHCHECK NONE
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]

# End of Dockerfile
