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
### Debug == 0
###
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "-e DEBUG_ENTRYPOINT=0" )"
if ! run_fail "docker logs ${did} 2>&1 | grep 'Debug level'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
if ! run_fail "docker logs ${did} 2>&1 | grep '\[INFO\]'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
if ! run_fail "docker logs ${did} 2>&1 | grep -E '\[(ERR|\?\?\?)\]'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${did}"


###
### Debug == 1
###
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "-e DEBUG_ENTRYPOINT=1" )"

if ! run "docker logs ${did} 2>&1 | grep 'Debug level: 1'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
if ! run "docker logs ${did} 2>&1 | grep '\[INFO\]'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
if ! run_fail "docker logs ${did} 2>&1 | grep -E '\[(ERR|\?\?\?)\]'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${did}"


###
### Debug == 2
###
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "-e DEBUG_ENTRYPOINT=2" )"

if ! run "docker logs ${did} 2>&1 | grep 'Debug level: 2'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
if ! run "docker logs ${did} 2>&1 | grep '\[INFO\]'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
if ! run_fail "docker logs ${did} 2>&1 | grep -E '\[(ERR|\?\?\?)\]'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${did}"
