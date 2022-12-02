#
#   Copyright (C) 2022 HWPORT.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho ( <mailto:minzkn@minzkn.com> )
#

FROM hwport/ubuntu:12.04
MAINTAINER JaeHyuk Cho <minzkn@minzkn.com>

LABEL description="HWPORT sigmadesigns SMP86xx dev environment (Ubuntu 12.04 LTS base)"
LABEL name="hwport/ubuntu:smp86xx"
LABEL url="http://www.minzkn.com/"
LABEL vendor="HWPORT"
LABEL version="1.0"

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

# ----

ADD https://sourcery.mentor.com/public/gnu_toolchain/mips-linux-gnu/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2 /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2
#COPY ["mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2", "/tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2"]
RUN tar -xjf /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2 -C /opt/ && \
    rm -f /tmp/mips-4.3-51-mips-linux-gnu-i686-pc-linux-gnu.tar.bz2

# ----

EXPOSE 22

#VOLUME ["/sys/fs/cgroup"]
#VOLUME ["/run"]

WORKDIR /

#STOPSIGNAL SIGTERM

#HEALTHCHECK --interval=1m --timeout=3s --retries=3 CMD curl -f http://localhost || exit 1

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D"]
#CMD ["/bin/bash"]
#CMD ["/bin/bash", "-c", "exec /sbin/init --log-target=journal 3>&1"]
#CMD ["/sbin/init"]

# ----

# End of Dockerfile
