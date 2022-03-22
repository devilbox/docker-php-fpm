#!/usr/bin/env bash

set -e
set -u
set -o pipefail

CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

IMAGE="${1}"
ARCH="${2}"
VERSION="${3}"
FLAVOUR="${4}"

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
run "until docker pull --platform ${ARCH} ${CONTAINER}; do sleep 1; done"

###
### Start container
###

# Start PHP-FPM
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=$(id -u) -e NEW_GID=$(id -g) -e DOCKER_LOGS=1 -v ${WWW_DIR_HOST}:${WWW_DIR_CONT} -v ${LOG_DIR_HOST}:/var/log/php" )"
name="$( docker_name "${did}" )"

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
ndid="$( docker_run "${CONTAINER}" "${ARCH}" "-v ${WWW_DIR_HOST}:${WWW_DIR_CONT} -v ${CFG_DIR_HOST}:${CFG_DIR_CONT} -p ${WWW_PORT}:80 --link ${name}" )"

# Wait for both containers to be up and running
run "sleep 10"


###
### Fire positive and error generating request
###
run "curl http://localhost:${WWW_PORT}/ok.php"
run "curl http://localhost:${WWW_PORT}/fail.php"


###
### Run tests
###
if ! run "docker logs ${did} 2>&1 | grep -q 'DOCKER_LOGS'"; then
	docker_logs "${did}" || true
	docker_stop "${ndid}" || true
	docker_stop "${did}" || true
	rm -rf "${LOG_DIR_HOST}"
	rm -rf "${CFG_DIR_HOST}"
	rm -rf "${WWW_DIR_HOST}"
	echo "Failed"
	exit 1
fi

if [ -f "${LOG_DIR_HOST}/php-fpm.access" ]; then
	echo "Access log should not exist: ${LOG_DIR_HOST}/php-fpm.access"
	ls -lap "${LOG_DIR_HOST}/"
	cat "${LOG_DIR_HOST}/php-fpm.access"
	docker_logs "${did}" || true
	docker_stop "${ndid}" || true
	docker_stop "${did}" || true
	rm -rf "${LOG_DIR_HOST}"
	rm -rf "${CFG_DIR_HOST}"
	rm -rf "${WWW_DIR_HOST}"
	echo "Failed"
	exit 1
fi

if [ -f "${LOG_DIR_HOST}/php-fpm.error" ]; then
	echo "Error log should not exist: ${LOG_DIR_HOST}/php-fpm.error"
	ls -lap "${LOG_DIR_HOST}/"
	cat "${LOG_DIR_HOST}/php-fpm.error"
	docker_logs "${did}" || true
	docker_stop "${ndid}" || true
	docker_stop "${did}" || true
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
	if ! run "docker logs ${did} 2>&1 | grep -q 'GET /ok.php'"; then
		echo "Error no access log string for 'GET /ok.php' found in stderr"
		docker_logs "${did}" || true
		docker_stop "${ndid}" || true
		docker_stop "${did}" || true
		rm -rf "${LOG_DIR_HOST}"
		rm -rf "${CFG_DIR_HOST}"
		rm -rf "${WWW_DIR_HOST}"
		echo "Failed"
		exit 1
	fi
	if ! run "docker logs ${did} 2>&1 | grep -q 'GET /fail.php'"; then
		echo "Error no access log string for 'GET /fail.php' found in stderr"
		docker_logs "${did}" || true
		docker_stop "${ndid}" || true
		docker_stop "${did}" || true
		rm -rf "${LOG_DIR_HOST}"
		rm -rf "${CFG_DIR_HOST}"
		rm -rf "${WWW_DIR_HOST}"
		echo "Failed"
		exit 1
	fi
	if ! run "docker logs ${did} 2>&1 | grep -q '/var/www/default/fail.php'"; then
		echo "Error no error message found in stderr"
		docker_logs "${did}" || true
		docker_stop "${ndid}" || true
		docker_stop "${did}" || true
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
docker_stop "${ndid}" || true
docker_stop "${did}"
rm -rf "${LOG_DIR_HOST}"
rm -rf "${CFG_DIR_HOST}"
rm -rf "${WWW_DIR_HOST}"
