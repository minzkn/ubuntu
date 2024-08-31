#
#   Copyright (C) 2024 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

# ----

FROM ubuntu:24.04

ARG HWPORT_NAMESPACE=hwport
ARG HWPORT_IMAGE_NAME=ubuntu
ARG HWPORT_IMAGE_TAG=marvell-octeon-sdk-dev
ARG HWPORT_VERSION=12.24
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
RUN apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get update --list-cleanup \
  && DEBCONF_NOWARNINGS="yes" apt-get upgrade -y \
  && DEBCONF_NOWARNINGS="yes" apt-get install -y debconf-utils apt-utils software-properties-common apt-transport-https ca-certificates gnupg2 ubuntu-keyring \
  && echo 'tzdata tzdata/Areas select Asia' | debconf-set-selections \
  && echo 'tzdata tzdata/Zones/Asia select Seoul' | debconf-set-selections \
  && apt-get install -y tzdata ca-certificates openssl ssl-cert locales wget curl \
  && locale-gen en_US.UTF-8 \
  && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US \
  && apt-get install -y \
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
  cpio \
  python3 \
  unzip \
  rsync \
  bc \
  wget \
  texinfo \
  automake \
  libtool \
  pkg-config \
  flex \
  bison \
  uuid-dev \
  lib32stdc++6 \
  lib32z1 \
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
  libnl-3-dev \
  python3-sphinx \
  python3-sphinx-rtd-theme \
  meson \
  ninja-build \
  doxygen \
  && mkdir -p /run/sshd \
  && sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd \
  && cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.org \
  && echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config \
  && echo "GatewayPorts yes" >> /etc/ssh/sshd_config \
  && echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config \
  && echo "ClientAliveCountMax 3" >> /etc/ssh/sshd_config \
  && apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22/tcp
STOPSIGNAL SIGTERM
HEALTHCHECK NONE
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]

# End of Dockerfile
