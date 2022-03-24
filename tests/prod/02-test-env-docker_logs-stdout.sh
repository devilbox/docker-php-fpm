#!/usr/bin/env bash

set -e
set -u
set -o pipefail

CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

IMAGE="${1}"
ARCH="${2}"
VERSION="${3}"
FLAVOUR="${4}"
TAG="${5}"

# shellcheck disable=SC1090
. "${CWD}/../.lib.sh"



############################################################
# Tests
############################################################

###
### Docker logs (STDOUT)
###
WWW_PORT="23254"
WWW_DIR_HOST="$( mktemp -d )"
WWW_DIR_CONT="/var/www/default"
CFG_DIR_HOST="$( mktemp -d )"
CFG_DIR_CONT="/etc/nginx/conf.d"
LOG_DIR_HOST="$( mktemp --directory )"
CONTAINER="nginx:stable"

# Create www files
echo "<?php echo 'ok';" > "${WWW_DIR_HOST}/ok.php"
echo "<?php syntax error:" > "${WWW_DIR_HOST}/fail.php"

# Fix mount permissions
chmod 0777 -R "${LOG_DIR_HOST}"
chmod 0777 -R "${CFG_DIR_HOST}"
chmod 0777 -R "${WWW_DIR_HOST}"


# Pull Image
print_h2 "Pulling Nginx"
run "until docker pull --platform ${ARCH} ${CONTAINER}; do sleep 1; done"

###
### Start container
###

# Start PHP-FPM
print_h2 "Starting PHP-FPM"
if ! name="$( docker_run "${IMAGE}:${TAG}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=$(id -u) -e NEW_GID=$(id -g) -e DOCKER_LOGS=1 -v ${WWW_DIR_HOST}:${WWW_DIR_CONT} -v ${LOG_DIR_HOST}:/var/log/php" )"; then
	exit 1
fi

# Check if PHP-FPM is running
print_h2 "Check if PHP-FPM is running"
if ! check_php_fpm_running "${name}"; then
	docker_logs "${name}"  || true
	docker_stop "${name}"  || true
	echo "Failed"
	exit 1
fi

# Nginx.conf
{
	echo "server {"
	echo "    server_name _;"
	echo "    listen 80;"
	echo "    root ${WWW_DIR_CONT};"
	echo "    index index.php;"
	echo "    location ~* \.php\$ {"
	echo "        fastcgi_index index.php;"
	echo "        fastcgi_pass ${name}:9000;"
	echo "        include fastcgi_params;"
	echo "        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;"
	echo "        fastcgi_param SCRIPT_NAME     \$fastcgi_script_name;"
	echo "    }"
	echo "}"
} > "${CFG_DIR_HOST}/php.conf"


# Start Nginx
print_h2 "Starting Nginx"
if ! nginx_name="$( docker_run "${CONTAINER}" "${ARCH}" "-v ${WWW_DIR_HOST}:${WWW_DIR_CONT} -v ${CFG_DIR_HOST}:${CFG_DIR_CONT} -p ${WWW_PORT}:80 --link ${name}" )"; then
	docker_stop "${name}"  || true
	exit 1
fi
# Wait for both containers to be up and running
run "sleep 10"


###
### Fire positive and error generating request
###
print_h2 "Fire curl requests"
run "curl http://localhost:${WWW_PORT}/ok.php"
run "curl http://localhost:${WWW_PORT}/fail.php"


###
### Run tests
###
print_h2 "Checking DOCKER_LOGS"
if ! run "docker logs ${name} 2>&1 | grep 'DOCKER_LOGS'"; then
	docker_logs "${nginx_name}" || true
	docker_logs "${name}"       || true
	docker_stop "${nginx_name}" || true
	docker_stop "${name}"       || true
	rm -rf "${LOG_DIR_HOST}"
	rm -rf "${CFG_DIR_HOST}"
	rm -rf "${WWW_DIR_HOST}"
	echo "Failed"
	exit 1
fi

print_h2 "Ensure php-fpm.access does not exist"
if ! run_fail "test -f ${LOG_DIR_HOST}/php-fpm.access"; then
	echo "Access log should not exist: ${LOG_DIR_HOST}/php-fpm.access"
	ls -lap "${LOG_DIR_HOST}/"
	cat "${LOG_DIR_HOST}/php-fpm.access"
	docker_logs "${nginx_name}" || true
	docker_logs "${name}"       || true
	docker_stop "${nginx_name}" || true
	docker_stop "${name}"       || true
	rm -rf "${LOG_DIR_HOST}"
	rm -rf "${CFG_DIR_HOST}"
	rm -rf "${WWW_DIR_HOST}"
	echo "Failed"
	exit 1
fi

print_h2 "Ensure php-fpm.error does not exist"
if ! run_fail "test -f ${LOG_DIR_HOST}/php-fpm.error"; then
	echo "Error log should not exist: ${LOG_DIR_HOST}/php-fpm.error"
	ls -lap "${LOG_DIR_HOST}/"
	cat "${LOG_DIR_HOST}/php-fpm.error"
	docker_logs "${nginx_name}" || true
	docker_logs "${name}"       || true
	docker_stop "${nginx_name}" || true
	docker_stop "${name}"       || true
	rm -rf "${LOG_DIR_HOST}"
	rm -rf "${CFG_DIR_HOST}"
	rm -rf "${WWW_DIR_HOST}"
	echo "Failed"
	exit 1
fi

###
### PHP 5.2 still does not show any errors
###
if [ "${VERSION}" != "5.2" ]; then
	print_h2 "Ensure stderr access logging is enabled"
	if ! run "docker logs ${name} 2>&1 | grep 'GET /ok.php'"; then
		echo "Error no access log string for 'GET /ok.php' found in stderr"
		docker_logs "${nginx_name}" || true
		docker_logs "${name}"       || true
		docker_stop "${nginx_name}" || true
		docker_stop "${name}"       || true
		rm -rf "${LOG_DIR_HOST}"
		rm -rf "${CFG_DIR_HOST}"
		rm -rf "${WWW_DIR_HOST}"
		echo "Failed"
		exit 1
	fi
	print_h2 "Ensure stderr access logging is enabled"
	if ! run "docker logs ${name} 2>&1 | grep 'GET /fail.php'"; then
		echo "Error no access log string for 'GET /fail.php' found in stderr"
		docker_logs "${nginx_name}" || true
		docker_logs "${name}"       || true
		docker_stop "${nginx_name}" || true
		docker_stop "${name}"       || true
		rm -rf "${LOG_DIR_HOST}"
		rm -rf "${CFG_DIR_HOST}"
		rm -rf "${WWW_DIR_HOST}"
		echo "Failed"
		exit 1
	fi
	print_h2 "Ensure errors are logged to stderr"
	if ! run "docker logs ${name} 2>&1 | grep '/var/www/default/fail.php'"; then
		echo "Error no error message found in stderr"
		docker_logs "${nginx_name}" || true
		docker_logs "${name}"       || true
		docker_stop "${nginx_name}" || true
		docker_stop "${name}"       || true
		rm -rf "${LOG_DIR_HOST}"
		rm -rf "${CFG_DIR_HOST}"
		rm -rf "${WWW_DIR_HOST}"
		echo "Failed"
		exit 1
	fi
fi


###
### Shutdown
###
print_h2 "Cleanup"
docker_stop "${nginx_name}" || true
docker_stop "${name}"       || true
rm -rf "${LOG_DIR_HOST}"
rm -rf "${CFG_DIR_HOST}"
rm -rf "${WWW_DIR_HOST}"
