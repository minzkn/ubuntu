#
#   Copyright (C) 2022 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

#FROM ubuntu/apache2:latest
FROM ubuntu/apache2:2.4-22.04_beta
MAINTAINER JaeHyuk Cho <minzkn@minzkn.com>

LABEL description="HWPORT www (Ubuntu/apache2 BASE)"
LABEL name="hwport/ubuntu:www-latest"
LABEL url="http://www.minzkn.com/"
LABEL vendor="HWPORT"
LABEL version="1.1"

# environment for build
ARG DEBIAN_FRONTEND=noninteractive
ARG TZ=Asia/Seoul
ARG TERM=xterm
ARG LC_ALL=ko_KR.UTF-8
ARG LANG=ko_KR.UTF-8
ARG LANGUAGE=ko_KR:en_US
ARG DEBCONF_NOWARNINGS=yes

# environment for run
ENV container docker
ENV TZ Asia/Seoul
#ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LC_ALL ko_KR.UTF-8
ENV LANG ko_KR.UTF-8
ENV LANGUAGE ko_KR:en_US
ENV EDITER vim

# ----

# pre setup
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y --purge && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update --list-cleanup && \
    LC_ALL=C apt-get upgrade -y
RUN LC_ALL=C apt-get install -y locales && \
    LC_ALL=C locale-gen ko_KR.UTF-8 && \
    update-locale LANG=ko_KR.UTF-8 LANGUAGE=ko_KR:en_US

# add packages install
RUN apt-get install -y \
        ca-certificates \
	ssl-cert \
	apache2 \
	libapache2-mod-security2 \
	php php-bz2 php-zip php-xml php-json php-mbstring php-gd php-imagick \
	imagemagick \
	zip \
	enscript \
	rcs \
	vim \
	git-core \
	ffmpeg

# enable modules
RUN a2enmod security2 ssl rewrite headers proxy proxy_http proxy_wstunnel cgi
RUN a2ensite default-ssl.conf

# cleanup
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y --purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

EXPOSE 80
EXPOSE 443

#VOLUME ["/sys/fs/cgroup"]
#VOLUME ["/run"]

WORKDIR /

#STOPSIGNAL SIGTERM
STOPSIGNAL SIGWINCH

CMD ["/usr/bin/apache2-foreground"]

# ----

# End of Dockerfile
