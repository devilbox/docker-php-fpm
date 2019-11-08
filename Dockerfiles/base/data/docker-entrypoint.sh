#!/usr/bin/env bash

set -e
set -u
set -o pipefail


###
### Globals
###

# The following global variables are available by our Dockerfile itself:
#   MY_USER
#   MY_GROUP
#   MY_UID
#   MY_GID

# Path to scripts to source
CONFIG_DIR="/docker-entrypoint.d"


###
### Source libs
###
init="$( find "${CONFIG_DIR}" -name '*.sh' -type f | sort -u )"
for f in ${init}; do
	# shellcheck disable=SC1090
	. "${f}"
done



#############################################################
## Entry Point
#############################################################

###
### Set Debug level
###
DEBUG_LEVEL="$( env_get "DEBUG_ENTRYPOINT" "0" )"
log "info" "Debug level: ${DEBUG_LEVEL}" "${DEBUG_LEVEL}"


###
### Change uid/gid
###
set_uid "NEW_UID" "${MY_USER}"  "/home/${MY_USER}" "${DEBUG_LEVEL}"
set_gid "NEW_GID" "${MY_GROUP}" "/home/${MY_USER}" "${DEBUG_LEVEL}"


###
### Startup
###
log "info" "Starting $( php-fpm -v 2>&1 | head -1 )" "${DEBUG_LEVEL}"
exec "${@}"
