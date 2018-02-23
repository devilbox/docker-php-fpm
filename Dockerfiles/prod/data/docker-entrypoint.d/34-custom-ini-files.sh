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
### Copy *.ini files from source to destination with prefix
###
copy_ini_files() {
	ini_src="${1}"
	ini_dst="${2}"

	if [ ! -d "${ini_src}" ]; then
		run "mkdir -p ${ini_src}"
	fi
	ini_files="$( find "${ini_src}" -type f -iname '*.ini' )"

	# loop over them line by line
	IFS='
	'
	for ini_f in ${ini_files}; do
		ini_name="$( basename "${ini_f}" )"
		log "info" "PHP.ini: ${ini_name} -> ${ini_dst}/zzz-devilbox-${ini_name}"
		run "cp ${ini_f} ${ini_dst}/devilbox-${ini_name}"
	done
	run "find ${ini_dst} -type f -iname '*.ini' -exec chmod 0644 \"{}\" \;"

	unset -v ini_src
	unset -v ini_dst
	unset -v ini_files
	unset -v ini_f
	unset -v ini_name
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
