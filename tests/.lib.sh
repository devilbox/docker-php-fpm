#!/usr/bin/env bash

set -e
set -u
set -o pipefail


###
### Run
###
function run() {
	local cmd="${1}"
	local to_stdout=0

	# Output to stdout instead?
	if [ "${#}" -eq "2" ]; then
		to_stdout="${2}"
	fi

	local red="\033[0;31m"
	local green="\033[0;32m"
	local yellow="\033[0;33m"
	local reset="\033[0m"

	if [ "${to_stdout}" -eq "0" ]; then
		printf "${yellow}[%s] ${red}%s \$ ${green}${cmd}${reset}\n" "$(hostname)" "$(whoami)" >&2
	else
		printf "${yellow}[%s] ${red}%s \$ ${green}${cmd}${reset}\n" "$(hostname)" "$(whoami)"
	fi

	if sh -c "${cmd}"; then
		if [ "${to_stdout}" -eq "0" ]; then
			printf "${green}[%s]${reset}\n" "OK" >&2
		else
			printf "${green}[%s]${reset}\n" "OK"
		fi
		return 0
	else
		if [ "${to_stdout}" -eq "0" ]; then
			printf "${red}[%s]${reset}\n" "NO" >&2
		else
			printf "${red}[%s]${reset}\n" "NO"
		fi
		return 1
	fi
}
###
### Run (must fail in order to succeed)
###
function run_fail() {
	local cmd="${1}"
	local to_stdout=0

	# Output to stdout instead?
	if [ "${#}" -eq "2" ]; then
		to_stdout="${2}"
	fi

	local red="\033[0;31m"
	local green="\033[0;32m"
	local yellow="\033[0;33m"
	local reset="\033[0m"

	if [ "${to_stdout}" -eq "0" ]; then
		printf "${yellow}[%s] ${red}%s \$ ${yellow}[NOT] ${green}${cmd}${reset}\n" "$(hostname)" "$(whoami)" >&2
	else
		printf "${yellow}[%s] ${red}%s \$ ${yellow}[NOT] ${green}${cmd}${reset}\n" "$(hostname)" "$(whoami)"
	fi

	if ! sh -c "${cmd}"; then
		if [ "${to_stdout}" -eq "0" ]; then
			printf "${green}[%s]${reset}\n" "OK" >&2
		else
			printf "${green}[%s]${reset}\n" "OK"
		fi
		return 0
	else
		if [ "${to_stdout}" -eq "0" ]; then
			printf "${red}[%s]${reset}\n" "NO" >&2
		else
			printf "${red}[%s]${reset}\n" "NO"
		fi
		return 1
	fi
}


###
### Print H2
###
function print_h2() {
	local text="${1}"

	local red="\033[0;31m"
	local green="\033[0;32m"
	local yellow="\033[0;33m"
	local purple="\033[0;35m"
	local reset="\033[0m"

	echo
	echo
	printf "${purple}%s${reset}\n" "###"
	printf "${purple}%s${reset}\n" "### ${text}"
	printf "${purple}%s${reset}\n" "###"
	echo
}


###
### Get 15 character random word
###
function get_random_name() {
	local chr=(a b c d e f g h i j k l m o p q r s t u v w x y z)
	local len="${#chr[@]}"
	local name=

	for i in {1..15}; do
		rand="$( shuf -i "0-${len}" -n 1 )"
		rand="$(( rand - 1 ))"
		name="${name}${chr[$rand]}"
		i="${i}" # simply to get rid of shellcheck complaints
	done
	echo "${name}"
}


###
### Docker run
###
function docker_run() {
	local image_name="${1}"
	local architecture="${2}"
	shift
	shift

	local args="${*}"

	# Returns docker-id
	>&2 echo  "------------------------------ [STARTING CONTAINER] ------------------------------"
	name="$( get_random_name )"
	run "docker run --rm --platform ${architecture} --name ${name} ${args} ${image_name} &" 1>&2
	run "sleep 15"

	>&2 echo "[CHECK IF RUNNING] docker ps"
	# Check docker ps if running
	if ! run "docker ps | grep '${name}'" 1>&2; then
		docker_stop "${name}"
		>&2 echo "------------------------------ [STARTING CONTAINER] FAILED ------------------------------"
		return 1
	fi
	# Check if we can ls
	>&2 echo "[CHECK IF RUNNING] docker exec"
	if ! run "docker exec $(tty -s && echo "-it" || echo ) ${name} id" 1>&2; then
		docker_stop "${name}"
		>&2 echo "------------------------------ [STARTING CONTAINER] FAILED ------------------------------"
		return 1
	fi
	>&2 echo "------------------------------ [STARTING CONTAINER] OK ------------------------------"
	echo "${name}"
}


###
### Show Docker logs
###
function docker_logs() {
	local name="${1}"

	run "docker logs ${name}"
}


###
### Docker exec
###
function docker_exec() {
	local name="${1}"
	local cmd="${2}"
	shift
	shift
	local args="${*}"

	run "docker exec ${args} $(tty -s && echo '-it' || echo) ${name} ${cmd}"
}


###
### Stop container
###
function docker_stop() {
	local name="${1}"
	# Stop
	run "docker stop  ${name}" || true
	run "docker kill  ${name} || true" 2>/dev/null
	run "docker rm -f ${name} || true" 2>/dev/null
}


###
### Check if PHP-FPM is up and running
###
function check_php_fpm_running() {
	local name="${1}"
	local retries="60"
	local index="0"

	>&2 echo

	# PHP process
	index=0
	>&2 echo "Checking if PHP-FPM process is running..."
	while ! run "docker exec ${name} ps auxwww | grep -E '(php-fpm|php-cgi)'"; do
		>&2 printf "."
		index="$(( index + 1 ))"
		if [ "${index}" = "${retries}" ]; then
			>&2 echo
			run "docker exec ${name} ps auxwww"
			>&2 echo "Failed to find PHP process after ${retries} seconds."
			return 1
		fi
		sleep 1
	done
	>&2 echo

	# Docker logs
	index=0
	>&2 echo "Checking if PHP-FPM shows success in docker logs..."
	while ! run "docker logs ${name} 2>&1 | grep -E 'php-fpm entered RUNNING state|ready to handle connections|fpm is running'"; do
		>&2 printf "."
		index="$(( index + 1 ))"
		if [ "${index}" = "${retries}" ]; then
			>&2 echo
			>&2 echo "Failed to find PHP success in docker logs after ${retries} seconds."
			return 1
		fi
		sleep 1
	done
	>&2 echo

	# Wait some more time for everyting else to settle
	run "sleep 10"


	# Echo newline and return
	return 0
}
