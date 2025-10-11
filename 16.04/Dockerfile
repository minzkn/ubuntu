#
#   Copyright (C) 2022 HWPORT.COM
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

FROM ubuntu:16.04

ARG HWPORT_NAMESPACE=hwport
ARG HWPORT_IMAGE_NAME=ubuntu
ARG HWPORT_IMAGE_TAG=16.04
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
RUN apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get update -y --list-cleanup \
  && apt-get --fix-broken install -y \
  && DEBCONF_NOWARNINGS="yes" apt-get upgrade -y
RUN apt-get install -y tzdata ca-certificates openssl ssl-cert locales \
  && locale-gen en_US.UTF-8 \
  && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US \
  && apt-get install -y ssh sed \
  && mkdir -p /run/sshd \
  && sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd \
  && cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.org \
  && echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config \
  && echo "GatewayPorts yes" >> /etc/ssh/sshd_config \
  && echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config \
  && echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config
RUN apt-get install -y \
  sudo \
  build-essential \
  binutils \
  gcc \
  g++ \
  libc-dev \
  gdb \
  perl \
  make \
  pkg-config \
  m4 autoconf automake autopoint libtool \
  cmake \
  bison \
  flex \
  gawk \
  grep \
  gettext \
  patch \
  linux-headers-generic \
  clang llvm \
  libelf-dev \
  libpcap-dev \
  dwarves \
  linux-tools-common \
  linux-tools-generic \
  gperf \
  vim \
  net-tools \
  ccache \
  distcc \
  git subversion \
  wget curl \
  screen \
  genromfs \
  rsync \
  texinfo \
  libncurses-dev ncurses-term \
  openssl \
  tar gzip bzip2 xz-utils unzip zlib1g-dev \
  man-db \
  cscope \
  exuberant-ctags \
  ftp \
  xmlto \
  libboost-dev \
  python3-dev \
  libssl-dev libcurl4-openssl-dev \
  libssh-dev \
  iproute2 \
  whois \
  dnsutils \
  inetutils-ping
RUN apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22/tcp
STOPSIGNAL SIGTERM
HEALTHCHECK NONE
CMD ["/usr/sbin/sshd", "-D"]

# End of Dockerfile
