#!/usr/bin/env bash

set -e
set -u
set -o pipefail


############################################################
# Functions
############################################################

###
### Setup Postfix for catch-all
###
set_postfix() {
	local env_varname="${1}"
	local username="${2}"
	local groupname="${3}"
	local debug="${4}"

	local catch_all=

	if ! env_set "${env_varname}"; then
		log "info" "\$${env_varname} not set." "${debug}"
		log "info" "Postfix will not be started." "${debug}"
	else
		catch_all="$( env_get "${env_varname}" )"
		if [ "${catch_all}" = "1" ]; then
			log "info" "Enabling postfix catch-all" "${debug}"

			# Add Mail dir/file if it does not exist
			if [ ! -d "/var/mail" ]; then
				run "mkdir /var/mail" "${debug}"
			fi
			if [ ! -f "/var/mail/${username}" ]; then
				run "touch /var/mail/${username}" "${debug}"
			fi

			# Fix mail dir/file permissions after mount
			run "chmod 0644 /var/mail/${username}" "${debug}"
			run "chown ${username}:${groupname} /var/mail" "${debug}"
			run "chown ${username}:${groupname} /var/mail/${username}" "${debug}"

			# Postfix configuration
			run "postconf -e 'inet_protocols=ipv4'" "${debug}"
			run "postconf -e 'virtual_alias_maps=pcre:/etc/postfix/virtual'" "${debug}"
			run "echo '/.*@.*/ ${username}' >> /etc/postfix/virtual" "${debug}"

			run "newaliases" "${debug}"

		elif [ "${catch_all}" = "0" ]; then
			log "info" "Disabling postfix catch-all" "${debug}"

		else
			log "err" "Invalid value for \$${env_varname}" "${debug}"
			log "err" "Only 1 (for on) or 0 (for off) are allowed" "${debug}"
			exit 1
		fi
	fi
}


############################################################
# Sanity Checks
############################################################

if ! command -v postconf >/dev/null 2>&1; then
	log "err" "postconf not found, but required." "1"
	exit 1
fi
if ! command -v newaliases >/dev/null 2>&1; then
	log "err" "newaliases not found, but required." "1"
	exit 1
fi
