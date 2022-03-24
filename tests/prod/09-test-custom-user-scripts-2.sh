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
### Check if PHP still starts up with working scripts
###
RUN_SH_HOST="$( mktemp -d )"
RUN_SH_CONT="/startup.2.d"

# Fix mount permissions
chmod 0777 "${RUN_SH_HOST}"

# Add a startup script to execute
printf "#!/bin/bash\\necho 'abcdefghijklmnopq';\\n" > "${RUN_SH_HOST}/myscript1.sh"
chmod +x "${RUN_SH_HOST}/myscript1.sh"

# Start PHP-FPM
print_h2 "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=$(id -u) -e NEW_GID=$(id -g) -v ${RUN_SH_HOST}:${RUN_SH_CONT}"
if ! name="$( docker_run "${IMAGE}:${TAG}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e NEW_UID=$(id -u) -e NEW_GID=$(id -g) -v ${RUN_SH_HOST}:${RUN_SH_CONT}" )"; then
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

# Check entrypoint for script run
print_h2 "Check docker logs for script run"
if ! run "docker logs ${name} | grep 'myscript1.sh'"; then
	docker_logs "${name}"  || true
	docker_stop "${name}"  || true
	rm -rf "${RUN_SH_HOST}"
	echo "Failed"
	exit 1
fi

# Check entrypoint for script output
print_h2 "Check docker logs for script output"
if ! run "docker logs ${name} | grep 'abcdefghijklmnopq'"; then
	docker_logs "${name}"  || true
	docker_stop "${name}"  || true
	rm -rf "${RUN_SH_HOST}"
	echo "Failed"
	exit 1
fi


# Cleanup
print_h2 "Cleanup"
docker_stop "${name}"
rm -rf "${RUN_SH_HOST}"
