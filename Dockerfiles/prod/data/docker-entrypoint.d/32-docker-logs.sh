#!/bin/sh
#
# Available global variables:
#   + MY_USER
#   + MY_GROUP
#   + DEBUG_LEVEL


set -e
set -u



############################################################
# Helper Functions
############################################################

# Check if PHP-FPM config files contain valid logging directives
_validate_docker_logs() {
	vdl_fpm_error_log_conf="${1}"
	vdl_fpm_access_log_conf="${2}"

	if [ ! -f "${vdl_fpm_error_log_conf}" ]; then
		log "err" "PHP-FPM Error log config file does not exist in: ${vdl_fpm_error_log_conf}"
		exit 1
	fi
	if [ ! -f "${vdl_fpm_access_log_conf}" ]; then
		log "err" "PHP-FPM Access log config file does not exist in: ${dl_fpm_access_log_conf}"
		exit 1
	fi

	if ! grep -Eq '^error_log.*$' "${vdl_fpm_error_log_conf}"; then
		log "err" "PHP-FPM Error log config file has no error logging directive"
		exit 1
	fi
	if ! grep -Eq '^access\.log.*$' "${vdl_fpm_access_log_conf}"; then
		log "err" "PHP-FPM Access log config file has no access logging directive"
		exit 1
	fi

	unset -v vdl_fpm_error_log_conf
	unset -v vdl_fpm_access_log_conf
}



############################################################
# Functions
############################################################

###
### Change UID
###
set_docker_logs() {
	dl_env_varname="${1}"
	dl_log_dir="${2}"
	dl_fpm_error_log_conf="${3}"
	dl_fpm_access_log_conf="${4}"

	if ! env_set "${dl_env_varname}"; then
		log "info" "\$${dl_env_varname} not set."
		log "info" "Logging to docker logs stdout and stderr"
	else
		dl_docker_logs="$( env_get "${dl_env_varname}" )"

		# Disable docker logs and log to files
		if [ "${dl_docker_logs}" = "0" ]; then
			log "info" "\$${dl_env_varname} set to 0. Logging to files under: ${dl_log_dir}"
			log "info" "Make sure to mount this directory in order to view logs"

			# Validation
			_validate_docker_logs "${dl_fpm_error_log_conf}" "${dl_fpm_access_log_conf}"

			# Create Log directory
			if [ ! -d "${dl_log_dir}" ]; then
				run "mkdir -p ${dl_log_dir}"
			fi

			# Fix permissions (in case uid/gid has changed)
			if [ ! -f "${dl_log_dir}/php-fpm.access" ]; then
				touch "${dl_log_dir}/php-fpm.access"
			fi
			if [ ! -f "${dl_log_dir}/php-fpm.error" ]; then
				touch "${dl_log_dir}/php-fpm.error"
			fi
			run "chown -R ${MY_USER}:${MY_GROUP} ${dl_log_dir}"

			# Adjust PHP-FPM config to log to file
			run "sed -i'' 's|^error_log.*$|error_log = ${dl_log_dir}/php-fpm.error|g' ${dl_fpm_error_log_conf}"
			run "sed -i'' 's|^access\.log.*$|access.log = ${dl_log_dir}/php-fpm.access|g' ${dl_fpm_access_log_conf}"

		# Keep docker logs
		elif [ "${dl_docker_logs}" = "1" ]; then
			log "info" "\$${dl_env_varname} set to 1. Logging to docker logs stdout and stderr."
		else
			log "err" "Invalid value for \$${dl_env_varname}. Can only be 0 or 1. Provided: ${dl_docker_logs}"
			exit 1
		fi
	fi

	unset -v dl_env_varname
	unset -v dl_log_dir
	unset -v dl_fpm_error_log_conf
	unset -v dl_fpm_access_log_conf
	unset -v dl_docker_logs
}


############################################################
# Sanity Checks
############################################################

if ! command -v sed >/dev/null 2>&1; then
	echo "sed not found, but required."
	exit 1
fi
