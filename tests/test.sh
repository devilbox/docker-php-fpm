#!/usr/bin/env bash

###
### Settings
###

# Be strict
set -e
set -u
set -o pipefail

# Loop over newlines instead of spaces
IFS=$'\n'


###
### Variables
###

# Current directory
CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

# Array of tests to run
declare -a BASE_TESTS=()
declare -a MODS_TESTS=()
declare -a PROD_TESTS=()
declare -a WORK_TESTS=()


###
### Source libs
###
# shellcheck disable=SC1090
. "${CWD}/.lib.sh"


###
### Sanity check
###
if [ "${#}" -ne "2" ]; then
	echo "Usage: start.ci <version> <flavour>"
	exit 1
fi


###
### Find test files
###
FILES="$( find ${CWD} -regex "${CWD}/base/[0-9].+.*\.sh" | sort -u )"
for f in ${FILES}; do
	BASE_TESTS+=("${f}")
done

FILES="$( find ${CWD} -regex "${CWD}/mods/[0-9].+.*\.sh" | sort -u )"
for f in ${FILES}; do
	MODS_TESTS+=("${f}")
done

FILES="$( find ${CWD} -regex "${CWD}/prod/[0-9].+.*\.sh" | sort -u )"
for f in ${FILES}; do
	PROD_TESTS+=("${f}")
done

FILES="$( find ${CWD} -regex "${CWD}/work/[0-9].+.*\.sh" | sort -u )"
for f in ${FILES}; do
	WORK_TESTS+=("${f}")
done


###
### Run tests
###
if [ "${2}" = "base" ] || [ "${2}" = "mods" ] || [ "${2}" = "prod" ] || [ "${2}" = "work" ]; then
	for t in "${BASE_TESTS[@]}"; do
		printf "\n\n\033[0;33m%s\033[0m\n" "################################################################################"
		printf "\033[0;33m%s %s\033[0m\n"  "#" "[${1}-${2}]: ${t}"
		printf "\033[0;33m%s\033[0m\n\n"   "################################################################################"
		time ${t} devilbox/php-fpm ${1} ${2}
	done
fi

if [ "${2}" = "mods" ] || [ "${2}" = "prod" ] || [ "${2}" = "work" ]; then
	for t in "${MODS_TESTS[@]}"; do
		printf "\n\n\033[0;33m%s\033[0m\n" "################################################################################"
		printf "\033[0;33m%s %s\033[0m\n"  "#" "[${1}-${2}]: ${t}"
		printf "\033[0;33m%s\033[0m\n\n"   "################################################################################"
		time ${t} devilbox/php-fpm ${1} ${2}
	done
fi

if [ "${2}" = "prod" ] || [ "${2}" = "work" ]; then
	for t in "${PROD_TESTS[@]}"; do
		printf "\n\n\033[0;33m%s\033[0m\n" "################################################################################"
		printf "\033[0;33m%s %s\033[0m\n"  "#" "[${1}-${2}]: ${t}"
		printf "\033[0;33m%s\033[0m\n\n"   "################################################################################"
		time ${t} devilbox/php-fpm ${1} ${2}
	done
fi

if [ "${2}" = "work" ]; then
	for t in "${WORK_TESTS[@]}"; do
		printf "\n\n\033[0;33m%s\033[0m\n" "################################################################################"
		printf "\033[0;33m%s %s\033[0m\n"  "#" "[${1}-${2}]: ${t}"
		printf "\033[0;33m%s\033[0m\n\n"   "################################################################################"
		time ${t} devilbox/php-fpm ${1} ${2}
	done
fi
