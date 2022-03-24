#!/usr/bin/env bash

# Be very strict
set -e
set -u
set -o pipefail

# Get absolute directory of this script
CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

IMAGE="${1}"
ARCH="${2}"
TAG_BASE="${3}"
TAG_MODS="${4}"
VERSION="${5:-}"


###
### Show Usage
###
print_usage() {
	echo "Usage: gen-readme.sh <IMAGE> <ARCH> <TAG_BASE> <TAG_MODS> [<VERSION>]"
}


###
### Extract PHP modules in alphabetical order and comma separated in one line
###
get_modules() {
	current_tag="${1}"
	# Retrieve all modules
	PHP_MODULES="$( docker run --rm --platform "${ARCH}" "$(tty -s && echo '-it' || echo)" --entrypoint=php "${IMAGE}:${current_tag}" -m )"
	ALL_MODULES=

	if docker run --rm --platform "${ARCH}" "$(tty -s && echo '-it' || echo)" --entrypoint=find "${IMAGE}:${current_tag}" /usr/local/lib/php/extensions -name 'ioncube.so' | grep -q ioncube.so; then
		ALL_MODULES="${ALL_MODULES},ioncube";
	fi

	if docker run --rm --platform "${ARCH}" "$(tty -s && echo '-it' || echo)" --entrypoint=find "${IMAGE}:${current_tag}" /usr/local/lib/php/extensions -name 'blackfire.so' | grep -q blackfire.so; then
		ALL_MODULES="${ALL_MODULES},blackfire";
	fi

	if docker run --rm --platform "${ARCH}" "$(tty -s && echo '-it' || echo)" --entrypoint=find "${IMAGE}:${current_tag}" /usr/local/lib/php/extensions -name 'psr.so' | grep -q psr.so; then
		ALL_MODULES="${ALL_MODULES},psr";
	fi

	if docker run --rm --platform "${ARCH}" "$(tty -s && echo '-it' || echo)" --entrypoint=find "${IMAGE}:${current_tag}" /usr/local/lib/php/extensions -name 'phalcon.so' | grep -q phalcon.so; then
		ALL_MODULES="${ALL_MODULES},phalcon";
	fi

	# Process module string into correct format for README.md
	PHP_MODULES="$( echo "${PHP_MODULES}" | sed 's/^\[.*//g' )" # Remove PHP Modules headlines
	PHP_MODULES="${ALL_MODULES}${PHP_MODULES}"                  # Append all available modules
	PHP_MODULES="$( echo "${PHP_MODULES}" | sort -fu )"         # Unique
	PHP_MODULES="$( echo "${PHP_MODULES}" | sed '/^\s*$/d' )"   # Remove empty lines
	PHP_MODULES="$( echo "${PHP_MODULES}" | tr '\r\n' ',' )"    # Newlines to commas
	PHP_MODULES="$( echo "${PHP_MODULES}" | tr '\n' ',' )"      # Newlines to commas
	PHP_MODULES="$( echo "${PHP_MODULES}" | tr '\r' ',' )"      # Newlines to commas
	PHP_MODULES="$( echo "${PHP_MODULES}" | sed	's/^M/,/g' )"   # Newlines to commas
	PHP_MODULES="$( echo "${PHP_MODULES}" | sed 's/,,/,/g' )"   # Remove PHP Modules headlines
	PHP_MODULES="$( echo "${PHP_MODULES}" | sed 's/,/\n/g' )"   # Back to newlines
	PHP_MODULES="$( echo "${PHP_MODULES}" | sort -fu )"         # Unique
	PHP_MODULES="$( echo "${PHP_MODULES}" | sed '/^\s*$/d' )"   # Remove empty lines
	PHP_MODULES="$( echo "${PHP_MODULES}" | tr '\n' ',' )"      # Newlines to commas
	PHP_MODULES="$( echo "${PHP_MODULES}" | sed 's/,$//g' )"    # Remove trailing comma
	PHP_MODULES="$( echo "${PHP_MODULES}" | sed 's/,/, /g' )"   # Add space to comma

	echo "${PHP_MODULES}"
}


###
### Replace modules in Readme for specified PHP version
###
update_readme() {
	v="${1}"
	# Those sections must exist in README.md, otherwise this script will exit with errors
	sed -i'' "s|<td id=\"${v//.}-base\">.*<\/td>|<td id=\"${v//.}-base\">$( get_modules "${TAG_BASE}" )<\/td>|g" "${CWD}/../README.md"
	sed -i'' "s|<td id=\"${v//.}-mods\">.*<\/td>|<td id=\"${v//.}-mods\">$( get_modules "${TAG_MODS}" )<\/td>|g" "${CWD}/../README.md"
}


###
### Entrypoint
###
if [ "${VERSION}" = "" ]; then
	# Update PHP modules for all versions at once
	update_readme "5.2"
	update_readme "5.3"
	update_readme "5.4"
	update_readme "5.5"
	update_readme "5.6"
	update_readme "7.0"
	update_readme "7.1"
	update_readme "7.2"
	update_readme "7.3"
	update_readme "7.4"
	update_readme "8.0"
	update_readme "8.1"
	update_readme "8.2"
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
		update_readme "${VERSION}"
	fi
fi
