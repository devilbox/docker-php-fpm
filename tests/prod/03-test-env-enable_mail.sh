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
### Postfix
###
MOUNTPOINT="$( mktemp --directory )"
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=$(id -u) -e NEW_GID=$(id -g) -e ENABLE_MAIL=1 -v ${MOUNTPOINT}:/var/mail" )"
run "sleep 10"

if ! run "docker logs ${did} 2>&1 | grep -q 'ENABLE_MAIL'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	rm -rf "${MOUNTPOINT}"
	echo "Failed"
	exit 1
fi

if [ ! -f "${MOUNTPOINT}/devilbox" ]; then
	echo "Mail file does not exist: ${MOUNTPOINT}/devilbox"
	ls -lap ${MOUNTPOINT}/
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	rm -rf "${MOUNTPOINT}"
	echo "Failed"
	exit 1
fi
if [ ! -r "${MOUNTPOINT}/devilbox" ]; then
	echo "Mail file is not readable"
	ls -lap ${MOUNTPOINT}/
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	rm -rf "${MOUNTPOINT}"
	echo "Failed"
	exit 1
fi

# Send test email
docker_exec "${did}" "php -r \"mail('mailtest@devilbox.org', 'the subject', 'the message');\""
run "sleep 5"

if ! run "grep 'the subject' ${MOUNTPOINT}/devilbox"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	run "cat ${MOUNTPOINT}/devilbox"
	rm -rf "${MOUNTPOINT}"
	echo "Failed"
	exit 1
fi

docker_stop "${did}"
rm -rf "${MOUNTPOINT}"
