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
### uid: 1005 (new uid)
###
print_h2 "DEBUG_ENTRYPOINT=2 NEW_UID=1005"
if ! name="$( docker_run "${IMAGE}:${TAG}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=1005" )"; then
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
if ! run "docker logs ${name} 2>&1 | grep -q '1005'"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	echo "Failed"
	exit 1
fi
if ! docker_exec "${name}" "id | grep 'uid=1005'" "--user=devilbox"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${name}"


###
### uid: 1000 (same uid)
###
print_h2 "DEBUG_ENTRYPOINT=2 NEW_UID=1000"
if ! name="$( docker_run "${IMAGE}:${TAG}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=1000" )"; then
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
if ! run "docker logs ${name} 2>&1 | grep -q '1000'"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	echo "Failed"
	exit 1
fi
if ! docker_exec "${name}" "id | grep 'uid=1000'" "--user=devilbox"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${name}"


###
### uid: 33 (existing uid)
###
print_h2 "DEBUG_ENTRYPOINT=2 NEW_UID=33"
if ! name="$( docker_run "${IMAGE}:${TAG}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=33" )"; then
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
if ! run "docker logs ${name} 2>&1 | grep -q '33'"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	echo "Failed"
	exit 1
fi
if ! docker_exec "${name}" "id | grep 'uid=33'" "--user=devilbox"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${name}"
