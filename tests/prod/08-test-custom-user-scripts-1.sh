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
### Check if PHP still starts up with working scripts
###
RUN_SH_HOST="$( mktemp -d )"
RUN_SH_CONT="/startup.1.d"

# Fix mount permissions
chmod 0777 "${RUN_SH_HOST}"

# Add a startup script to execute
printf "#!/bin/bash\\necho 'abcdefghijklmnopq';\\n" > "${RUN_SH_HOST}/myscript1.sh"
chmod +x "${RUN_SH_HOST}/myscript1.sh"

# Start PHP-FPM
did="$( docker_run "${IMAGE}:${VERSION}-${FLAVOUR}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=$(id -u) -e NEW_GID=$(id -g) -v ${RUN_SH_HOST}:${RUN_SH_CONT}" )"

# Wait for both containers to be up and running
run "sleep 10"

# Check entrypoint for script run
if ! run "docker logs ${did} | grep 'myscript1.sh'"; then
	docker_logs "${did}"  || true
	docker_stop "${did}"  || true
	rm -rf "${RUN_SH_HOST}"
	echo "Failed"
	exit 1
fi

# Check entrypoint for script output
if ! run "docker logs ${did} | grep 'abcdefghijklmnopq'"; then
	docker_logs "${did}"  || true
	docker_stop "${did}"  || true
	rm -rf "${RUN_SH_HOST}"
	echo "Failed"
	exit 1
fi


# Cleanup
docker_stop "${did}"
rm -rf "${RUN_SH_HOST}"
