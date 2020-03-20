#
#   Copyright (C) 2019 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:18.04
MAINTAINER JaeHyuk Cho <minzkn@minzkn.com>

LABEL description="HWPORT moniwiki v1.2.5p1 (Ubuntu 18.04 LTS BASE)"
LABEL name="hwport/ubuntu:moniwiki"
LABEL url="http://www.minzkn.com/"
LABEL vendor="HWPORT"
LABEL version="1.1"

ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=xterm
ARG LC_ALL=C
ARG LANG=en_US.UTF-8

ENV container docker
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LC_ALL C
ENV LANG en_US.UTF-8
ENV EDITER vim

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

# ----

# https://github.com/wkpark/moniwiki/archive/v1.2.5p1.tar.gz
COPY ./v1.2.5p1.tar.gz /tmp/v1.2.5p1.tar.gz
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update --list-cleanup && \
    apt-get remove -y nano vim-tiny cloud-init && \
    apt-get install -y apt-utils debconf-utils locales ca-certificates bash vim curl && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get install -y \
        rcs \
        apache2 \
        php \
        libapache2-mod-php \
        && \
    a2enmod rewrite && \
    tar -xzf /tmp/v1.2.5p1.tar.gz -C /tmp/ && \
    rm -rf /var/www/html/* && \
    mv -f /tmp/moniwiki-1.2.5p1/* /var/www/html/ && \
    chown -R www-data:www-data /var/www/html && \
    cd /var/www/html/ ; /bin/bash /var/www/html/secure.sh && \
    apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

EXPOSE 80
#VOLUME ["/var/www/html/data"]
#VOLUME ["/sys/fs/cgroup"]
#VOLUME ["/run"]
WORKDIR /tmp
#STOPSIGNAL SIGTERM
CMD ["/bin/bash", "-c", "source /etc/apache2/envvars && /usr/sbin/apache2 -D FOREGROUND"]

# ----

# End of Dockerfile
