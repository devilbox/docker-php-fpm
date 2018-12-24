#!/usr/bin/env bash

set -e
set -u
set -o pipefail


############################################################
# Helper Functions
############################################################

_log_to_dockerlogs() {
	local php_fpm_conf="${1}"
	local php_ini_conf="${2}"
	{
		echo "[global]"
		echo "error_log = /proc/self/fd/2"
		echo "[www]"
		echo "access.log = /proc/self/fd/2"
	} > "${php_fpm_conf}"
	{
		echo "error_log = /proc/self/fd/2"
	} > "${php_ini_conf}"
}

_log_to_files() {
	local php_fpm_conf="${1}"
	local php_ini_conf="${2}"
	local log_dir="${3}"
	local user="${4}"
	local group="${5}"
	local debug="${6}"

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
	} > "${php_fpm_conf}"
	{
		echo "error_log = ${log_dir}/php-fpm.error"
	} > "${php_ini_conf}"
}


############################################################
# Functions
############################################################

###
### Get info if we log to docker logs
###
is_docker_logs_enabled() {
	local env_varname="${1}"
	if env_set "${env_varname}"; then
		docker_logs="$( env_get "${env_varname}" )"
		if [ "${docker_logs}" = "1" ]; then
			# Use docker logs
			echo "1"
			return 0
		fi
	fi

	# Use file based logging
	echo "0"
	return 1
}


###
### Change PHP-FPM logging (file or docker logs)
###
set_docker_logs() {
	local env_varname="${1}"
	local log_dir="${2}"
	local php_fpm_conf="${3}"
	local php_ini_conf="${4}"
	local user="${5}"
	local group="${6}"
	local debug="${7}"

	local docker_logs=

	if ! env_set "${env_varname}"; then
		log "info" "\$${env_varname} not set." "${debug}"
		log "info" "Logging to docker logs (stdout and stderr)." "${debug}"
		_log_to_dockerlogs "${php_fpm_conf}" "${php_ini_conf}"
	else
		docker_logs="$( env_get "${env_varname}" )"

		# Disable docker logs and log to files
		if [ "${docker_logs}" = "0" ]; then
			log "info" "\$${env_varname} set to 0. Logging to files under: ${log_dir}" "${debug}"
			log "info" "Make sure to mount this directory in order to view logs" "${debug}"
			_log_to_files "${php_fpm_conf}" "${php_ini_conf}" "${log_dir}" "${user}" "${group}" "${debug}"

		# Keep docker logs
		elif [ "${docker_logs}" = "1" ]; then
			log "info" "\$${env_varname} set to 1. Logging to docker logs (stdout and stderr)." "${debug}"
			_log_to_dockerlogs "${php_fpm_conf}" "${php_ini_conf}"
		else
			log "err" "Invalid value for \$${env_varname}. Can only be 0 or 1. Provided: ${docker_logs}" "${debug}"
			exit 1
		fi
	fi
}
