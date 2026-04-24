#!/bin/bash

#
#   Copyright (C) MINZKN.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho <mailto:minzkn@minzkn.com>
#

#set -euo pipefail
set -eo pipefail

#HWPORT_USER_ID=$(id -u)
#HWPORT_GROUP_ID=$(id -g)

# === BEGIN : EDIT FOR YOU ===

#if grep -q '\<fuse\>' "/proc/misc"
#then
#  if [ ! -e "/dev/fuse" ]
#  then
#    /usr/bin/mknod "/dev/fuse" c 10 $(grep '\<fuse\>' "/proc/misc" | cut -f 1 -d' ')
#  fi
#fi
#
#if grep -q '\<kvm\>' "/proc/misc"
#then
#  if [ ! -e "/dev/kvm" ]
#  then
#    /usr/bin/mknod "/dev/kvm" c 10 $(grep '\<kvm\>' "/proc/misc" | cut -f 1 -d' ')
#  fi
#fi

# timezone configuration
if [ -n "${TZ}" ] && [ -f "/usr/share/zoneinfo/${TZ}" ]; then
    ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
    echo "${TZ}" > /etc/timezone
fi

# initial user creation
if [ -n "${INIT_USER}" ]; then
    if ! id "${INIT_USER}" &>/dev/null; then
        if [ -d "/home/${INIT_USER}" ]; then
            useradd \
                -c "${INIT_USER_COMMENT:-Developer}" \
                -d "/home/${INIT_USER}" \
                -g "${INIT_USER_GROUP:-users}" \
                -G "${INIT_USER_GROUPS:-users,adm,sudo}" \
                -s "${INIT_USER_SHELL:-/bin/bash}" \
                -M "${INIT_USER}"
        else
            useradd \
                -c "${INIT_USER_COMMENT:-Developer}" \
                -d "/home/${INIT_USER}" \
                -g "${INIT_USER_GROUP:-users}" \
                -G "${INIT_USER_GROUPS:-users,adm,sudo}" \
                -s "${INIT_USER_SHELL:-/bin/bash}" \
                -m "${INIT_USER}"
        fi
        if [ -n "${INIT_USER_PASSWORD}" ]; then
            echo "${INIT_USER}:${INIT_USER_PASSWORD}" | chpasswd
        fi
    fi
fi

[ -f "/var/run/crond.pid" ] && rm -f "/var/run/crond.pid"
/usr/sbin/service cron start
/usr/sbin/service dbus start

if [[ "${CLAMAV}" = "yes" ]]
then
/usr/sbin/service clamav-freshclam start
fi

if [[ "${XRDP_DESKTOP}" = "yes" ]]
then
[ -f "/var/run/xrdp/xrdp-sesman.pid" ] && rm -f "/var/run/xrdp/xrdp-sesman.pid"
[ -f "/var/run/xrdp/xrdp.pid" ] && rm -f "/var/run/xrdp/xrdp.pid"
/usr/sbin/service xrdp start
fi

if [[ "${SHELLINABOX}" = "yes" ]]
then
/usr/sbin/service shellinabox start
fi

# === END   : EDIT FOR YOU ===

exec "$@"

# End of entrypoint.sh
