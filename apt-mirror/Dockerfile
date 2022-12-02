#
#   Copyright (C) 2022 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:22.04
MAINTAINER JaeHyuk Cho <minzkn@minzkn.com>

LABEL description="HWPORT Ubuntu apt-mirror"
LABEL name="hwport/ubuntu:apt-mirror"
LABEL url="http://www.minzkn.com/"
LABEL vendor="HWPORT"
LABEL version="1.0"

# environment for build
ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=xterm
ARG LC_ALL=C
ARG LANG=en_US.UTF-8

# environment for run
ENV container docker
#ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LC_ALL C
ENV LANG en_US.UTF-8
ENV EDITER vim

# ----

# pre setup
COPY ["entrypoint.sh", "/entrypoint.sh"]
RUN chown root:root /entrypoint.sh && \
    chmod u=rwx,g=r,o=r /entrypoint.sh
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y --purge && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update --list-cleanup
RUN DEBCONF_NOWARNINGS="yes" apt-get install -y debconf-utils apt-utils
RUN apt-get upgrade -y
RUN LC_ALL=C apt-get install -y locales && \
    LC_ALL=C locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LANGUAGE=en_US
RUN apt-get install -y ca-certificates ssl-cert

# install
RUN apt-get install -y apt-mirror cron
COPY mirror.list /etc/apt/mirror.list
COPY crontab /etc/cron.d

# cleanup
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y --purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

WORKDIR /

#STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]

# ----

# End of Dockerfile
