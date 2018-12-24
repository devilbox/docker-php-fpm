#!/usr/bin/env bash

set -e
set -u
set -o pipefail


############################################################
# Functions
############################################################

###
### Copy PHP-FPM *.conf files from source to destination with prefix
###
copy_fpm_files() {
	local fpm_src="${1}"
	local fpm_dst="${2}"
	local debug="${3}"

	if [ ! -d "${fpm_src}" ]; then
		run "mkdir -p ${fpm_src}" "${debug}"
	fi
	fpm_files="$( find "${fpm_src}" -type f -iname '*.conf' )"

	# loop over them line by line
	IFS='
	'
	for fpm_f in ${fpm_files}; do
		fpm_name="$( basename "${fpm_f}" )"
		log "info" "PHP-FPM.conf: ${fpm_name} -> ${fpm_dst}/yyy-devilbox-user-runtime-${fpm_name}" "${debug}"
		run "cp ${fpm_f} ${fpm_dst}/yyy-devilbox-user-runtime-${fpm_name}" "${debug}"
	done
	run "find ${fpm_dst} -type f -iname '*.conf' -exec chmod 0644 \"{}\" \;" "${debug}"
}

###
### Copy php-fpm.conf for PHP 5.2
### Note: PHP 5.2 does not allow includes and comes in XML format,
###       we must therefore copy the file to its main file /usr/local/etc/php-fpm.conf
###
copy_fpm_5_2_conf_file() {
	local fpm_src="${1}"
	local fpm_dst="/usr/local/etc/php-fpm.conf"
	local debug="${2}"

	if [ -f "${fpm_src}" ]; then
		log "info" "PHP-FPM.conf (PHP 5.2): php-fpm.xml -> ${fpm_dst}" "${debug}"
		run "cp ${fpm_src} ${fpm_dst}" "${debug}"
	fi
}


############################################################
# Sanity Checks
############################################################

if ! command -v find >/dev/null 2>&1; then
	echo "find not found, but required."
	exit 1
fi
if ! command -v basename >/dev/null 2>&1; then
	echo "basename not found, but required."
	exit 1
fi
