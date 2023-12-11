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

/usr/sbin/service cron start

[ -f "/var/run/xrdp/xrdp-sesman.pid" ] && rm -f "/var/run/xrdp/xrdp-sesman.pid"
[ -f "/var/run/xrdp/xrdp.pid" ] && rm -f "/var/run/xrdp/xrdp.pid"

/usr/sbin/service xrdp start

# === END   : EDIT FOR YOU ===

exec "$@"

# End of entrypoint.sh
