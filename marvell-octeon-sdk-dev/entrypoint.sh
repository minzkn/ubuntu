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

[ -f "/var/run/crond.pid" ] && rm -f "/var/run/crond.pid"
/usr/sbin/service cron start

# === END   : EDIT FOR YOU ===

exec "$@"

# End of entrypoint.sh
