#!/usr/bin/env bash

set -e
set -u
set -o pipefail


############################################################
# Functions
############################################################

###
### Copy *.ini files from source to destination with prefix
###
copy_ini_files() {
	local ini_src="${1}"
	local ini_dst="${2}"
	local debug="${3}"

	if [ ! -d "${ini_src}" ]; then
		run "mkdir -p ${ini_src}" "${debug}"
	fi
	ini_files="$( find "${ini_src}" -type f -iname '*.ini' )"

	# loop over them line by line
	IFS='
	'
	for ini_f in ${ini_files}; do
		ini_name="$( basename "${ini_f}" )"
		log "info" "PHP.ini: ${ini_name} -> ${ini_dst}/yyy-devilbox-user-runtime-${ini_name}" "${debug}"
		run "cp ${ini_f} ${ini_dst}/yyy-devilbox-user-runtime-${ini_name}" "${debug}"
	done
	run "find ${ini_dst} -type f -iname '*.ini' -exec chmod 0644 \"{}\" \;" "${debug}"
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
