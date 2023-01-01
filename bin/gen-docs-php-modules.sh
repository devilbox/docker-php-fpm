#!/usr/bin/env bash

# Be very strict
set -e
set -u
set -o pipefail

# Get absolute directory of this script
SCRIPT_PATH="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"
SCRIPT_NAME="$(basename "${SCRIPT_PATH}")"
REPO_PATH="${SCRIPT_PATH}/.."

###
### This file is being updated
###
README="${REPO_PATH}/doc/php-modules.md"


#--------------------------------------------------------------------------------------------------
# Evaluate given cli arguments
#--------------------------------------------------------------------------------------------------

###
### Show Usage
###
print_usage() {
	echo "Usage: ${SCRIPT_NAME} <IMAGE> <ARCH> <STAGE> [<VERSION>]"
}

if [ "${#}" -lt "3" ]; then
	print_usage
	exit 1
fi

IMAGE="${1}"
ARCH="${2}"
STAGE="${3}"
VERSION="${4:-}"

if [ "${STAGE}" != "base" ] && [ "${STAGE}" != "mods" ]; then
	echo "[SKIP]: Skipping for STAGE: ${STAGE} (only 'base' and 'mods' supported"
	exit 0
fi


#--------------------------------------------------------------------------------------------------
# Module functions
#--------------------------------------------------------------------------------------------------

###
### Get all modules defined in README
###
get_modules_from_readme() {
	local php_version="${1}"  # PHP version
	local modules
	modules="$( \
		grep -Eo "ext_${STAGE}_.+_${php_version}" "${README}" \
		| sed "s/^ext_${STAGE}_//g" \
		| sed "s/_${php_version}//g" \
	)"
	echo "${modules}" | sort -fu
}


###
### Get modules available in PHP image
###
get_modules_from_image() {
	local php_version="${1}"
	local img_tag="${2}"
	local modules

	modules="$( \
		docker run --rm --platform "${ARCH}" --entrypoint=php "${IMAGE}:${img_tag}" -m \
		| sed 's/Zend //g' \
		| sed 's/xdebug/Xdebug/g' \
		| sed 's/Core//g' \
		| sed 's/standard//g' \
		| grep -E '^[a-zA-Z]' \
		| sort -fu \
	)"

	# Get modules which might be disabled
	if docker run --rm --platform "${ARCH}" --entrypoint=find "${IMAGE}:${img_tag}" /usr/local/lib/php/extensions -name 'ioncube.so' | grep -q ioncube.so; then
		modules="$( printf "%s\n%s\n" "${modules}" "ioncube" )";
	fi

	if docker run --rm --platform "${ARCH}" --entrypoint=find "${IMAGE}:${img_tag}" /usr/local/lib/php/extensions -name 'blackfire.so' | grep -q blackfire.so; then
		modules="$( printf "%s\n%s\n" "${modules}" "blackfire" )";
	fi

	if docker run --rm --platform "${ARCH}" --entrypoint=find "${IMAGE}:${img_tag}" /usr/local/lib/php/extensions -name 'psr.so' | grep -q psr.so; then
		modules="$( printf "%s\n%s\n" "${modules}" "psr" )";
	fi

	if docker run --rm --platform "${ARCH}" --entrypoint=find "${IMAGE}:${img_tag}" /usr/local/lib/php/extensions -name 'phalcon.so' | grep -q phalcon.so; then
		modules="$( printf "%s\n%s\n" "${modules}" "phalcon" )";
	fi

	if docker run --rm --platform "${ARCH}" --entrypoint=find "${IMAGE}:${img_tag}" /usr/local/lib/php/extensions -name 'xhprof.so' | grep -q xhprof.so; then
		modules="$( printf "%s\n%s\n" "${modules}" "xhprof" )";
	fi

	# Sort alphabetically
	modules="$( echo "${modules}" | sort -fu )"

	# Remove weired line endings
	while read -r line; do
		echo "${line}" | tr -d '\r' | tr -d '\n'
		echo
	done < <(echo "${modules}")
}


###
### Validate that *.md file has all modules defined that are found in the PHP docker image
###
validate_readme() {
	local php_version="${1}"
	local modules_img="${2}"  # Modules found in the PHP docker image
	local stage="${3}"        # base or mods

	# Check if *.md contains all modules we have retrieved from the PHP image
	while read -r line; do
		module="$( echo "${line}" | tr '[:upper:]' '[:lower:]' )"
		search="ext_${stage}_${module}_${php_version}"
		if ! grep -q "${search}" "${README}"; then
			echo "[ERROR] Module: '${module}' not present in ${README} for PHP ${php_version}, STAGE: ${stage}"
			echo "grep -q \"${search}\" \"${README}\""
			exit 1
		fi
	done < <(echo "${modules_img}")
}


###
### Update *.md for a specific PHP version
###
update_readme() {
	local php_version="${1}"
	local modules_image="${2}"
	local modules_avail="${3}"
	local stage="${4}"         # base or mods

	while read -r line_avail; do
		module_avail="$( echo "${line_avail}" | tr '[:upper:]' '[:lower:]' )"

		avail=0
		while read -r line_image; do
			module_image="$( echo "${line_image}" | tr '[:upper:]' '[:lower:]' )"
			if [ "${module_image}" = "${module_avail}" ]; then
				avail=1
				break
			fi
		done < <(echo "${modules_image}")

		if [ "${avail}" = "1" ]; then
			sed -i "s|\(<td class=\"ext_${stage}_${module_avail}_${php_version}\">\)\(.*\)\(<\/td>\)|\1✓\3|g" "${README}"
			echo "[YES] [${stage}] PHP ${php_version}, mod: '${module_avail}'"
		else
			sed -i "s|\(<td class=\"ext_${stage}_${module_avail}_${php_version}\">\)\(.*\)\(<\/td>\)|\1\3|g" "${README}"
			echo "[NO]  [${stage}] PHP ${php_version}, mod: '${module_avail}'"
		fi
	done < <(echo "${modules_avail}")
}


# The following commented code is used to generate the README initially
#echo "<table>"
#echo " <tr>"
#echo "   <th>Ext</th>"
#echo "   <th>PHP 5.2</th>"
#echo "   <th>PHP 5.3</th>"
#echo "   <th>PHP 5.4</th>"
#echo "   <th>PHP 5.5</th>"
#echo "   <th>PHP 5.6</th>"
#echo "   <th>PHP 7.0</th>"
#echo "   <th>PHP 7.1</th>"
#echo "   <th>PHP 7.2</th>"
#echo "   <th>PHP 7.3</th>"
#echo "   <th>PHP 7.4</th>"
#echo "   <th>PHP 8.0</th>"
#echo "   <th>PHP 8.1</th>"
#echo "   <th>PHP 8.2</th>"
#echo " </tr>"
#
#while read -r line; do
#	MOD_NAME="$( echo "${line}" )"
#	MOD_LOWER="$( echo "${MOD_NAME}" | tr '[:upper:]' '[:lower:]' )"
#	echo " <tr>"
#	echo "  <td><a href=\"php_modules/${MOD_LOWER}\">${MOD_NAME}</a></td>"
#	echo "  <td class=\"ext_mods_${MOD_LOWER}_5.2\">✓</td>"
#	echo "  <td class=\"ext_mods_${MOD_LOWER}_5.3\">✓</td>"
#	echo "  <td class=\"ext_mods_${MOD_LOWER}_5.4\">✓</td>"
#	echo "  <td class=\"ext_mods_${MOD_LOWER}_5.5\">✓</td>"
#	echo "  <td class=\"ext_mods_${MOD_LOWER}_5.6\">✓</td>"
#	echo "  <td class=\"ext_mods_${MOD_LOWER}_7.0\">✓</td>"
#	echo "  <td class=\"ext_mods_${MOD_LOWER}_7.1\">✓</td>"
#	echo "  <td class=\"ext_mods_${MOD_LOWER}_7.2\">✓</td>"
#	echo "  <td class=\"ext_mods_${MOD_LOWER}_7.3\">✓</td>"
#	echo "  <td class=\"ext_mods_${MOD_LOWER}_7.4\">✓</td>"
#	echo "  <td class=\"ext_mods_${MOD_LOWER}_8.0\">✓</td>"
#	echo "  <td class=\"ext_mods_${MOD_LOWER}_8.1\">✓</td>"
#	echo "  <td class=\"ext_mods_${MOD_LOWER}_8.2\">✓</td>"
#	echo " </tr>"
#done < <(echo "${MODS_IMAGE}")
#echo "<table>"
#exit


#--------------------------------------------------------------------------------------------------
# Main functions
#--------------------------------------------------------------------------------------------------

###
### Replace module available in README for a specific PHP version
###
update() {
	local php_version="${1}"
	local mods_in_readme
	local mods_in_image

	mods_in_readme="$( get_modules_from_readme "${php_version}" )"

	mods_in_image="$( get_modules_from_image "${php_version}" "${php_version}-${STAGE}" )"

	validate_readme "${php_version}" "${mods_in_image}" "${STAGE}"
	update_readme "${php_version}" "${mods_in_image}" "${mods_in_readme}" "${STAGE}"
}


#--------------------------------------------------------------------------------------------------
# Entrypoint
#--------------------------------------------------------------------------------------------------

###
### Entrypoint
###
if [ "${VERSION}" = "" ]; then
	# Update PHP modules for all versions at once
	update "5.2"
	update "5.3"
	update "5.4"
	update "5.5"
	update "5.6"
	update "7.0"
	update "7.1"
	update "7.2"
	update "7.3"
	update "7.4"
	update "8.0"
	update "8.1"
	update "8.2"
else
	if [ "${VERSION}" != "5.2" ] \
	&& [ "${VERSION}" != "5.3" ] \
	&& [ "${VERSION}" != "5.4" ] \
	&& [ "${VERSION}" != "5.5" ] \
	&& [ "${VERSION}" != "5.6" ] \
	&& [ "${VERSION}" != "7.0" ] \
	&& [ "${VERSION}" != "7.1" ] \
	&& [ "${VERSION}" != "7.2" ] \
	&& [ "${VERSION}" != "7.3" ] \
	&& [ "${VERSION}" != "7.4" ] \
	&& [ "${VERSION}" != "8.0" ] \
	&& [ "${VERSION}" != "8.1" ] \
	&& [ "${VERSION}" != "8.2" ]; then
		# Argument does not match any of the PHP versions
		echo "Error, invalid argument."
		print_usage
		exit 1
	else
		# Update PHP modules for one specific PHP version
		update "${VERSION}"
	fi
fi
