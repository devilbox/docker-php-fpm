#!/usr/bin/env bash

set -e
set -u
set -o pipefail

CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

IMAGE="${1}"
VERSION="${2}"
FLAVOUR="${3}"

# shellcheck disable=SC1090
. "${CWD}/../.lib.sh"



############################################################
# Tests
############################################################

###
### Test Nginx with PHP-FPM
###
WWW_PORT="12345"
DOC_ROOT_HOST="$( mktemp -d )"
DOC_ROOT_CONT="/var/www/default"

CONFIG_HOST="$( mktemp -d )"
CONFIG_CONT="/etc/nginx/conf.d"

CONTAINER="nginx:stable"

FINDME="am_i_really_working"
echo "${FINDME}" > "${DOC_ROOT_HOST}/index.php"

# Pull Image
run "docker pull ${CONTAINER}"

# Start PHP-FPM
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "-e DEBUG_ENTRYPOINT=2 -v ${DOC_ROOT_HOST}:${DOC_ROOT_CONT}" )"
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
ndid="$( docker_run "${CONTAINER}" "-v ${DOC_ROOT_HOST}:${DOC_ROOT_CONT} -v ${CONFIG_HOST}:${CONFIG_CONT} -p ${WWW_PORT}:80 --link ${name}" )"

# Check PHP connectivity
if ! run "curl -q 127.0.0.1:${WWW_PORT}/index.php 2>&1 | grep '${FINDME}'"; then
	docker_logs "${ndid}" || true
	docker_logs "${did}"  || true
	docker_stop "${ndid}" || true
	docker_stop "${did}"  || true
	rm -rf "${DOC_ROOT_HOST}"
	rm -rf "${CONFIG_HOST}"
	echo "Failed"
	exit 1
fi

# Cleanup
docker_stop "${did}"
docker_stop "${ndid}"
rm -rf "${DOC_ROOT_HOST}"
rm -rf "${CONFIG_HOST}"
