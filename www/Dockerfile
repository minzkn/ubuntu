#
#   Copyright (C) 2020 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

#FROM ubuntu/apache2:latest
FROM ubuntu/apache2:2.4-20.04_beta
MAINTAINER JaeHyuk Cho <minzkn@minzkn.com>

LABEL description="HWPORT www (Ubuntu/apache2 BASE)"
LABEL name="hwport/ubuntu:www"
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
COPY ["entrypoint.sh", "/entrypoint.sh"]
RUN chown root:root /entrypoint.sh && \
    chmod u=rwx,g=r,o=r /entrypoint.sh
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get update --list-cleanup && \
    LC_ALL=C apt-get upgrade -y
RUN LC_ALL=C apt-get install -y \
        locales \
        ca-certificates \
	ssl-cert && \
    LC_ALL=C locale-gen ko_KR.UTF-8 && \
    update-locale LANG=ko_KR.UTF-8 LANGUAGE=ko_KR:en_US

# add packages install
RUN apt-get install -y \
	git-core \
	apache2 \
	libapache2-mod-security2 \
	php php-bz2 php-zip php-xml php-json php-mbstring php-gd php-imagick \
	imagemagick \
	zip \
	enscript \
	rcs \
	vim \
	ffmpeg

# enable modules
RUN a2enmod security2 ssl rewrite headers proxy proxy_http proxy_wstunnel cgi
RUN a2ensite default-ssl.conf

# cleanup
RUN apt-get autoclean -y && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

EXPOSE 80
EXPOSE 443

#VOLUME ["/test-share1", "/test-share2", "/test-share3"]
#VOLUME ["/sys/fs/cgroup"]
#VOLUME ["/run"]

WORKDIR /

#STOPSIGNAL SIGTERM
STOPSIGNAL SIGWINCH

ENTRYPOINT ["/entrypoint.sh"]

#CMD ["/usr/sbin/sshd", "-D"]
#CMD ["/bin/bash"]
#CMD ["/lib/systemd/systemd"]
#CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
#CMD ["/sbin/init"]
#CMD ["apache2-foreground"]

# ----

# End of Dockerfile
