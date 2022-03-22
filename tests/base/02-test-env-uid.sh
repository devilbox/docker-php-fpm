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
### uid: 1005 (new uid)
###
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=1005" )"

if ! run "docker logs ${did} 2>&1 | grep -q '1005'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
if ! docker_exec "${did}" "id | grep 'uid=1005'" "--user=devilbox"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${did}"


###
### uid: 1000 (same uid)
###
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=1000" )"

if ! run "docker logs ${did} 2>&1 | grep -q '1000'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
if ! docker_exec "${did}" "id | grep 'uid=1000'" "--user=devilbox"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${did}"


###
### uid: 33 (existing uid)
###
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=33" )"

if ! run "docker logs ${did} 2>&1 | grep -q '33'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
if ! docker_exec "${did}" "id | grep 'uid=33'" "--user=devilbox"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${did}"
