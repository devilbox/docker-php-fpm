#!/usr/bin/env bash

set -e
set -u
set -o pipefail

CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

if [ "${#}" != "4" ]; then
	>&2 echo "Error, requires 4 arguments: <IMAGE> <VERSION> <FLAVOUR> <MODULE>"
	exit 1
fi

IMAGE="${1}"
VERSION="${2}"
FLAVOUR="${3}"
MODULE="${4}"

# shellcheck disable=SC1090
. "${CWD}/../.lib.sh"


SKIP_GD=("")


echo
echo "# ------------------------------------------------------------"
echo "# Testing: ${MODULE}"
echo "# ------------------------------------------------------------"
echo


# -------------------------------------------------------------------------------------------------
# Check skipping
# -------------------------------------------------------------------------------------------------

if [[ ${SKIP_GD[*]} =~ ${VERSION} ]]; then
	echo "Skipping '${MODULE}' checks for PHP ${VERSION}"
	exit 0
fi


# -------------------------------------------------------------------------------------------------
# Testing
# -------------------------------------------------------------------------------------------------

WORKDIR="/tmp/${MODULE}"
docker run \
	--rm \
	-e DEBUG_ENTRYPOINT=0 \
	-e NEW_UID="$(id -u)" \
	-e NEW_GID="$(id -g)" \
	-v "${CWD}/modules/${MODULE}:${WORKDIR}" \
	--entrypoint=sh \
	--workdir="${WORKDIR}" \
	"${IMAGE}:${VERSION}-${FLAVOUR}" \
	-c 'find . -name "*.php" -type f -print0 | xargs -0 -n1 sh -c "
		set -e
		set -u
		if [ -f \"\${1:-}\" ]; then
			fail=0
			printf \"[TEST] %s\" \"\${1}\"

			if script -e -c \"php \${1}\" /dev/null 2>&1 | grep -Ei \"core|segmentation|fatal|except|err|warn|notice\" 2>&1 >/dev/null; then
				fail=1
			fi
			if ! php \"\${1}\" 2>&1 | grep -E \"^OK$\" 2>&1 >/dev/null; then
				fail=1
			fi

			if [ \"\${fail}\" != \"0\" ]; then
				printf \"\\r[FAIL] %s\\n\" \"\${1}\"
				php \"\${1}\" || true
				exit 1
			else
				printf \"\\r[OK]   %s\\n\" \"\${1}\"
			fi
		fi

	" --'
