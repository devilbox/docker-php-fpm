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


# -------------------------------------------------------------------------------------------------
# Testing
# -------------------------------------------------------------------------------------------------

ERROR=0
for dir in $( ls -1 "${CWD}/modules/" ); do
	if ! "${CWD}/modules.sh" "${IMAGE}" "${ARCH}" "${VERSION}" "${FLAVOUR}" "${TAG}" "${dir}"; then
		ERROR="$(( ERROR + 1 ))"
	fi
done

exit "${ERROR}"
