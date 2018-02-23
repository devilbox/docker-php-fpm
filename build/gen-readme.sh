#!/bin/sh

set -e
set -u
set -x

CWD="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"



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


sed -i'' "s|<td id=\"54-base\">.*<\/td>|<td id=\"54-base\">$( get_modules "5.4-base" )<\/td>|g" "${CWD}/../README.md"
sed -i'' "s|<td id=\"54-mods\">.*<\/td>|<td id=\"54-mods\">$( get_modules "5.4-mods" )<\/td>|g" "${CWD}/../README.md"

sed -i'' "s|<td id=\"55-base\">.*<\/td>|<td id=\"55-base\">$( get_modules "5.5-base" )<\/td>|g" "${CWD}/../README.md"
sed -i'' "s|<td id=\"55-mods\">.*<\/td>|<td id=\"55-mods\">$( get_modules "5.5-mods" )<\/td>|g" "${CWD}/../README.md"

sed -i'' "s|<td id=\"56-base\">.*<\/td>|<td id=\"56-base\">$( get_modules "5.6-base" )<\/td>|g" "${CWD}/../README.md"
sed -i'' "s|<td id=\"56-mods\">.*<\/td>|<td id=\"56-mods\">$( get_modules "5.6-mods" )<\/td>|g" "${CWD}/../README.md"

sed -i'' "s|<td id=\"70-base\">.*<\/td>|<td id=\"70-base\">$( get_modules "7.0-base" )<\/td>|g" "${CWD}/../README.md"
sed -i'' "s|<td id=\"70-mods\">.*<\/td>|<td id=\"70-mods\">$( get_modules "7.0-mods" )<\/td>|g" "${CWD}/../README.md"

sed -i'' "s|<td id=\"71-base\">.*<\/td>|<td id=\"71-base\">$( get_modules "7.1-base" )<\/td>|g" "${CWD}/../README.md"
sed -i'' "s|<td id=\"71-mods\">.*<\/td>|<td id=\"71-mods\">$( get_modules "7.1-mods" )<\/td>|g" "${CWD}/../README.md"

sed -i'' "s|<td id=\"72-base\">.*<\/td>|<td id=\"72-base\">$( get_modules "7.2-base" )<\/td>|g" "${CWD}/../README.md"
sed -i'' "s|<td id=\"72-mods\">.*<\/td>|<td id=\"72-mods\">$( get_modules "7.2-mods" )<\/td>|g" "${CWD}/../README.md"

