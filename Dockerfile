#
#   Copyright (C) 2015 HWPORT.COM
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
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LC_ALL C
ENV LANG en_US.UTF-8
ENV EDITER vim

# ----

# SOME... NEED?

# ----

EXPOSE 22
#VOLUME ["/test-share1", "/test-share2", "/test-share3"]
WORKDIR /
#CMD ["/sbin/init"]
CMD ["/usr/sbin/sshd", "-D"]

# ----

# End of Dockerfile
