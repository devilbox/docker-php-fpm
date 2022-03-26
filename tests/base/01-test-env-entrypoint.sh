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
### Debug == 0
###
print_h2 "DEBUG_ENTRYPOINT=0"
if ! name="$( docker_run "${IMAGE}:${TAG}" "${ARCH}" "-e DEBUG_ENTRYPOINT=0" )"; then
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
if ! run_fail "docker logs ${name} 2>&1 | grep '\[INFO\]'"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	echo "Failed"
	exit 1
fi
if ! run_fail "docker logs ${name} 2>&1 | grep -E '\[(ERR|\?\?\?)\]'"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${name}"


###
### Debug == 1
###
print_h2 "DEBUG_ENTRYPOINT=1"
if ! name="$( docker_run "${IMAGE}:${TAG}" "${ARCH}" "-e DEBUG_ENTRYPOINT=1" )"; then
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
if ! run "docker logs ${name} 2>&1 | grep 'Debug level: 1'"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	echo "Failed"
	exit 1
fi
if ! run "docker logs ${name} 2>&1 | grep '\[INFO\]'"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	echo "Failed"
	exit 1
fi
if ! run_fail "docker logs ${name} 2>&1 | grep -E '\[(ERR|\?\?\?)\]'"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${name}"


###
### Debug == 2
###
print_h2 "DEBUG_ENTRYPOINT=2"
if ! name="$( docker_run "${IMAGE}:${TAG}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2" )"; then
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
if ! run "docker logs ${name} 2>&1 | grep 'Debug level: 2'"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	echo "Failed"
	exit 1
fi
if ! run "docker logs ${name} 2>&1 | grep '\[INFO\]'"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	echo "Failed"
	exit 1
fi
if ! run_fail "docker logs ${name} 2>&1 | grep -E '\[(ERR|\?\?\?)\]'"; then
	docker_logs "${name}" || true
	docker_stop "${name}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${name}"
