#!/usr/bin/env bash

set -e
set -u

CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"


print_usage() {
	echo "Usage: gen-readme.sh"
	echo "       gen-readme.sh 5.4"
	echo "       gen-readme.sh 5.5"
	echo "       gen-readme.sh 5.6"
	echo "       gen-readme.sh 7.0"
	echo "       gen-readme.sh 7.1"
	echo "       gen-readme.sh 7.2"
}

get_modules() {
	tag="${1}"

	PHP_MODULES="$( docker run -it --entrypoint=php devilbox/php-fpm:${tag} -m )"

	PHP_MODULES="$( echo "${PHP_MODULES}" | sed 's/^\[.*//g' )" # Remove PHP Modules headlines
	PHP_MODULES="$( echo "${PHP_MODULES}" | sort -fu )"         # Unique
	PHP_MODULES="$( echo "${PHP_MODULES}" | sed '/^\s*$/d' )"   # Remove empty lines
	PHP_MODULES="$( echo "${PHP_MODULES}" | tr '\r\n' ',' )"    # Newlines to commas
	PHP_MODULES="$( echo "${PHP_MODULES}" | sed 's/,,/,/g' )"   # Remove PHP Modules headlines
	PHP_MODULES="$( echo "${PHP_MODULES}" | sed 's/,$//g' )"    # Remove trailing comma
	PHP_MODULES="$( echo "${PHP_MODULES}" | sed 's/,/, /g' )"   # Add space to comma

	echo "${PHP_MODULES}"
}

update_readme() {
	v="${1}"
	sed -i'' "s|<td id=\"${v//.}-base\">.*<\/td>|<td id=\"${v//.}-base\">$( get_modules "${v}-base" )<\/td>|g" "${CWD}/../README.md"
	sed -i'' "s|<td id=\"${v//.}-mods\">.*<\/td>|<td id=\"${v//.}-mods\">$( get_modules "${v}-mods" )<\/td>|g" "${CWD}/../README.md"
}


if [ "${#}" -eq "0" ]; then
	update_readme "5.4"
	update_readme "5.5"
	update_readme "5.6"
	update_readme "7.0"
	update_readme "7.1"
	update_readme "7.2"
elif [ "${#}" -gt "1" ]; then
	echo "Error, invalid number of arguments."
	print_usage
	exit 1
else
	if [ "${1}" != "5.4" ] \
	&& [ "${1}" != "5.5" ] \
	&& [ "${1}" != "5.6" ] \
	&& [ "${1}" != "7.0" ] \
	&& [ "${1}" != "7.1" ] \
	&& [ "${1}" != "7.2" ]; then
		echo "Error, invalid argument."
		print_usage
		exit 1
	else
		update_readme "${1}"
	fi
fi
