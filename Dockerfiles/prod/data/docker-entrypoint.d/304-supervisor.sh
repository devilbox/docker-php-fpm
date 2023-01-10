#!/usr/bin/env bash

set -e
set -u
set -o pipefail


############################################################
# Functions
############################################################

###
### Create main supvervisord configuration file
###
supervisor_create_config() {
	local path="${1}"

	# Enable supervisorctl (default: disabled)
	SVCTL_ENABLE="${SVCTL_ENABLE:-0}"
	if [ -z "${SVCTL_USER:-}" ]; then
		SVCTL_USER="$( get_random_alphanum "10" )"
	fi
	if [ -z "${SVCTL_PASS:-}" ]; then
		SVCTL_PASS="$( get_random_alphanum "10" )"
	fi

	{
		# Use 'echo_supervisord_conf' to generate an example config
		if [ "${SVCTL_ENABLE}" = "1" ]; then
			echo "[rpcinterface:supervisor]"
			echo "supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface"
			echo
			echo "[unix_http_server]"
			echo "file  = /tmp/supervisor.sock"
			echo "chmod = 0700"
			echo
			echo "[supervisorctl]"
			echo "serverurl = unix:///tmp/supervisor.sock"
			echo "username  = ${SVCTL_USER}      ; should be same as in [*_http_server] if set"
			echo "password  = ${SVCTL_PASS}      ; should be same as in [*_http_server] if set"
		fi
		echo "[supervisord]"
		echo "user        = root"
		echo "nodaemon    = true"
		echo "loglevel    = info"
		echo "logfile     = /var/log/supervisor/supervisord.log"
		echo "pidfile     = /var/run/supervisord.pid"
		echo "childlogdir = /var/log/supervisor"
		echo "strip_ansi  = true"  # Required to fix tail logs
		echo
		echo "[include]"
		echo "files = /etc/supervisor/conf.d/*.conf /etc/supervisor/custom.d/*.conf"
	} > "${path}"
}


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


###
### Get Random alphanumeric string
###
get_random_alphanum() {
	local len="${1:-15}"  # length defaults to 15
	tr -dc A-Za-z0-9 < /dev/urandom | head -c "${len}" | xargs || true
}


############################################################
# Sanity Checks
############################################################

if ! command -v tr >/dev/null 2>&1; then
	echo "tr not found, but required."
	exit 1
fi
if ! command -v xargs >/dev/null 2>&1; then
	echo "xargs not found, but required."
	exit 1
fi
