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
### Mysqldump-secure
###
MYSQL_ROOT_PASSWORD="toor"
MOUNTPOINT="$( mktemp --directory )"
CONTAINER="mariadb:10.6"

# Pull Container
print_h2 "Pulling MySQL"
run "until docker pull --platform ${ARCH} ${CONTAINER}; do sleep 1; done"

# Start mysql container
print_h2 "Starting MySQL"
if ! name_mysql="$( docker_run "${CONTAINER}" "${ARCH}" "-e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}" )"; then
	exit 1
fi
run "sleep 60"

# Start PHP-FPM container
print_h2 "Start PHP-FPM"
if ! name="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=$(id -u) -e NEW_GID=$(id -g) -e FORWARD_PORTS_TO_LOCALHOST=3306:${name_mysql}:3306 -e MYSQL_BACKUP_USER=root -e MYSQL_BACKUP_PASS=${MYSQL_ROOT_PASSWORD} -e MYSQL_BACKUP_HOST=127.0.0.1 -v ${MOUNTPOINT}:/shared/backups --link ${name_mysql}" )"; then
	docker_stop "${name_mysql}"  || true
	exit 1
fi
run "sleep 15"


print_h2 "Run mysqldump-secure"
if ! docker_exec "${name}" mysqldump-secure; then
	docker_logs "${name_mysql}" || true
	docker_logs "${name}"       || true
	docker_stop "${name_mysql}" || true
	docker_stop "${name}"       || true
	rm -rf "${MOUNTPOINT}"
	exit 1
fi

print_h2 "Test backup directory"
if ! run "test -d ${MOUNTPOINT}/mysql"; then
	echo "MySQL backup dir does not exist: ${MOUNTPOINT}/mysql"
	ls -lap "${MOUNTPOINT}/"
	docker_logs "${name_mysql}" || true
	docker_logs "${name}"       || true
	docker_stop "${name_mysql}" || true
	docker_stop "${name}"       || true
	rm -rf "${MOUNTPOINT}"
	exit 1
fi

print_h2 "Grep backup files"
if ! run "ls -lap ${MOUNTPOINT}/mysql/ | grep -E 'mysql\.sql\.gz'"; then
	ls -lap "${MOUNTPOINT}/"
	docker_logs "${name_mysql}" || true
	docker_logs "${name}"       || true
	docker_stop "${name_mysql}" || true
	docker_stop "${name}"       || true
	rm -rf "${MOUNTPOINT}"
	exit 1
fi

print_h2 "Grep info files"
if ! run "ls -lap ${MOUNTPOINT}/mysql/ | grep -E 'mysql\.sql\.gz\.info'"; then
	ls -lap "${MOUNTPOINT}/"
	docker_logs "${name_mysql}" || true
	docker_logs "${name}"       || true
	docker_stop "${name_mysql}" || true
	docker_stop "${name}"       || true
	rm -rf "${MOUNTPOINT}"
	exit 1
fi


print_h2 "Cleanup"
docker_stop "${name_mysql}"
docker_stop "${name}"
rm -rf "${MOUNTPOINT}"
