#!/usr/bin/env bash

set -e
set -u
set -o pipefail


############################################################
# Functions
############################################################

###
### Disable PHP Modules
###
disable_modules() {
	local mod_varname="${1}"
	local debug="${2}"
	local mod_path="/usr/local/etc/php/conf.d"

	if ! env_set "${mod_varname}"; then
		log "info" "\$${mod_varname} not set. Not disabling any PHP modules." "${debug}"
	else
		mods="$( env_get "${mod_varname}" )"

		if [ -z "${mods}" ]; then
			log "warn" "\$${mod_varname} set, but empty. Not disabling any PHP modules." "${debug}"
		else
			log "info" "Disabling the following PHP modules: ${mods}" "${debug}"
		fi

		while read -r mod; do
		#for mod in ${mods//,/ }; do
			mod="$( echo "${mod}" | xargs )" # trim

			# Find all config files that enable that module
			files="$( grep -Er "^(zend_)?extension.*(=|/)${mod}\.so" "${mod_path}" || true )"

			if [ -n "${files}" ]; then
				while read -r f; do
					# Get filename
					f="$( echo "${f}" | awk -F':' '{ print $1 }' )"
					# Remove file
					run "rm ${f}" "${debug}"
				done <<< "${files}"
			fi
		done <<< "$( echo "${mods}" | tr ',' '\n' )"
		#done
	fi
}
