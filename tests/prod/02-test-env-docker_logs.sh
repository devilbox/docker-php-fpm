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
### Docker logs
###
MOUNTPOINT="$( mktemp --directory )"
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=$(id -u) -e NEW_GID=$(id -g) -e DOCKER_LOGS=1 -v ${MOUNTPOINT}:/var/log/php" )"
run "sleep 10"

if ! run "docker logs ${did} 2>&1 | grep -q 'DOCKER_LOGS'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	rm -rf "${MOUNTPOINT}"
	echo "Failed"
	exit 1
fi

if [ -f "${MOUNTPOINT}/php-fpm.access" ]; then
	echo "Access log should not exist: ${MOUNTPOINT}/php-fpm.access"
	ls -lap ${MOUNTPOINT}/
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	rm -rf "${MOUNTPOINT}"
	echo "Failed"
	exit 1
fi
if [ -f "${MOUNTPOINT}/php-fpm.error" ]; then
	echo "Error log should not exist: ${MOUNTPOINT}/php-fpm.error"
	ls -lap ${MOUNTPOINT}/
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	rm -rf "${MOUNTPOINT}"
	echo "Failed"
	exit 1
fi

run "ls -lap ${MOUNTPOINT}/"
docker_stop "${did}"
rm -rf "${MOUNTPOINT}"


###
### Log to file
###
MOUNTPOINT="$( mktemp --directory )"
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=$(id -u) -e NEW_GID=$(id -g) -e DOCKER_LOGS=0 -v ${MOUNTPOINT}:/var/log/php" )"
run "sleep 10"

if ! run "docker logs ${did} 2>&1 | grep -q 'DOCKER_LOGS'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	rm -rf "${MOUNTPOINT}"
	echo "Failed"
	exit 1
fi

if [ ! -f "${MOUNTPOINT}/php-fpm.access" ]; then
	echo "Access log does not exist: ${MOUNTPOINT}/php-fpm.access"
	ls -lap ${MOUNTPOINT}/
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	rm -rf "${MOUNTPOINT}"
	echo "Failed"
	exit 1
fi
if [ ! -r "${MOUNTPOINT}/php-fpm.access" ]; then
	echo "Access log is not readable"
	ls -lap ${MOUNTPOINT}/
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	rm -rf "${MOUNTPOINT}"
	echo "Failed"
	exit 1
fi

if [ ! -f "${MOUNTPOINT}/php-fpm.error" ]; then
	echo "Error log does not exist: ${MOUNTPOINT}/php-fpm.error"
	ls -lap ${MOUNTPOINT}/
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	rm -rf "${MOUNTPOINT}"
	echo "Failed"
	exit 1
fi
if [ ! -r "${MOUNTPOINT}/php-fpm.error" ]; then
	echo "Error log is not readable"
	ls -lap ${MOUNTPOINT}/
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	rm -rf "${MOUNTPOINT}"
	echo "Failed"
	exit 1
fi

run "ls -lap ${MOUNTPOINT}/"
run "cat ${MOUNTPOINT}/*"
docker_stop "${did}"
rm -rf "${MOUNTPOINT}"
