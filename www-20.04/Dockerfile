#
#   Copyright (C) 2022 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:20.04

ARG HWPORT_NAMESPACE=hwport
ARG HWPORT_IMAGE_NAME=ubuntu
ARG HWPORT_IMAGE_TAG=www-20.04
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
COPY --chown=root:root ["./apache2-foreground", "/usr/bin/apache2-foreground"]
RUN apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* \
  && apt-get update --list-cleanup \
  && DEBCONF_NOWARNINGS="yes" apt-get upgrade -y \
  && DEBCONF_NOWARNINGS="yes" apt-get install -y debconf-utils apt-utils software-properties-common \
  && apt-get install -y ca-certificates openssl ssl-cert locales \
  && locale-gen en_US.UTF-8 \
  && update-locale LANG=en_US.UTF-8 LANGUAGE=en_US

RUN apt-get install -y \
  apache2 \
  libapache2-mod-security2 \
  php php-bz2 php-zip php-xml php-json php-mbstring php-gd php-imagick \
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
  && a2enmod security2 ssl rewrite headers proxy proxy_http proxy_wstunnel cgi \
  && a2ensite default-ssl.conf

RUN apt-get autoclean -y \
  && apt-get clean -y \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
EXPOSE 443
#STOPSIGNAL SIGTERM
STOPSIGNAL SIGWINCH
HEALTHCHECK NONE
CMD ["/usr/bin/apache2-foreground"]

# End of Dockerfile
