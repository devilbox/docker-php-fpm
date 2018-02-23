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
### Setup Postfix for catch-all
###
set_postfix() {
	postfix_env_varname="${1}"

	if ! env_set "${postfix_env_varname}"; then
		log "info" "\$${postfix_env_varname} not set."
		log "info" "Disabling sending of emails"
	else
		postfix_env_value="$( env_get "${postfix_env_varname}" )"
		if [ "${postfix_env_value}" = "1" ]; then
			log "info" "Enabling sending of emails"

			# Add Mail file if it does not exist
			if [ ! -f "/var/mail/${MY_USER}" ]; then
				run "touch /var/mail/${MY_USER}"
			fi

			# Fix mail user permissions after mount
			run "chmod 0644 /var/mail/${MY_USER}"
			run "chown ${MY_USER}:${MY_GROUP} /var/mail"
			run "chown ${MY_USER}:${MY_GROUP} /var/mail/${MY_USER}"

			# Postfix configuration
			run "postconf -e 'inet_protocols=ipv4'"
			run "postconf -e 'virtual_alias_maps=pcre:/etc/postfix/virtual'"
			run "echo '/.*@.*/ ${MY_USER}' >> /etc/postfix/virtual"

			run "newaliases"

		elif [ "${postfix_env_value}" = "0" ]; then
			log "info" "Disabling sending of emails."

		else
			log "err" "Invalid value for \$${postfix_env_varname}"
			log "err" "Only 1 (for on) or 0 (for off) are allowed"
			exit 1
		fi
	fi

	unset -v postfix_env_varname
	unset -v postfix_env_value
}


############################################################
# Sanity Checks
############################################################

if ! command -v postconf >/dev/null 2>&1; then
	echo "postconf not found, but required."
	exit 1
fi
