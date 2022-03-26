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
print_h2 "Pulling Nginx"
run "until docker pull --platform ${ARCH} ${CONTAINER}; do sleep 1; done"

# Start PHP-FPM
print_h2 "Starting PHP-FPM"
if ! name="$( docker_run "${IMAGE}:${TAG}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=$(id -u) -e NEW_GID=$(id -g) -v ${DOC_ROOT_HOST}:${DOC_ROOT_CONT} -v ${PHP_CNF_HOST}:${PHP_CNF_CONT}" )"; then
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
print_h2 "Starting Nginx"
if ! name_nginx="$( docker_run "${CONTAINER}" "${ARCH}" "-v ${DOC_ROOT_HOST}:${DOC_ROOT_CONT} -v ${CONFIG_HOST}:${CONFIG_CONT} -p ${WWW_PORT}:80 --link ${name}" )"; then
	docker_stop "${name}"  || true
	exit 1
fi
# Wait for both containers to be up and running
run "sleep 10"

# Check entrypoint
print_h2 "Checking entrypoint"
if ! run "docker logs ${name} | grep 'post.conf'"; then
	docker_logs "${name_nginx}" || true
	docker_logs "${name}"  || true
	docker_stop "${name_nginx}" || true
	docker_stop "${name}"  || true
	rm -rf "${DOC_ROOT_HOST}"
	rm -rf "${CONFIG_HOST}"
	rm -rf "${PHP_CNF_HOST}"
	echo "Failed"
	exit 1
fi

# Check PHP connectivity
print_h2 "Checking connectivity"
if ! run "curl -q -4 http://127.0.0.1:${WWW_PORT}/index.php >/dev/null 2>&1"; then
	# Info
	run "netstat -tuln"
	run "curl -4 http://127.0.0.1:${WWW_PORT}/index.php" || true
	run "curl -6 http://127.0.0.1:${WWW_PORT}/index.php" || true
	run "docker ps --no-trunc"
	docker_exec "${name_nginx}" "nginx -t"

	# Show logs
	docker_logs "${name_nginx}" || true
	docker_logs "${name}"       || true

	# Ensure file is available
	docker_exec "${name_nginx}" "ls -la ${DOC_ROOT_CONT}/"
	docker_exec "${name}"       "ls -la ${DOC_ROOT_CONT}/"

	docker_exec "${name_nginx}" "cat ${DOC_ROOT_CONT}/index.php"
	docker_exec "${name}"       "cat ${DOC_ROOT_CONT}/index.php"

	# Nginx configuration
	docker_exec "${name_nginx}" "cat ${CONFIG_CONT}/php.conf"

	# Shutdown
	docker_stop "${name_nginx}" || true
	docker_stop "${name}"       || true
	rm -rf "${DOC_ROOT_HOST}"
	rm -rf "${CONFIG_HOST}"
	rm -rf "${PHP_CNF_HOST}"
	echo "Failed"
	exit 1
fi

# Check modified php-fpm.conf
print_h2 "Checking modified php-fpm.conf"
if ! run "curl -q -4 http://127.0.0.1:${WWW_PORT}/index.php 2>/dev/null | grep memory_limit | grep '17M'"; then
	# Info
	run "netstat -tuln"
	run "curl -4 http://127.0.0.1:${WWW_PORT}/index.php | grep memory_limit" || true
	run "docker ps --no-trunc"
	docker_exec "${name_nginx}" "nginx -t"

	# Show logs
	docker_logs "${name_nginx}" || true
	docker_logs "${name}"       || true

	# Ensure file is available
	docker_exec "${name_nginx}" "ls -la ${DOC_ROOT_CONT}/"
	docker_exec "${name}"       "ls -la ${DOC_ROOT_CONT}/"

	docker_exec "${name_nginx}" "cat ${DOC_ROOT_CONT}/index.php"
	docker_exec "${name}"       "cat ${DOC_ROOT_CONT}/index.php"

	# Nginx configuration
	docker_exec "${name_nginx}" "cat ${CONFIG_CONT}/php.conf"

	# Shutdown
	docker_stop "${name_nginx}" || true
	docker_stop "${name}"       || true
	rm -rf "${DOC_ROOT_HOST}"
	rm -rf "${CONFIG_HOST}"
	rm -rf "${PHP_CNF_HOST}"
	echo "Failed"
	exit 1
fi


# Cleanup
print_h2 "Cleanup"
docker_stop "${name}"
docker_stop "${name_nginx}"
rm -rf "${DOC_ROOT_HOST}"
rm -rf "${CONFIG_HOST}"
rm -rf "${PHP_CNF_HOST}"
