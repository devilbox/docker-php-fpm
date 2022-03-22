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
### Socat forwarding
###
CONTAINER="mysql:5.6"

# Pull Container
run "until docker pull --platform ${ARCH} ${CONTAINER}; do sleep 1; done"

# Start mysql container
mdid="$( docker_run "${CONTAINER}" "${ARCH}" "-e MYSQL_ALLOW_EMPTY_PASSWORD=yes" )"
mname="$( docker_name "${mdid}" )"
run "sleep 5"

did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e FORWARD_PORTS_TO_LOCALHOST=3306:${mname}:3306 --link ${mname}" )"
if ! run "docker logs ${did} 2>&1 | grep 'Forwarding ${mname}:3306'"; then
	docker_logs "${did}"  || true
	docker_logs "${mdid}" || true
	docker_stop "${did}"  || true
	docker_stop "${mdid}" || true
	echo "Failed"
	exit 1
fi

# Wait for both containers to come up
run "sleep 10"

# Test connectivity
#docker_exec "${did}" "ping -c 1 ${mname}"
#docker_exec "${did}" "echo | nc -w 1 ${mname} 3306"
#docker_exec "${did}" "echo | nc -w 1 127.0.0.1 3306"

# Only work container has mysql binary installed
if [ "${FLAVOUR}" = "work" ]; then
	if ! docker_exec "${did}" "mysql --user=root --password= --host=${mname} -e 'SHOW DATABASES;'"; then
		docker_logs "${did}"  || true
		docker_logs "${mdid}" || true
		docker_stop "${did}"  || true
		docker_stop "${mdid}" || true
		echo "Failed"
		exit 1
	fi
	if ! docker_exec "${did}" "mysql --user=root --password= --host=127.0.0.1 -e 'SHOW DATABASES;'"; then
		docker_logs "${did}"  || true
		docker_logs "${mdid}" || true
		docker_stop "${did}"  || true
		docker_stop "${mdid}" || true
		echo "Failed"
		exit 1
	fi
fi
docker_stop "${mdid}"
docker_stop "${did}"
