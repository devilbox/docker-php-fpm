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
if [ "${VERSION}" = "5.2" ]; then
	echo "Skipping tests for PHP 5.2"
	exit 0
fi


###
### Test Nginx with PHP-FPM
###
WWW_PORT="23254"
DOC_ROOT_HOST="$( mktemp -d )"
DOC_ROOT_CONT="/var/www/default"

CONFIG_HOST="$( mktemp -d )"
CONFIG_CONT="/etc/nginx/conf.d"

PHP_CNF_HOST="$( mktemp -d )"
PHP_CNF_CONT="/etc/php-fpm-custom.d"

CONTAINER="nginx:stable"

printf "[www]\nphp_admin_value[memory_limit] = 17M\n" > "${PHP_CNF_HOST}/post.conf"
echo "<?php phpinfo();" > "${DOC_ROOT_HOST}/index.php"

# Fix mount permissions
chmod 0777 "${CONFIG_HOST}"
chmod 0777 "${PHP_CNF_HOST}"
chmod 0777 "${DOC_ROOT_HOST}"
chmod 0644 "${DOC_ROOT_HOST}/index.php"

# Pull container
run "until docker pull --platform ${ARCH} ${CONTAINER}; do sleep 1; done"

# Start PHP-FPM
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=$(id -u) -e NEW_GID=$(id -g) -v ${DOC_ROOT_HOST}:${DOC_ROOT_CONT} -v ${PHP_CNF_HOST}:${PHP_CNF_CONT}" )"
name="$( docker_name "${did}" )"

# Nginx.conf
{
	echo "server {"
	echo "    server_name _;"
	echo "    listen 80;"
	echo "    root ${DOC_ROOT_CONT};"
	echo "    index index.php;"
	echo "    location ~* \.php\$ {"
	echo "        fastcgi_index index.php;"
	echo "        fastcgi_pass ${name}:9000;"
	echo "        include fastcgi_params;"
	echo "        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;"
	echo "        fastcgi_param SCRIPT_NAME     \$fastcgi_script_name;"
	echo "    }"
	echo "}"
} > "${CONFIG_HOST}/php.conf"


# Start Nginx
ndid="$( docker_run "${CONTAINER}" "${ARCH}" "-v ${DOC_ROOT_HOST}:${DOC_ROOT_CONT} -v ${CONFIG_HOST}:${CONFIG_CONT} -p ${WWW_PORT}:80 --link ${name}" )"

# Wait for both containers to be up and running
run "sleep 10"

# Check entrypoint
if ! run "docker logs ${did} | grep 'post.conf'"; then
	docker_logs "${ndid}" || true
	docker_logs "${did}"  || true
	docker_stop "${ndid}" || true
	docker_stop "${did}"  || true
	rm -rf "${DOC_ROOT_HOST}"
	rm -rf "${CONFIG_HOST}"
	rm -rf "${PHP_CNF_HOST}"
	echo "Failed"
	exit 1
fi

# Check PHP connectivity
if ! run "curl -q -4 http://127.0.0.1:${WWW_PORT}/index.php >/dev/null 2>&1"; then
	# Info
	run "netstat -tuln"
	run "curl -4 http://127.0.0.1:${WWW_PORT}/index.php" || true
	run "curl -6 http://127.0.0.1:${WWW_PORT}/index.php" || true
	run "docker ps --no-trunc"
	docker_exec "${ndid}" "nginx -t"

	# Show logs
	docker_logs "${ndid}" || true
	docker_logs "${did}"  || true

	# Ensure file is available
	docker_exec "${ndid}" "ls -la ${DOC_ROOT_CONT}/"
	docker_exec "${did}"  "ls -la ${DOC_ROOT_CONT}/"

	docker_exec "${ndid}" "cat ${DOC_ROOT_CONT}/index.php"
	docker_exec "${did}"  "cat ${DOC_ROOT_CONT}/index.php"

	# Nginx configuration
	docker_exec "${ndid}" "cat ${CONFIG_CONT}/php.conf"

	# Shutdown
	docker_stop "${ndid}" || true
	docker_stop "${did}"  || true
	rm -rf "${DOC_ROOT_HOST}"
	rm -rf "${CONFIG_HOST}"
	rm -rf "${PHP_CNF_HOST}"
	echo "Failed"
	exit 1
fi


# Check modified php-fpm.conf
if ! run "curl -q -4 http://127.0.0.1:${WWW_PORT}/index.php 2>/dev/null | grep memory_limit | grep '17M'"; then
	# Info
	run "netstat -tuln"
	run "curl -4 http://127.0.0.1:${WWW_PORT}/index.php | grep memory_limit" || true
	run "docker ps --no-trunc"
	docker_exec "${ndid}" "nginx -t"

	# Show logs
	docker_logs "${ndid}" || true
	docker_logs "${did}"  || true

	# Ensure file is available
	docker_exec "${ndid}" "ls -la ${DOC_ROOT_CONT}/"
	docker_exec "${did}"  "ls -la ${DOC_ROOT_CONT}/"

	docker_exec "${ndid}" "cat ${DOC_ROOT_CONT}/index.php"
	docker_exec "${did}"  "cat ${DOC_ROOT_CONT}/index.php"

	# Nginx configuration
	docker_exec "${ndid}" "cat ${CONFIG_CONT}/php.conf"

	# Shutdown
	docker_stop "${ndid}" || true
	docker_stop "${did}"  || true
	rm -rf "${DOC_ROOT_HOST}"
	rm -rf "${CONFIG_HOST}"
	rm -rf "${PHP_CNF_HOST}"
	echo "Failed"
	exit 1
fi


# Cleanup
docker_stop "${did}"
docker_stop "${ndid}"
rm -rf "${DOC_ROOT_HOST}"
rm -rf "${CONFIG_HOST}"
rm -rf "${PHP_CNF_HOST}"
