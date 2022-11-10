#
#   Copyright (C) 2019 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM ubuntu:20.04
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
#ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LC_ALL C
ENV LANG en_US.UTF-8
ENV EDITER vim

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

# ----

# pre setup
COPY ["entrypoint.sh", "/entrypoint.sh"]
RUN apt autoclean -y && \
    apt clean && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* && \
    apt update --list-cleanup && \
    apt install -y \
        apt-utils \
        debconf-utils \
        locales \
        systemd \
        ssh \
        ca-certificates && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    find /etc/systemd/system \
        /lib/systemd/system \
        -path '*.wants/*' \
        -not -name '*journald*' \
        -not -name '*systemd-tmpfiles*' \
        -not -name '*systemd-user-sessions*' \
        -exec rm \{} \; && \
    systemctl set-default multi-user.target && \
    chown root:root /entrypoint.sh && \
    chmod u=rwx,g=r,o=r /entrypoint.sh

# sshd setup
RUN sed -ri 's/^session\s+required\s+pam_loginuid.so$/session optional pam_loginuid.so/' /etc/pam.d/sshd && \
    mkdir /run/sshd && \
    cp -f /etc/ssh/sshd_config /etc/ssh/sshd_config.org

# https://github.com/wkpark/moniwiki/archive/v1.2.5p1.tar.gz
COPY ["v1.2.5p1.tar.gz", "/tmp/v1.2.5p1.tar.gz"]
RUN apt-get install -y \
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
    cd /var/www/html/ ; /bin/bash /var/www/html/secure.sh

# cleanup
RUN apt autoclean -y && \
    apt clean && \
    apt autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ----

EXPOSE 22 80 8080

#VOLUME ["/test-share1", "/test-share2", "/test-share3"]
#VOLUME ["/sys/fs/cgroup"]
#VOLUME ["/run"]
#VOLUME ["/var/www/html/data"]
#VOLUME ["/sys/fs/cgroup"]
#VOLUME ["/run"]

#WORKDIR /
WORKDIR /tmp

#STOPSIGNAL SIGTERM

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/bin/bash", "-c", "source /etc/apache2/envvars && /usr/sbin/apache2 -D FOREGROUND"]

#CMD ["/usr/sbin/sshd", "-D"]
#CMD ["/bin/bash"]
#CMD ["/lib/systemd/systemd"]
#CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
#CMD ["/sbin/init"]

# ----

# End of Dockerfile
