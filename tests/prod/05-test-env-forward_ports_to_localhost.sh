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
### Socat forwarding
###
CONTAINER="devilbox/mysql:mysql-8.0"

# Pull Container
print_h2 "Pulling MySQL"
run "until docker pull --platform ${ARCH} ${CONTAINER}; do sleep 1; done"

# Start mysql container
print_h2 "Starting MySQL"
if ! name_mysql="$( docker_run "${CONTAINER}" "${ARCH}" "-e MYSQL_ALLOW_EMPTY_PASSWORD=yes" )"; then
	exit 1
fi
run "sleep 60"


# Start PHP-FPM
print_h2 "Start PHP-FPM"
if ! name="$( docker_run "${IMAGE}:${TAG}" "${ARCH}" "-e DEBUG_ENTRYPOINT=2 -e FORWARD_PORTS_TO_LOCALHOST=3306:${name_mysql}:3306 --link ${name_mysql}" )"; then
	docker_stop "${name_mysql}"  || true
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

print_h2 "Ensure forwarding info is present in docker logs"
if ! run "docker logs ${name} 2>&1 | grep 'Forwarding ${name_mysql}:3306'"; then
	docker_logs "${name_mysql}"  || true
	docker_logs "${name}"        || true
	docker_stop "${name_mysql}"  || true
	docker_stop "${name}"        || true
	echo "Failed"
	exit 1
fi


# Only work container has mysql binary installed
if [ "${FLAVOUR}" = "work" ]; then
	print_h2 "Test connectivity against hostname"
	if ! docker_exec "${name}" "mysql --user=root --password= --host=${name_mysql} -e 'SHOW DATABASES;'"; then
		docker_logs "${name_mysql}"  || true
		docker_logs "${name}"        || true
		docker_stop "${name_mysql}"  || true
		docker_stop "${name}"        || true
		echo "Failed"
		exit 1
	fi
	print_h2 "Test connectivity against 127.0.0.1"
	if ! docker_exec "${name}" "mysql --user=root --password= --host=127.0.0.1 -e 'SHOW DATABASES;'"; then
		docker_logs "${name_mysql}"  || true
		docker_logs "${name}"        || true
		docker_stop "${name_mysql}"  || true
		docker_stop "${name}"        || true
		echo "Failed"
		exit 1
	fi
fi


print_h2 "Cleanup"
docker_stop "${name_mysql}"
docker_stop "${name}"
