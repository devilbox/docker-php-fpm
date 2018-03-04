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
### Run tests
###
if [ "${2}" = "base" ] || [ "${2}" = "mods" ] || [ "${2}" = "prod" ] || [ "${2}" = "work" ]; then
	TESTS="$( find ${CWD} -regex "${CWD}/base/[0-9].+.*\.sh" | sort -u )"
	for t in ${TESTS}; do
		printf "\n\n\033[0;33m%s\033[0m\n" "################################################################################"
		printf "\033[0;33m%s %s\033[0m\n"  "#" "[${1}-${2}]: ${t}"
		printf "\033[0;33m%s\033[0m\n\n"   "################################################################################"
		time ${t} devilbox/php-fpm ${1} ${2}
	done
fi

if [ "${2}" = "mods" ] || [ "${2}" = "prod" ] || [ "${2}" = "work" ]; then
	TESTS="$( find ${CWD} -regex "${CWD}/mods/[0-9].+.*\.sh" | sort -u )"
	for t in ${TESTS}; do
		printf "\n\n\033[0;33m%s\033[0m\n" "################################################################################"
		printf "\033[0;33m%s %s\033[0m\n"  "#" "[${1}-${2}]: ${t}"
		printf "\033[0;33m%s\033[0m\n\n"   "################################################################################"
		time ${t} devilbox/php-fpm ${1} ${2}
	done
fi

if [ "${2}" = "prod" ] || [ "${2}" = "work" ]; then
	TESTS="$( find ${CWD} -regex "${CWD}/prod/[0-9].+.*\.sh" | sort -u )"
	for t in ${TESTS}; do
		printf "\n\n\033[0;33m%s\033[0m\n" "################################################################################"
		printf "\033[0;33m%s %s\033[0m\n"  "#" "[${1}-${2}]: ${t}"
		printf "\033[0;33m%s\033[0m\n\n"   "################################################################################"
		time ${t} devilbox/php-fpm ${1} ${2}
	done
fi

if [ "${2}" = "work" ]; then
	TESTS="$( find ${CWD} -regex "${CWD}/work/[0-9].+.*\.sh" | sort -u )"
	for t in ${TESTS}; do
		printf "\n\n\033[0;33m%s\033[0m\n" "################################################################################"
		printf "\033[0;33m%s %s\033[0m\n"  "#" "[${1}-${2}]: ${t}"
		printf "\033[0;33m%s\033[0m\n\n"   "################################################################################"
		time ${t} devilbox/php-fpm ${1} ${2}
	done
fi
