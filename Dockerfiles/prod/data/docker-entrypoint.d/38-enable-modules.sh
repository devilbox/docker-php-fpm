#!/usr/bin/env bash

set -e
set -u
set -o pipefail


############################################################
# Functions
############################################################

###
### Enable PHP Modules
###
enable_modules() {
	local mod_varname="${1}"
	local debug="${2}"
	local cfg_path="/usr/local/etc/php/conf.d"
	local mod_path=
	mod_path="$( php -i | grep ^extension_dir | awk -F '=>' '{print $2}' | xargs )"


	if ! env_set "${mod_varname}"; then
		log "info" "\$${mod_varname} not set. Not enabling any PHP modules." "${debug}"
	else
		mods="$( env_get "${mod_varname}" )"

		if [ -z "${mods}" ]; then
			log "info" "\$${mod_varname} set, but empty. Not enabling any PHP modules." "${debug}"
			return 0
		fi

		log "info" "Enabling the following PHP modules: ${mods}" "${debug}"

		while read -r mod; do
			mod="$( echo "${mod}" | xargs )" # trim

			# Does the module exist?
			if [ -f "${mod_path}/${mod}.so" ]; then
				# Exceptions to load speficially
				if [ "${mod}" = "ioncube" ]; then
					run "echo 'zend_extension=${mod_path}/ioncube.so' > '${cfg_path}/docker-ext-php-ext-ioncube.ini'" "${debug}"
				# Generic Load
				else
					run "docker-php-ext-enable ${mod} || true" "${debug}"
				fi
			else
				log "warn" "Enabling PHP Module: '${mod}' does not exist" "${debug}"
			fi
		done <<< "$( echo "${mods}" | tr ',' '\n' )"
	fi
}
