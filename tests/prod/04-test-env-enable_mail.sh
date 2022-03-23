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
### Postfix
###
MOUNTPOINT="$( mktemp --directory )"

print_h2 "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=$(id -u) -e NEW_GID=$(id -g) -e ENABLE_MAIL=2 -v ${MOUNTPOINT}:/var/mail"
if ! name="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=$(id -u) -e NEW_GID=$(id -g) -e ENABLE_MAIL=2 -v ${MOUNTPOINT}:/var/mail" )"; then
	exit 1
fi
run "sleep 10"

if ! run "docker logs ${name} 2>&1 | grep -q 'ENABLE_MAIL'"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	rm -rf "${MOUNTPOINT}"
	echo "Failed"
	exit 1
fi

if [ ! -f "${MOUNTPOINT}/devilbox" ]; then
	echo "Mail file does not exist: ${MOUNTPOINT}/devilbox"
	ls -lap "${MOUNTPOINT}/"
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	rm -rf "${MOUNTPOINT}"
	echo "Failed"
	exit 1
fi
if [ ! -r "${MOUNTPOINT}/devilbox" ]; then
	echo "Mail file is not readable"
	ls -lap "${MOUNTPOINT}/"
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	rm -rf "${MOUNTPOINT}"
	echo "Failed"
	exit 1
fi

# Send test email
docker_exec "${name}" "php -r \"mail('mailtest@devilbox.org', 'the subject', 'the message');\""
run "sleep 5"

if ! run "grep 'the subject' ${MOUNTPOINT}/devilbox"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	run "cat ${MOUNTPOINT}/devilbox"
	rm -rf "${MOUNTPOINT}"
	echo "Failed"
	exit 1
fi

docker_stop "${name}"
rm -rf "${MOUNTPOINT}"
