#!/bin/bash

#
#   Copyright (C) MINZKN.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho <mailto:minzkn@minzkn.com>
#

set -euo pipefail

#HWPORT_USER_ID=$(id -u)
#HWPORT_GROUP_ID=$(id -g)

# === BEGIN : EDIT FOR YOU ===

#/usr/sbin/sshd -D
exec apache2-foreground

# === END   : EDIT FOR YOU ===

exec "$@"

# End of entrypoint.sh
