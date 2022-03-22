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
### Ensuring 'apt update' works without any issues
###
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2" )"

if ! docker_exec "${did}" "apt update"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi
docker_stop "${did}"
