#!/bin/sh

set -e
set -u


############################################################
# Functions
############################################################

###
### Debug level
###
get_debug_level() {
	if ! env_set "${1}"; then
		# Return default specified value
		echo "${2}"
	else
		# Return env value
		env_get "${1}"
	fi
}
