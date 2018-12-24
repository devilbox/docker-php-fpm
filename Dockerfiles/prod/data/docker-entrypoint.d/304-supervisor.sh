#!/usr/bin/env bash

set -e
set -u
set -o pipefail


############################################################
# Functions
############################################################

###
### Add service to supervisord
###
supervisor_add_service() {
	local name="${1}"
	local command="${2}"
	local confd="${3}"
	local debug="${4}"
	local priority=

	if [ "${#}" -gt "4" ]; then
		priority="${5}"
	fi

	if [ ! -d "${confd}" ]; then
		run "mkdir -p ${confd}" "${debug}"
	fi

	log "info" "Enabling '${name}' to be started by supervisord" "${debug}"
	# Add services
	{
		echo "[program:${name}]";
		echo "command = ${command}";

		if [ -n "${priority}" ]; then
			echo "priority = ${priority}";
		fi

		echo "autostart               = true";
		echo "autorestart             = true";

		echo "stdout_logfile          = /dev/stdout";
		echo "stdout_logfile_maxbytes = 0";
		echo "stdout_events_enabled   = true";

		echo "stderr_logfile          = /dev/stderr";
		echo "stderr_logfile_maxbytes = 0";
		echo "stderr_events_enabled   = true";
	} > "${confd}/${name}.conf"
}
