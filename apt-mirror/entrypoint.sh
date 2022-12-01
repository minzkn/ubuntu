#!/bin/bash

#
#   Copyright (C) MINZKN.COM
#   All rights reserved.
#
#   Maintainers
#     JaeHyuk Cho <mailto:minzkn@minzkn.com>
#

set -euo pipefail

# === BEGIN : EDIT FOR YOU ===

service cron start \
	&& crontab /etc/cron.d/* \
	&& exec /usr/bin/apt-mirror

# === END   : EDIT FOR YOU ===

#exec "$@"
exit 1

# End of entrypoint.sh
