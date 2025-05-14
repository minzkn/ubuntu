#
#   Copyright (C) 2024 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:24.04

ARG HWPORT_NAMESPACE=hwport
ARG HWPORT_IMAGE_NAME=ubuntu
ARG HWPORT_IMAGE_TAG=www-24.04
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
COPY --chown=root:root ["./apache2-foreground", "/usr/bin/apache2-foreground"]
RUN echo "# Powered by ${HWPORT_URL}" >> /usr/bin/apache2-foreground \
  && echo "# BUILDPLATFORM: ${BUILDPLATFORM}" >> /usr/bin/apache2-foreground \
  && echo "# BUILDOS: ${BUILDOS}" >> /usr/bin/apache2-foreground \
  && echo "# BUILDARCH: ${BUILDARCH}" >> /usr/bin/apache2-foreground \
  && echo "# BUILDVARIANT: ${BUILDVARIANT}" >> /usr/bin/apache2-foreground \
  && echo "# TARGETPLATFORM: ${TARGETPLATFORM}" >> /usr/bin/apache2-foreground \
  && echo "# TARGETOS: ${TARGETOS}" >> /usr/bin/apache2-foreground \
  && echo "# TARGETARCH: ${TARGETARCH}" >> /usr/bin/apache2-foreground \
  && echo "# TARGETVARIANT: ${TARGETVARIANT}" >> /usr/bin/apache2-foreground \
  && echo "# buildx cores: $(nproc)" >> /usr/bin/apache2-foreground \
  && apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get update -y --list-cleanup \
  && apt-get --fix-broken install -y \
  && DEBCONF_NOWARNINGS="yes" apt-get upgrade -y \
  && apt-get install -y \
  tzdata locales ca-certificates openssl ssl-cert \
  && locale-gen en_US.UTF-8 \
  && locale-gen ko_KR.UTF-8 \
  && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US \
  && apt-get install -y \
  apache2 \
  libapache2-mod-security2 \
  libapache2-mod-fcgid \
  php php-fpm php-intl php-bz2 php-zip php-xml php-json php-mbstring php-gd php-imagick php-sqlite3 php-mysql \
  cron \
  logrotate \
  imagemagick \
  zip \
  p7zip \
  enscript \
  rcs \
  vim \
  git-core \
  iputils-ping \
  ffmpeg \
  libsubtitles-perl \
  && a2enmod security2 proxy_fcgi setenvif deflate ssl http2 rewrite headers proxy proxy_http proxy_wstunnel cgi \
  && a2ensite default-ssl.conf \
  && apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
EXPOSE 443
STOPSIGNAL SIGTERM
HEALTHCHECK NONE
CMD ["/usr/bin/apache2-foreground"]

# End of Dockerfile
