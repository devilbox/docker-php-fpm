#!/usr/bin/env bash

set -e
set -u
set -o pipefail


############################################################
# Functions
############################################################

###
### Execute custom uesr-supplied scripts
###
execute_custom_scripts() {
	local script_dir="${1}"
	local debug="${2}"

	if [ ! -d "${script_dir}" ]; then
		run "mkdir -p ${script_dir}" "${debug}"
	fi
	script_files="$( find -L "${script_dir}" -type f -iname '*.sh' | sort -n )"

	# loop over them line by line
	IFS='
	'
	for script_f in ${script_files}; do
		script_name="$( basename "${script_f}" )"
		log "info" "Executing custom startup script: ${script_name}" "${debug}"
		if ! bash "${script_f}"; then
			log "err" "Failed to execute script" "${debug}"
			exit 1
		fi
	done
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
