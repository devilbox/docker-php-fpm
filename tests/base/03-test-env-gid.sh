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
### gid: 1005 (new gid)
###
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "-e DEBUG_ENTRYPOINT=2 -e NEW_GID=1005" )"

if ! run "docker logs ${did} 2>&1 | grep -q '1005'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
if ! docker_exec "${did}" "id | grep 'gid=1005'" "--user=devilbox"; then
	docker_logs "${did}"
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${did}"

###
### gid: 1000 (same gid)
###
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "-e DEBUG_ENTRYPOINT=2 -e NEW_GID=1000" )"

if ! run "docker logs ${did} 2>&1 | grep -q '1000'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
if ! docker_exec "${did}" "id | grep 'gid=1000'" "--user=devilbox"; then
	docker_logs "${did}"
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${did}"

###
### gid: 33 (existing gid)
###
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "-e DEBUG_ENTRYPOINT=2 -e NEW_GID=33" )"

if ! run "docker logs ${did} 2>&1 | grep -q '33'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
if ! docker_exec "${did}" "id | grep 'gid=33'" "--user=devilbox"; then
	docker_logs "${did}"
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${did}"
