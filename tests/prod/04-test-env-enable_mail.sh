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
### Postfix
###
MOUNTPOINT="$( mktemp --directory )"

print_h2 "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=$(id -u) -e NEW_GID=$(id -g) -e ENABLE_MAIL=2 -v ${MOUNTPOINT}:/var/mail"
if ! name="$( docker_run "${IMAGE}:${TAG}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=$(id -u) -e NEW_GID=$(id -g) -e ENABLE_MAIL=2 -v ${MOUNTPOINT}:/var/mail" )"; then
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

# Start Tests
print_h2 "Testing..."
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
print_h2 "Send test email"
docker_exec "${name}" "php -r \"mail('mailtest@devilbox.org', 'the subject', 'the message');\""


# Probe if email has been received
print_h2 "Probe for sent email"
RETRIES=60
INDEX=0
while ! run "grep 'the subject' ${MOUNTPOINT}/devilbox"; do
	if [ "${RETRIES}" = "${INDEX}" ]; then
		docker_logs "${name}" || true
		docker_stop "${name}" || true
		run "cat ${MOUNTPOINT}/devilbox"
		rm -rf "${MOUNTPOINT}"
		echo "Failed"
		exit 1
	fi
	INDEX="$(( INDEX + 1 ))"
	sleep 1
done


# Cleanup
print_h2 "Cleanup"
docker_stop "${name}"
rm -rf "${MOUNTPOINT}"
