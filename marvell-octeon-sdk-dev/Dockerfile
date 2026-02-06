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
ARG HWPORT_IMAGE_TAG=marvell-octeon-sdk-dev
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
  && apt-get update -y --list-cleanup \
  && apt-get --fix-broken install -y \
  && DEBCONF_NOWARNINGS="yes" apt-get upgrade -y
RUN (apt-get install -y unminimize || true) && yes | unminimize
RUN apt-get install -y \
  software-properties-common \
  tzdata debconf-utils locales \
  ca-certificates apt-transport-https gnupg2 ubuntu-keyring \
  openssh-server \
  && locale-gen en_US.UTF-8 \
  && locale-gen ko_KR.UTF-8 \
  && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US \
  && mkdir -p /run/sshd \
  && sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd \
  && cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.org \
  && echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config \
  && echo "GatewayPorts yes" >> /etc/ssh/sshd_config \
  && echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config \
  && echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config
RUN apt-get install -y \
  openssl ssl-cert \
  sudo \
  bash \
  vim \
  parallel \
  ssh \
  screen \
  fdisk \
  sed \
  build-essential \
  git \
  gh \
  cpio \
  python3 \
  unzip \
  rsync \
  bc \
  wget \
  curl \
  texinfo \
  autoconf \
  automake \
  libtool \
  pkg-config \
  flex \
  bison \
  uuid-dev \
  $(if [ "${TARGETARCH}" = "amd64" ]; then echo "lib32stdc++6"; fi) \
  $(if [ "${TARGETARCH}" = "amd64" ]; then echo "lib32z1"; fi) \
  acpica-tools \
  dosfstools \
  libconfig-dev \
  libmbedtls-dev \
  libnuma-dev \
  liblzma-dev \
  libarchive-zip-perl \
  python3-pycryptodome \
  python3-pyelftools \
  libfdt-dev \
  libncurses-dev \
  libpci-dev \
  libyaml-dev \
  libssl-dev \
  libnl-genl-3-dev \
  libnl-3-dev libnl-route-3-dev libmnl-dev \
  python3-sphinx \
  python3-sphinx-rtd-theme \
  meson \
  ninja-build \
  doxygen \
  ccache \
  distcc \
  debhelper dkms libapr1-dev dh-python \
  libconfuse-dev git-review exuberant-ctags cscope \
  gcovr lcov chrpath \
  python3-all python3-setuptools check \
  libffi-dev python3-ply \
  cmake uuid-dev python3-jsonschema python3-yaml \
  python3-venv \
  python3-dev python3-pip \
  python3-virtualenv \
  libelf-dev libpcap-dev \
  iperf3 \
  nasm \
  iperf ethtool \
  tshark \
  cron \
  logrotate
RUN apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22/tcp
STOPSIGNAL SIGTERM
HEALTHCHECK NONE
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]

# End of Dockerfile
