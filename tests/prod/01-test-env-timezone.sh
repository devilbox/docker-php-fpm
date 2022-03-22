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
### Europe/Berlin
###
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e TIMEZONE=Europe/Berlin" )"

if ! run "docker logs ${did} 2>&1 | grep -q 'Europe/Berlin'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
if ! docker_exec "${did}" "date | grep -E 'CE(S)*T'"; then
	docker_exec "${did}" "date"
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
if ! docker_exec "${did}" "php -i | grep -E 'date\.timezone' | grep 'Europe/Berlin'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${did}"
