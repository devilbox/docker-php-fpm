#!/usr/bin/env bash

set -e
set -u
set -p pipefail


###
### Globals
###

# The following global variables are available by our Dockerfile itself:
#   MY_USER
#   MY_GROUP
#   MY_UID
#   MY_GID

# Path to scripts to source
CONFIG_DIR="/docker-entrypoint.d"

# php.ini.d directory
PHP_INI_DIR="/usr/local/etc/php/conf.d"

# This file holds error and access log definitions
FPM_CONF_LOGFILE="/usr/local/etc/php-fpm.d/logfiles.conf"

# PHP-FPM log dir
FPM_LOG_DIR="/var/log/php"

# Custom ini dir (to be copied to actual ini dir)
PHP_CUST_INI_DIR="/etc/php-custom.d"

# Supervisord config directory
SUPERVISOR_CONFD="/etc/supervisor/conf.d"


###
### Source libs
###
init="$( find "${CONFIG_DIR}" -name '*.sh' -type f | sort -u )"
for f in ${init}; do
	# shellcheck disable=SC1090
	. "${f}"
done



#############################################################
## Entry Point
#############################################################

###
### Set Debug level
###
DEBUG_LEVEL="$( env_get "DEBUG_ENTRYPOINT" "0" )"
log "info" "Debug level: ${DEBUG_LEVEL}" "${DEBUG_LEVEL}"


###
### Change uid/gid
###
set_uid "NEW_UID" "${MY_USER}"  "/home/${MY_USER}" "${DEBUG_LEVEL}"
set_gid "NEW_GID" "${MY_GROUP}" "/home/${MY_USER}" "${DEBUG_LEVEL}"


###
### Set timezone
###
set_timezone "TIMEZONE" "${PHP_INI_DIR}" "${DEBUG_LEVEL}"


###
### Setup postfix
###
set_postfix "ENABLE_MAIL" "${MY_USER}" "${MY_GROUP}" "${PHP_INI_DIR}" "${DEBUG_LEVEL}"


###
### Set Logging
###
set_docker_logs \
	"DOCKER_LOGS" \
	"${FPM_LOG_DIR}" \
	"${FPM_CONF_LOGFILE}" \
	"${MY_USER}" \
	"${MY_GROUP}" \
	"${DEBUG_LEVEL}"


###
### Validate socat port forwards
###
if ! port_forward_validate "FORWARD_PORTS_TO_LOCALHOST" "${DEBUG_LEVEL}"; then
	exit 1
fi


###
### Supervisor: socat
###
for line in $( port_forward_get_lines "FORWARD_PORTS_TO_LOCALHOST" ); do
	lport="$( port_forward_get_lport "${line}" )"
	rhost="$( port_forward_get_rhost "${line}" )"
	rport="$( port_forward_get_rport "${line}" )"
	supervisor_add_service \
		"socat-${lport}-${rhost}-${rport}" \
		"/usr/bin/socat tcp-listen:${lport},reuseaddr,fork tcp:${rhost}:${rport}" \
		"${SUPERVISOR_CONFD}" \
		"${DEBUG_LEVEL}"
done


###
### Supervisor: rsyslogd & postfix
###
if [ "$( env_get "ENABLE_MAIL" )" = "1" ]; then
	supervisor_add_service "rsyslogd" "/usr/sbin/rsyslogd -n"      "${SUPERVISOR_CONFD}" "${DEBUG_LEVEL}" "1"
	supervisor_add_service "postfix"  "/usr/local/sbin/postfix.sh" "${SUPERVISOR_CONFD}" "${DEBUG_LEVEL}"
fi


###
### Supervisor: php-fpm
###
supervisor_add_service "php-fpm"  "/usr/local/sbin/php-fpm" "${SUPERVISOR_CONFD}" "${DEBUG_LEVEL}"


###
### Copy custom *.ini files
###
copy_ini_files "${PHP_CUST_INI_DIR}" "${PHP_INI_DIR}" "${DEBUG_LEVEL}"


###
### mysqldump-secure
###
fix_mds_permissions
set_mds_settings "MYSQL_BACKUP_USER" "MYSQL_BACKUP_PASS" "MYSQL_BACKUP_HOST"


###
### Startup
###
log "info" "Starting supervisord" "${DEBUG_LEVEL}"
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
