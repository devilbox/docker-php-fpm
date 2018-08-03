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

# php-fpm conf.d directory
PHP_FPM_DIR="/usr/local/etc/php-fpm.d"

# This is the log file for any mail related functions
PHP_MAIL_LOG="/var/log/mail.log"

# This file holds error and access log definitions
PHP_FPM_CONF_LOGFILE="${PHP_FPM_DIR}/zzz-entrypoint-logfiles.conf"
PHP_INI_CONF_LOGFILE="${PHP_INI_DIR}/zzz-entrypoint-logfiles.ini"

# PHP-FPM log dir
FPM_LOG_DIR="/var/log/php"

# Custom ini dir (to be copied to actual ini dir)
PHP_CUST_INI_DIR="/etc/php-custom.d"

# Custom PHP-FPM dir (to be copied to actual FPM conf dir)
PHP_CUST_FPM_DIR="/etc/php-fpm-custom.d"

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
### PHP-FPM 5.2 and PHP-FPM 5.3 Env variables fix
###
if php -v 2>/dev/null | grep -Eoq '^PHP[[:space:]]5\.(2|3)'; then
	set_env_php_fpm "/usr/local/etc/php-fpm.d/env.conf"
fi


###
### Set Logging
###
set_docker_logs \
	"DOCKER_LOGS" \
	"${FPM_LOG_DIR}" \
	"${PHP_FPM_CONF_LOGFILE}" \
	"${PHP_INI_CONF_LOGFILE}" \
	"${MY_USER}" \
	"${MY_GROUP}" \
	"${DEBUG_LEVEL}"


###
### Setup postfix
###
if is_docker_logs_enabled "DOCKER_LOGS" >/dev/null; then
	# PHP mail function should log to stderr
	set_postfix "ENABLE_MAIL" "${MY_USER}" "${MY_GROUP}" "${PHP_INI_DIR}" "/proc/self/fd/2" "1" "${DEBUG_LEVEL}"
else
	# PHP mail function should log to file
	set_postfix "ENABLE_MAIL" "${MY_USER}" "${MY_GROUP}" "${PHP_INI_DIR}" "${PHP_MAIL_LOG}" "0" "${DEBUG_LEVEL}"
fi


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
### Copy custom PHP-FPM *.conf files
###
if [ "${PHP_VERSION}" = "5.2" ]; then
	copy_fpm_5_2_conf_file "${PHP_CUST_FPM_DIR}/php-fpm.xml" "${DEBUG_LEVEL}"
else
copy_fpm_files "${PHP_CUST_FPM_DIR}" "${PHP_FPM_DIR}" "${DEBUG_LEVEL}"
fi


###
### Enable PHP Modules
###
enable_modules "ENABLE_MODULES" "${DEBUG_LEVEL}"


###
### Disable PHP Modules
###
disable_modules "DISABLE_MODULES" "${DEBUG_LEVEL}"


###
### mysqldump-secure
###
fix_mds_permissions "${MY_USER}" "${MY_GROUP}" "${DEBUG_LEVEL}"
set_mds_settings "MYSQL_BACKUP_USER" "MYSQL_BACKUP_PASS" "MYSQL_BACKUP_HOST" "${DEBUG_LEVEL}"


###
### Fix mountpoint permissions
###
if [ ! -d "/shared/backups" ]; then
	run "mkdir -p /shared/backups" "${DEBUG_LEVEL}"
fi
if [ ! -d "/shared/httpd" ]; then
	run "mkdir -p /shared/httpd" "${DEBUG_LEVEL}"
fi
run "chown ${MY_USER}:${MY_GROUP} /shared/backups" "${DEBUG_LEVEL}"
run "chown ${MY_USER}:${MY_GROUP} /shared/httpd" "${DEBUG_LEVEL}"
run "chmod 0755 /shared/backups" "${DEBUG_LEVEL}"
run "chmod 0755 /shared/httpd" "${DEBUG_LEVEL}"


###
### Update ca-certificates
###
update_ca_certificates "/ca" "${DEBUG_LEVEL}"


###
### Startup
###
log "info" "Starting supervisord" "${DEBUG_LEVEL}"
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
