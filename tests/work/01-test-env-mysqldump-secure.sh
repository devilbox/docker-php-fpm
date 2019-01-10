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
### Mysqldump-secure
###
MYSQL_ROOT_PASSWORD="toor"
MOUNTPOINT="$( mktemp --directory )"
CONTAINER="mysql:5.6"

# Pull Container
run "while ! docker pull ${CONTAINER}; do sleep 1; done"

# Start mysql container
mdid="$( docker_run "${CONTAINER}" "-e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}" )"
mname="$( docker_name "${mdid}" )"
run "sleep 10"

# Start PHP-FPM container
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=$(id -u) -e NEW_GID=$(id -g) -e FORWARD_PORTS_TO_LOCALHOST=3306:${mname}:3306 -e MYSQL_BACKUP_USER=root -e MYSQL_BACKUP_PASS=${MYSQL_ROOT_PASSWORD} -e MYSQL_BACKUP_HOST=127.0.0.1 -v ${MOUNTPOINT}:/shared/backups --link ${mname}" )"

docker_exec "${did}" mysqldump-secure

if [ ! -d "${MOUNTPOINT}/mysql" ]; then
	echo "MySQL backup dir does not exist: ${MOUNTPOINT}/mysql"
	ls -lap ${MOUNTPOINT}/
	docker_logs "${did}"  || true
	docker_logs "${mdid}" || true
	docker_stop "${did}"  || true
	docker_stop "${mdid}" || true
	rm -rf "${MOUNTPOINT}"
	exit 1
fi

run "ls -lap ${MOUNTPOINT}/mysql/ | grep -E 'mysql\.sql\.gz'"
run "ls -lap ${MOUNTPOINT}/mysql/ | grep -E 'mysql\.sql\.gz\.info'"

docker_stop "${did}"
docker_stop "${mdid}"
rm -rf "${MOUNTPOINT}"
