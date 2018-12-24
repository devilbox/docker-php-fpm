#!/usr/bin/env bash
#
# PHP FPM 5.2 and PHP-FPM 5.3 do not allow to pass through environment variables
# This is a hacky shell script to create:
#   env[NAME]='VALUE' entries for PHP FPM config out of all current env vars


# Check if an environment variable is valid
# for PHP-FPM config and if yes return it
_get_env_php_fpm() {
	local name="${1}"
	local env=

	# Not set
	if ! printenv "${name}" >/dev/null 2>&1; then
		return 1
	fi

	# Empty variables are not supported by PHP-FPM config syntax
	env="$( printenv "${name}" )"
	if [ -z "${env}" ]; then
		return 1
	fi

	# Values containing a = are not supported by PHP-FPM config syntax
	if echo "${env}" | grep -q '='; then
		return 1
	fi

	echo "${env}"
}

# Write all valid environment variables to a PHP-FPM config
set_env_php_fpm() {
	local config="${1}"

	# Clear file
	echo "[www]" > "${config}"

	# Append env variables
	for name in $(printenv | awk -F'=' '{print $1}'); do

		if _get_env_php_fpm "${name}" >/dev/null 2>&1; then
			echo "env[${name}]='$( _get_env_php_fpm "${name}" )'" >> "${config}"
		fi
	done
}
