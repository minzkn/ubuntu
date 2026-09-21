#
#   Copyright (C) 2024 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:22.04

ARG HWPORT_NAMESPACE=hwport
ARG HWPORT_IMAGE_NAME=ubuntu
ARG HWPORT_IMAGE_TAG=marvell-octeon-sdk-dev
ARG HWPORT_VERSION=1.2
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
  DEBIAN_FRONTEND="${DEBIAN_FRONTEND}" \
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
RUN (userdel -r ubuntu || true) \
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
  file \
  sed \
  build-essential \
  binfmt-support \
  binutils \
  git \
  gh \
  gcc-aarch64-linux-gnu \
  g++-aarch64-linux-gnu \
  binutils-aarch64-linux-gnu \
  cpio \
  crossbuild-essential-arm64 \
  python3 \
  u-boot-tools \
  unzip \
  rsync \
  bc \
  wget \
  curl \
  texinfo \
  tmux \
  tree \
  autoconf \
  automake \
  libtool \
  pkg-config \
  fakeroot \
  flex \
  bison \
  uuid-dev \
  $(if [ "${TARGETARCH}" = "amd64" ]; then echo "lib32stdc++6"; fi) \
  $(if [ "${TARGETARCH}" = "amd64" ]; then echo "lib32z1"; fi) \
  acpica-tools \
  device-tree-compiler \
  dosfstools \
  libconfig-dev \
  libmbedtls-dev \
  libnuma-dev \
  liblz4-tool \
  liblzma-dev \
  libarchive-zip-perl \
  python3-pycryptodome \
  python3-pyelftools \
  libfdt-dev \
  libncurses-dev \
  libpci-dev \
  libyaml-dev \
  libssl-dev \
  lintian \
  lzma \
  libnl-genl-3-dev \
  libnl-3-dev libnl-route-3-dev libmnl-dev \
  python3-sphinx \
  python3-sphinx-rtd-theme \
  meson \
  ninja-build \
  doxygen \
  equivs \
  ccache \
  distcc \
  debhelper debootstrap devscripts dh-make dkms libapr1-dev dh-python \
  libconfuse-dev git-review exuberant-ctags cscope \
  gcovr lcov chrpath \
  python3-all python3-setuptools check \
  libffi-dev python3-ply \
  cmake uuid-dev python3-jsonschema python3-packaging python3-yaml \
  python3-venv \
  python3-dev python3-full python3-pip \
  python3-virtualenv \
  python-is-python3 \
  qemu-user \
  qemu-user-static \
  quilt \
  schroot \
  swig \
  libelf-dev libpcap-dev \
  iperf3 \
  nasm \
  openjdk-17-jdk \
  iperf ethtool \
  tshark \
  cron \
  logrotate

# 22.04 ships pip 22.0.2 (no PEP 668 enforcement, no --break-system-packages flag)
RUN pip3 install --no-cache-dir pyyaml-include==1.4.1 pykwalify gpt_image
RUN apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.npm

EXPOSE 22/tcp
STOPSIGNAL SIGTERM
HEALTHCHECK NONE
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]

# End of Dockerfile
