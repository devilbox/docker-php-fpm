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
if ! name="$( docker_run "${IMAGE}:${TAG}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=$(id -u) -e NEW_GID=$(id -g) -e DOCKER_LOGS=0 -v ${WWW_DIR_HOST}:${WWW_DIR_CONT} -v ${LOG_DIR_HOST}:/var/log/php" )"; then
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
	docker_logs "${name}" || true
	docker_stop "${nginx_name}" || true
	docker_stop "${name}" || true
	rm -rf "${LOG_DIR_HOST}"
	rm -rf "${CFG_DIR_HOST}"
	rm -rf "${WWW_DIR_HOST}"
	echo "Failed"
	exit 1
fi

print_h2 "Ensure php-fpm.access exists"
if ! run "test -f ${LOG_DIR_HOST}/php-fpm.access"; then
	echo "Access log does not exist: ${LOG_DIR_HOST}/php-fpm.access"
	ls -lap "${LOG_DIR_HOST}/"
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

print_h2 "Ensure php-fpm.access is readable"
if ! run "test -r ${LOG_DIR_HOST}/php-fpm.access"; then
	echo "Access log is not readable"
	ls -lap "${LOG_DIR_HOST}/"
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

print_h2 "Ensure php-fpm.error exists"
if ! run "test -f ${LOG_DIR_HOST}/php-fpm.error"; then
	echo "Error log does not exist: ${LOG_DIR_HOST}/php-fpm.error"
	ls -lap "${LOG_DIR_HOST}/"
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

print_h2 "Ensure php-fpm.error is readable"
if ! run "test -r ${LOG_DIR_HOST}/php-fpm.error"; then
	echo "Error log is not readable"
	ls -lap "${LOG_DIR_HOST}/"
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

print_h2 "Ensure no access/error logging exists in stderr (ok.php)"
if run "docker logs ${name} 2>&1 | grep 'GET /ok.php'"; then
	echo "Error access log string for 'GET /ok.php' found in stderr, but shold go to file"
	run "cat ${LOG_DIR_HOST}/php-fpm.access"
	run "cat ${LOG_DIR_HOST}/php-fpm.error"
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

print_h2 "Ensure no access/error logging exists in stderr (fail.php)"
if run "docker logs ${name} 2>&1 | grep 'GET /fail.php'"; then
	echo "Error access log string for 'GET /fail.php' found in stderr, but should go to file"
	run "cat ${LOG_DIR_HOST}/php-fpm.access"
	run "cat ${LOG_DIR_HOST}/php-fpm.error"
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

print_h2 "Ensure no error message is present in stderr"
if run "docker logs ${name} 2>&1 | grep '/var/www/default/fail.php'"; then
	echo "Error error message found in stderr, but should go to file"
	run "cat ${LOG_DIR_HOST}/php-fpm.access"
	run "cat ${LOG_DIR_HOST}/php-fpm.error"
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

# PHP-FPM 5.2 does not show access logs
if [ "${VERSION}" != "5.2" ]; then
	# Test access and error file for correct content
	print_h2 "Test access logs in php-fpm.access (ok.php)"
	if ! run "grep 'GET /ok.php' ${LOG_DIR_HOST}/php-fpm.access"; then
		echo "Error no access log string for 'GET /ok.php' found in: ${LOG_DIR_HOST}/php-fpm.access"
		run "cat ${LOG_DIR_HOST}/php-fpm.access"
		run "cat ${LOG_DIR_HOST}/php-fpm.error"
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

	print_h2 "Test access logs in php-fpm.access (fail.php)"
	if ! run "grep 'GET /fail.php' ${LOG_DIR_HOST}/php-fpm.access"; then
		echo "Error no access log string for 'GET /fail.php' found in: ${LOG_DIR_HOST}/php-fpm.access"
		run "cat ${LOG_DIR_HOST}/php-fpm.access"
		run "cat ${LOG_DIR_HOST}/php-fpm.error"
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

print_h2 "Ensiure error message is present in php-fpm.error"
if ! run "grep '/var/www/default/fail.php' ${LOG_DIR_HOST}/php-fpm.error"; then
	echo "Error no error message found in:  ${LOG_DIR_HOST}/php-fpm.error"
	run "cat ${LOG_DIR_HOST}/php-fpm.access"
	run "cat ${LOG_DIR_HOST}/php-fpm.error"
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
### Shutdown
###
print_h2 "Cleanup"
docker_logs "${name}" || true
run "ls -lap ${LOG_DIR_HOST}/"
run "cat ${LOG_DIR_HOST}/php-fpm.access"
run "cat ${LOG_DIR_HOST}/php-fpm.error"
docker_stop "${nginx_name}" || true
docker_stop "${name}"
rm -rf "${LOG_DIR_HOST}"
rm -rf "${CFG_DIR_HOST}"
rm -rf "${WWW_DIR_HOST}"
