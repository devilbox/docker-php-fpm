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
### Add service to supervisord
###
supervisor_add_service() {
	supervisor_name="${1}"
	supervisor_command="${2}"
	supervisor_confd="${3}"
	supervisor_priority=

	if [ "${#}" -gt "3" ]; then
		supervisor_priority="${4}"
	fi

	if [ ! -d "${supervisor_confd}" ]; then
		run "mkdir -p ${supervisor_confd}"
	fi

	# Add services
	{
		echo "[program:${supervisor_name}]";
		echo "command = ${supervisor_command}";

		if [ -n "${supervisor_priority}" ]; then
			echo "priority = ${supervisor_priority}";
		fi

		echo "autostart               = true";
		echo "autorestart             = true";

		echo "stdout_logfile          = /dev/stdout";
		echo "stdout_logfile_maxbytes = 0";
		echo "stdout_events_enabled   = true";

		echo "stderr_logfile          = /dev/stderr";
		echo "stderr_logfile_maxbytes = 0";
		echo "stderr_events_enabled   = true";
	} > "${supervisor_confd}/${supervisor_name}.conf"

	unset -v supervisor_name
	unset -v supervisor_command
	unset -v supervisor_confd
	unset -v supervisor_priority
}
