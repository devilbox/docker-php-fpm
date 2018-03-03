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
### Socat forwarding
###

# Start mysql container
mdid="$( docker_run "mysql:5.6" "-e MYSQL_ALLOW_EMPTY_PASSWORD=yes" )"
mname="$( docker_name "${mdid}" )"
run "sleep 5"

did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "-e DEBUG_ENTRYPOINT=2 -e FORWARD_PORTS_TO_LOCALHOST=3306:${mname}:3306 --link ${mname}" )"
if ! run "docker logs ${did} 2>&1 | grep 'Forwarding ${mname}:3306'"; then
	docker_logs "${did}" || true
	docker_stop "${did}" || true
	echo "Failed"
	exit 1
fi

# Test connectivity
docker_exec "${did}" "ping -c 1 ${mname}"
docker_exec "${did}" "echo | nc -w 1 ${mname} 3306"
docker_exec "${did}" "echo | nc -w 1 127.0.0.1 3306"

# Only work container has mysql binary installed
if [ "${FLAVOUR}" = "work" ]; then
	docker_exec "${did}" "mysql --user=root --password= --host=${mname} -e 'SHOW DATABASES;'"
	docker_exec "${did}" "mysql --user=root --password= --host=127.0.0.1 -e 'SHOW DATABASES;'"
fi
docker_stop "${mdid}"
docker_stop "${did}"
