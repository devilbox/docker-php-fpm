#!/bin/sh
#
# Available global variables:
#   + MY_USER
#   + MY_GROUP

set -e
set -u


###
### Variables
###
PHP_INI_PATH="/usr/local/etc/php.ini"
FPM_ERROR_LOG_CFG="/usr/local/etc/php-fpm.conf"
FPM_ACCESS_LOG_CFG="/usr/local/etc/php-fpm.d/zzz-docker.conf"
FPM_LOG_DIR="/var/log/php"

#PHP_CUST_MODULE_DIR="/etc/php-modules.d"

PHP_CUST_INI_DIR="/etc/php-custom.d"
PHP_REAL_INI_DIR="/usr/local/etc/php.d"

SUPERVISOR_CONFD="/etc/supervisor/conf.d"


###
### Source libs
###
init="$( find /docker-entrypoint.d -name '*.sh' -type f | sort -u )"
for f in ${init}; do
	# shellcheck disable=SC1090
	. "${f}"
done


###
### Set Debug level
###
DEBUG_LEVEL="$( get_debug_level "DEBUG_ENTRYPOINT" "0" )"
log "info" "Debug level: ${DEBUG_LEVEL}" "${DEBUG_LEVEL}"



#############################################################
## Sanity checks
#############################################################

if ! command -v socat >/dev/null 2>&1; then
	log "err" "socat not found, but required." "${DEBUG_LEVEL}"
	exit 1
fi



#############################################################
## Entry Point
#############################################################

###
### Change uid/gid
###
set_uid "NEW_UID"
set_gid "NEW_GID"


###
### Set timezone
###
set_timezone "TIMEZONE" "${PHP_INI_PATH}"


###
### Set Logging
###
set_docker_logs \
	"DOCKER_LOGS" \
	"${FPM_LOG_DIR}" \
	"${FPM_ERROR_LOG_CFG}" \
	"${FPM_ACCESS_LOG_CFG}"


###
### Setup postfix
###
set_postfix "ENABLE_MAIL"


###
### Validate socat port forwards
###
if ! port_forward_validate "FORWARD_PORTS_TO_LOCALHOST"; then
	exit 1
fi


###
### Supervisor: socat
###
for line in $( port_forward_get_lines "FORWARD_PORTS_TO_LOCALHOST" ); do
	lport="$( port_forward_get_lport "${line}" )"
	rhost="$( port_forward_get_rhost "${line}" )"
	rport="$( port_forward_get_rport "${line}" )"
	supervisor_add_service "socat-${lport}-${rhost}-${rport}" "/usr/bin/socat tcp-listen:${lport},reuseaddr,fork tcp:${rhost}:${rport}" "${SUPERVISOR_CONFD}"
done


###
### Supervisor: rsyslogd & postfix
###
if [ "$( env_get "ENABLE_MAIL" )" = "1" ]; then
	supervisor_add_service "rsyslogd" "/usr/sbin/rsyslogd -n"      "${SUPERVISOR_CONFD}" "1"
	supervisor_add_service "postfix"  "/usr/local/sbin/postfix.sh" "${SUPERVISOR_CONFD}"
fi


###
### Supervisor: php-fpm
###
supervisor_add_service "php-fpm"  "/usr/local/sbin/php-fpm" "${SUPERVISOR_CONFD}"


###
### Copy custom *.ini files
###
copy_ini_files "${PHP_CUST_INI_DIR}" "${PHP_REAL_INI_DIR}"


###
### mysqldump-secure
###
fix_mds_permissions
set_mds_settings "MYSQL_BACKUP_USER" "MYSQL_BACKUP_PASS" "MYSQL_BACKUP_HOST"


###
### Start
###
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
