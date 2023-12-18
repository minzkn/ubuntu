###
### Copyright (C) HWPORT.COM
### All rights reserved.
### Author: JAEHYUK CHO <mailto:minzkn@minzkn.com>
###

SUBDIRS :=#
SUBDIRS +=latest#

.PHONY: all
all: ;@$(foreach s_sub_directory,$(SUBDIRS),$(MAKE) $(@) --no-print-directory --directory="$(s_sub_directory)";)
.DEFAULT: ;@$(foreach s_sub_directory,$(SUBDIRS),$(MAKE) $(@) --no-print-directory --directory="$(s_sub_directory)";)

# End of makefile
