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


# -------------------------------------------------------------------------------------------------
# Testing
# -------------------------------------------------------------------------------------------------

ERROR=0
for dir in $( ls -1 "${CWD}/modules/" ); do
	if ! "${CWD}/modules.sh" "${IMAGE}" "${VERSION}" "${FLAVOUR}" "${dir}"; then
		ERROR="$(( ERROR + 1 ))"
	fi
done

exit "${ERROR}"
