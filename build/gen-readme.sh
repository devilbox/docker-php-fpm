#!/usr/bin/env bash

# Be very strict
set -e
set -u
set -o pipefail

# Get absolute directory of this script
CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"


###
### Show Usage
###
print_usage() {
	echo "Usage: gen-readme.sh"
	echo "       gen-readme.sh 5.3"
	echo "       gen-readme.sh 5.4"
	echo "       gen-readme.sh 5.5"
	echo "       gen-readme.sh 5.6"
	echo "       gen-readme.sh 7.0"
	echo "       gen-readme.sh 7.1"
	echo "       gen-readme.sh 7.2"
	echo "       gen-readme.sh 7.3"
}


###
### Extract PHP modules in alphabetical order and comma separated in one line
###
get_modules() {
	tag="${1}"

	# Retrieve all modules
	PHP_MODULES="$( docker run -it --entrypoint=php devilbox/php-fpm:${tag} -m )"

	# Process module string into correct format for README.md
	PHP_MODULES="$( echo "${PHP_MODULES}" | sed 's/^\[.*//g' )" # Remove PHP Modules headlines
	PHP_MODULES="$( echo "${PHP_MODULES}" | sort -fu )"         # Unique
	PHP_MODULES="$( echo "${PHP_MODULES}" | sed '/^\s*$/d' )"   # Remove empty lines
	PHP_MODULES="$( echo "${PHP_MODULES}" | tr '\r\n' ',' )"    # Newlines to commas
	PHP_MODULES="$( echo "${PHP_MODULES}" | sed 's/,,/,/g' )"   # Remove PHP Modules headlines
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
	sed -i'' "s|<td id=\"${v//.}-base\">.*<\/td>|<td id=\"${v//.}-base\">$( get_modules "${v}-base" )<\/td>|g" "${CWD}/../README.md"
	sed -i'' "s|<td id=\"${v//.}-mods\">.*<\/td>|<td id=\"${v//.}-mods\">$( get_modules "${v}-mods" )<\/td>|g" "${CWD}/../README.md"
}


###
### Entrypoint
###
if [ "${#}" -eq "0" ]; then
	# Update PHP modules for all versions at once
	update_readme "5.3"
	update_readme "5.4"
	update_readme "5.5"
	update_readme "5.6"
	update_readme "7.0"
	update_readme "7.1"
	update_readme "7.2"
	update_readme "7.3"
elif [ "${#}" -gt "1" ]; then
	# Specifying more than 1 argument is wrong
	echo "Error, invalid number of arguments."
	print_usage
	exit 1
else
	if [ "${1}" != "5.3" ] \
	if [ "${1}" != "5.4" ] \
	&& [ "${1}" != "5.5" ] \
	&& [ "${1}" != "5.6" ] \
	&& [ "${1}" != "7.0" ] \
	&& [ "${1}" != "7.1" ] \
	&& [ "${1}" != "7.2" ] \
	&& [ "${1}" != "7.3" ]; then
		# Argument does not match any of the PHP versions
		echo "Error, invalid argument."
		print_usage
		exit 1
	else
		# Update PHP modules for one specific PHP version
		update_readme "${1}"
	fi
fi
