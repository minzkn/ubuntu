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

# timezone configuration
if [ -n "${TZ}" ] && [ -f "/usr/share/zoneinfo/${TZ}" ]; then
    ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
    echo "${TZ}" > /etc/timezone
fi

# initial user creation
if [ -n "${INIT_USER}" ]; then
    if ! id "${INIT_USER}" &>/dev/null; then
        useradd \
            -c "${INIT_USER_COMMENT:-Developer}" \
            -d "/home/${INIT_USER}" \
            -g "${INIT_USER_GROUP:-users}" \
            -G "${INIT_USER_GROUPS:-users,adm,sudo,audio,input}" \
            -s "${INIT_USER_SHELL:-/bin/bash}" \
            -m "${INIT_USER}"
        if [ -n "${INIT_USER_PASSWORD}" ]; then
            echo "${INIT_USER}:${INIT_USER_PASSWORD}" | chpasswd
        fi
    fi
fi

[ -f "/var/run/crond.pid" ] && rm -f "/var/run/crond.pid"
/usr/sbin/service cron start

# === END   : EDIT FOR YOU ===

exec "$@"

# End of entrypoint.sh
