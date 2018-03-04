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
	local php_ini_dir="${4}"
	local debug="${5}"

	local php_ini_file="${php_ini_dir}/devilbox-runtime-sendmail.ini"
	local catch_all=

	if ! env_set "${env_varname}"; then
		log "info" "\$${env_varname} not set." "${debug}"
		log "info" "Postfix will not be started." "${debug}"
		echo "" > "${php_ini_file}"
	else
		catch_all="$( env_get "${env_varname}" )"
		if [ "${catch_all}" = "1" ]; then
			log "info" "\$${env_varname} set to 1. Enabling postfix catch-all" "${debug}"

			# Configure PHP
			{
				echo "[mail function]";
				echo "sendmail_path = $( which sendmail ) -t -i";
				echo ";mail.force_extra_parameters =";
				echo "mail.add_x_header = On";
				echo "mail.log = /var/log/php/mail.log";
			} > "${php_ini_file}"

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
			log "info" "\$${env_varname} set to 0. Disabling postfix catch-all" "${debug}"

		else
			log "err" "Invalid value for \$${env_varname}. Can only be 0 or 1. Prodived: ${catch_all}" "${debug}"
			exit 1
		fi
	fi
}


############################################################
# Sanity Checks
############################################################

if ! command -v sendmail >/dev/null 2>&1; then
	log "err" "sendmail not found, but required." "1"
	exit 1
fi
if ! command -v postconf >/dev/null 2>&1; then
	log "err" "postconf not found, but required." "1"
	exit 1
fi
if ! command -v newaliases >/dev/null 2>&1; then
	log "err" "newaliases not found, but required." "1"
	exit 1
fi
