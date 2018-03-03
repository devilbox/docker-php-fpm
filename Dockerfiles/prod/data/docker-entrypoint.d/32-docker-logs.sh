#!/usr/bin/env bash

set -e
set -u
set -o pipefail


############################################################
# Helper Functions
############################################################

_log_to_dockerlogs() {
	local conf_logfile="${1}"
	{
		echo "[global]"
		echo "error_log = /proc/self/fd/2"
		echo "[www]"
		echo "access.log = /proc/self/fd/2"
	} > "${conf_logfile}"
}

_log_to_files() {
	local conf_logfile="${1}"
	local log_dir="${2}"
	local user="${3}"
	local group="${4}"
	local debug="${5}"

	# Create Log directory and files
	if [ ! -d "${log_dir}" ]; then
		run "mkdir -p ${log_dir}" "${debug}"
	fi
	if [ ! -f "${log_dir}/php-fpm.access" ]; then
		run "touch ${log_dir}/php-fpm.access" "${debug}"
	fi
	if [ ! -f "${log_dir}/php-fpm.error" ]; then
		run "touch ${log_dir}/php-fpm.error" "${debug}"
	fi
	run "chown -R ${user}:${group} ${log_dir}" "${debug}"
	run "chmod 0755 ${log_dir}" "${debug}"
	{
		echo "[global]"
		echo "error_log = ${log_dir}/php-fpm.error"
		echo "[www]"
		echo "access.log = ${log_dir}/php-fpm.access"
	} > "${conf_logfile}"
}


############################################################
# Functions
############################################################

###
### Change PHP-FPM logging (file or docker logs)
###
set_docker_logs() {
	local env_varname="${1}"
	local log_dir="${2}"
	local conf_logfile="${3}"
	local user="${4}"
	local group="${5}"
	local debug="${6}"

	local docker_logs=

	if ! env_set "${env_varname}"; then
		log "info" "\$${env_varname} not set." "${debug}"
		log "info" "Logging to docker logs (stdout and stderr)." "${debug}"
		_log_to_dockerlogs "${conf_logfile}"
	else
		docker_logs="$( env_get "${env_varname}" )"

		# Disable docker logs and log to files
		if [ "${docker_logs}" = "0" ]; then
			log "info" "\$${env_varname} set to 0. Logging to files under: ${log_dir}" "${debug}"
			log "info" "Make sure to mount this directory in order to view logs" "${debug}"
			_log_to_files "${conf_logfile}" "${log_dir}" "${user}" "${group}" "${debug}"

		# Keep docker logs
		elif [ "${docker_logs}" = "1" ]; then
			log "info" "\$${env_varname} set to 1. Logging to docker logs (stdout and stderr)." "${debug}"
			_log_to_dockerlogs "${conf_logfile}"
		else
			log "err" "Invalid value for \$${env_varname}. Can only be 0 or 1. Provided: ${docker_logs}" "${debug}"
			exit 1
		fi
	fi
}
