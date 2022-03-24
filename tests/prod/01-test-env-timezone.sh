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
### Europe/Berlin
###
print_h2 "-e DEBUG_ENTRYPOINT=2 -e TIMEZONE=Europe/Berlin"
if ! name="$( docker_run "${IMAGE}:${TAG}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e TIMEZONE=Europe/Berlin" )"; then
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
if ! run "docker logs ${name} 2>&1 | grep -q 'Europe/Berlin'"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	echo "Failed"
	exit 1
fi
if ! docker_exec "${name}" "date | grep -E 'CE(S)*T'"; then
	docker_exec "${name}" "date"
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	echo "Failed"
	exit 1
fi
if ! docker_exec "${name}" "php -i | grep -E 'date\.timezone' | grep 'Europe/Berlin'"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${name}"
