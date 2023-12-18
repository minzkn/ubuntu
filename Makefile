###
### Copyright (C) MINZKN.COM
### All rights reserved.
### Author: JAEHYUK CHO <mailto:minzkn@minzkn.com>
###

SUBDIRS :=#
SUBDIRS +=12.04#
SUBDIRS +=smp86xx#
SUBDIRS +=14.04#
SUBDIRS +=16.04#
SUBDIRS +=18.04#
SUBDIRS +=20.04#
SUBDIRS +=22.04#
#SUBDIRS +=22.04-systemd#
SUBDIRS +=latest#
SUBDIRS +=xrdp#
SUBDIRS +=cron#
SUBDIRS +=strongswan#
SUBDIRS +=strongswan-latest#
SUBDIRS +=www#
SUBDIRS +=www-20.04#
SUBDIRS +=www-22.04#
SUBDIRS +=www-latest#

.PHONY: all clean buildx

all clean buildx:
	@$(foreach s_sub_directory,$(SUBDIRS),$(MAKE) "$(@)" --no-print-directory --directory="$(s_sub_directory)";)

.DEFAULT:
	@$(foreach s_sub_directory,$(SUBDIRS),$(MAKE) "$(@)" --no-print-directory --directory="$(s_sub_directory)";)

# End of Makefile
