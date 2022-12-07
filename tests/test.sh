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
if [ "${#}" -ne "5" ]; then
	echo "Usage: start.ci <image> <arch> <version> <flavour> <tag>"
	exit 1
fi

IMAGE="${1}"
ARCH="${2}"
VERSION="${3}"
FLAVOUR="${4}"
TAG="${5}"


###
### Run tests
###
if [ "${FLAVOUR}" = "base" ] || [ "${FLAVOUR}" = "mods" ] || [ "${FLAVOUR}" = "prod" ] || [ "${FLAVOUR}" = "slim" ] || [ "${FLAVOUR}" = "work" ]; then
	TESTS="$( find "${CWD}" -regex "${CWD}/base/[0-9].+.*\.sh" | sort -u )"
	for t in ${TESTS}; do
		printf "\n\n\033[0;33m%s\033[0m\n" "################################################################################"
		printf "\033[0;33m%s %s\033[0m\n"  "#" "[${VERSION}-${FLAVOUR}] (${ARCH})"
		printf "\033[0;33m%s %s\033[0m\n"  "#" "${t} ${IMAGE} ${ARCH} ${VERSION} ${FLAVOUR} ${TAG}"
		printf "\033[0;33m%s\033[0m\n\n"   "################################################################################"
		time ${t} "${IMAGE}" "${ARCH}" "${VERSION}" "${FLAVOUR}" "${TAG}"
	done
fi

if [ "${FLAVOUR}" = "mods" ] || [ "${FLAVOUR}" = "prod" ] || [ "${FLAVOUR}" = "slim" ] || [ "${FLAVOUR}" = "work" ]; then
	TESTS="$( find "${CWD}" -regex "${CWD}/mods/[0-9].+.*\.sh" | sort -u )"
	for t in ${TESTS}; do
		printf "\n\n\033[0;33m%s\033[0m\n" "################################################################################"
		printf "\033[0;33m%s %s\033[0m\n"  "#" "[${VERSION}-${FLAVOUR}] (${ARCH})"
		printf "\033[0;33m%s %s\033[0m\n"  "#" "${t} ${IMAGE} ${ARCH} ${VERSION} ${FLAVOUR} ${TAG}"
		printf "\033[0;33m%s\033[0m\n\n"   "################################################################################"
		time ${t} "${IMAGE}" "${ARCH}" "${VERSION}" "${FLAVOUR}" "${TAG}"
	done
fi

if [ "${FLAVOUR}" = "prod" ] || [ "${FLAVOUR}" = "slim" ] || [ "${FLAVOUR}" = "work" ]; then
	TESTS="$( find "${CWD}" -regex "${CWD}/prod/[0-9].+.*\.sh" | sort -u )"
	for t in ${TESTS}; do
		printf "\n\n\033[0;33m%s\033[0m\n" "################################################################################"
		printf "\033[0;33m%s %s\033[0m\n"  "#" "[${VERSION}-${FLAVOUR}] (${ARCH})"
		printf "\033[0;33m%s %s\033[0m\n"  "#" "${t} ${IMAGE} ${ARCH} ${VERSION} ${FLAVOUR} ${TAG}"
		printf "\033[0;33m%s\033[0m\n\n"   "################################################################################"
		time ${t} "${IMAGE}" "${ARCH}" "${VERSION}" "${FLAVOUR}" "${TAG}"
	done
fi

if [ "${FLAVOUR}" = "slim" ] || [ "${FLAVOUR}" = "work" ]; then
	TESTS="$( find "${CWD}" -regex "${CWD}/slim/[0-9].+.*\.sh" | sort -u )"
	for t in ${TESTS}; do
		printf "\n\n\033[0;33m%s\033[0m\n" "################################################################################"
		printf "\033[0;33m%s %s\033[0m\n"  "#" "[${VERSION}-${FLAVOUR}] (${ARCH})"
		printf "\033[0;33m%s %s\033[0m\n"  "#" "${t} ${IMAGE} ${ARCH} ${VERSION} ${FLAVOUR} ${TAG}"
		printf "\033[0;33m%s\033[0m\n\n"   "################################################################################"
		time ${t} "${IMAGE}" "${ARCH}" "${VERSION}" "${FLAVOUR}" "${TAG}"
	done
fi
