#!/bin/sh
#
# Available global variables:
#   + MY_USER
#   + MY_GROUP
#   + DEBUG_LEVEL


set -e
set -u


############################################################
# Functions
############################################################

###
### Change Timezone
###
set_timezone() {
	tz_env_varname="${1}"
	tz_php_ini="${2}"

	if ! env_set "${tz_env_varname}"; then
		log "info" "\$${tz_env_varname} not set."
		log "info" "Setting PHP: timezone=UTC"
		run "sed -i'' 's|^[[:space:]]*;*[[:space:]]*date\.timezone[[:space:]]*=.*$|date.timezone = UTF|g' ${tz_php_ini}"
	else
		tz_timezone="$( env_get "${tz_env_varname}" )"
		if [ -f "/usr/share/zoneinfo/${tz_timezone}" ]; then
			# Unix Time
			log "info" "Setting container timezone to: ${tz_timezone}"
			run "rm /etc/localtime"
			run "ln -s /usr/share/zoneinfo/${tz_timezone} /etc/localtime"

			# PHP Time
			log "info" "Setting PHP: timezone=${tz_timezone}"
			run "sed -i'' 's|^[[:space:]]*;*[[:space:]]*date\.timezone[[:space:]]*=.*$|date.timezone = ${tz_timezone}|g' ${tz_php_ini}"
		else
			log "err" "Invalid timezone for \$${tz_env_varname}."
			log "err" "\$TIMEZONE: '${tz_timezone}' does not exist."
			exit 1
		fi
	fi
	log "info" "Docker date set to: $(date)"

	unset -v tz_env_varname
	unset -v tz_php_ini
	unset -v tz_timezone
}


############################################################
# Sanity Checks
############################################################

if ! command -v sed >/dev/null 2>&1; then
	echo "sed not found, but required."
	exit 1
fi
