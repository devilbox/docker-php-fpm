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
### Log to stdout/stderr
###
log() {
	log_lvl="${1}"
	log_msg="${2}"

	log_clr_ok="\033[0;32m"
	log_clr_info="\033[0;34m"
	log_clr_warn="\033[0;33m"
	log_clr_err="\033[0;31m"
	log_clr_rst="\033[0m"

	if [ "${log_lvl}" = "ok" ]; then
		if [ "${DEBUG_LEVEL}" -gt "0" ]; then
			printf "${log_clr_ok}[OK]   %s${log_clr_rst}\n" "${log_msg}"
		fi
	elif [ "${log_lvl}" = "info" ]; then
		if [ "${DEBUG_LEVEL}" -gt "0" ]; then
			printf "${log_clr_info}[INFO] %s${log_clr_rst}\n" "${log_msg}"
		fi
	elif [ "${log_lvl}" = "warn" ]; then
		printf "${log_clr_warn}[WARN] %s${log_clr_rst}\n" "${log_msg}" 1>&2	# stdout -> stderr
	elif [ "${log_lvl}" = "err" ]; then
		printf "${log_clr_err}[ERR]  %s${log_clr_rst}\n" "${log_msg}" 1>&2	# stdout -> stderr
	else
		printf "${log_clr_err}[???]  %s${log_clr_rst}\n" "${log_msg}" 1>&2	# stdout -> stderr
	fi

	unset -v log_lvl
	unset -v log_msg
	unset -v log_clr_ok
	unset -v log_clr_info
	unset -v log_clr_warn
	unset -v log_clr_err
	unset -v log_clr_rst
}


###
### Wrapper for run_run command
###
run() {
	run_cmd="${1}"

	run_clr_red="\033[0;31m"
	run_clr_green="\033[0;32m"
	run_clr_reset="\033[0m"

	if [ "${DEBUG_LEVEL}" -gt "1" ]; then
		printf "${run_clr_red}%s \$ ${run_clr_green}${run_cmd}${run_clr_reset}\n" "$( whoami )"
	fi
	/bin/sh -c "LANG=C LC_ALL=C ${run_cmd}"

	unset -v run_cmd
	unset -v run_clr_red
	unset -v run_clr_green
	unset -v run_clr_reset
}


###
### Is argument an integer?
###
isint() {
	echo "${1}" | grep -Eq '^([0-9]|[1-9][0-9]*)$'
}


###
### Is env variable set?
###
env_set() {
	if set | grep "^${1}=" >/dev/null 2>&1; then
		return 0
	else
		return 1
	fi
}


###
### Get env variable by name
###
env_get() {
	if ! env_set "${1}"; then
		return 1
	fi

	env_get_value="$( set | grep "^${1}=" | awk -F '=' '{for (i=2; i<NF; i++) printf $i "="; print $NF}' )"

	# Remove surrounding quotes
	env_get_value="$( echo "${env_get_value}" | sed "s/^'//g" )"
	env_get_value="$( echo "${env_get_value}" | sed 's/^"//g' )"

	env_get_value="$( echo "${env_get_value}" | sed "s/'$//g" )"
	env_get_value="$( echo "${env_get_value}" | sed 's/"$//g' )"

	echo "${env_get_value}"
	unset -v env_get_value
}



############################################################
# Sanity Checks
############################################################

if ! command -v grep >/dev/null 2>&1; then
	log "err" "grep not found, but required."
	exit 1
fi
if ! command -v sed >/dev/null 2>&1; then
	log "err" "sed not found, but required."
	exit 1
fi
if ! command -v awk >/dev/null 2>&1; then
	log "err" "awk not found, but required."
	exit 1
fi
if ! command -v getent >/dev/null 2>&1; then
	log "err" "getent not found, but required."
	exit 1
fi
