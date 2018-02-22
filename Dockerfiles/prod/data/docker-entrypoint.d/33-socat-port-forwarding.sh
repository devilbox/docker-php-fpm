#!/bin/sh
#
# Available global variables:
#   + MY_USER
#   + MY_GROUP
#   + DEBUG_LEVEL


set -e
set -u



############################################################
# Helper Functions
############################################################

###
### Helper functions
###
_isip() {
	# IP is not in correct format
	if ! echo "${1}" | grep -Eq '^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})$'; then
		return 1
	fi

	# Get each octet
	isip_o1="$( echo "${1}" | awk -F'.' '{print $1}' )"
	isip_o2="$( echo "${1}" | awk -F'.' '{print $2}' )"
	isip_o3="$( echo "${1}" | awk -F'.' '{print $3}' )"
	isip_o4="$( echo "${1}" | awk -F'.' '{print $4}' )"

	# Cannot start with 0 and all must be below 256
	if [ "${isip_o1}" -lt "1" ] || \
		[ "${isip_o1}" -gt "255" ] || \
		[ "${isip_o2}" -gt "255" ] || \
		[ "${isip_o3}" -gt "255" ] || \
		[ "${isip_o4}" -gt "255" ]; then
		unset -v isip_o1
		unset -v isip_o2
		unset -v isip_o3
		unset -v isip_o4
		# Error
		return 1
	fi

	unset -v isip_o1
	unset -v isip_o2
	unset -v isip_o3
	unset -v isip_o4

	# Success
	return 0
}

_ishostname() {
	# Does not have correct character class
	if ! echo "${1}" | grep -Eq '^[-.0-9a-zA-Z]+$'; then
		return 1
	fi

	# first and last character
	ishostname_f_char="$( echo "${1}" | cut -c1-1 )"
	ishostname_l_char="$( echo "${1}" | sed -e 's/.*\(.\)$/\1/' )"

	# Dot at beginning or end
	if [ "${ishostname_f_char}" = "." ] || [ "${ishostname_l_char}" = "." ]; then
		unset -v ishostname_f_char
		unset -v ishostname_l_char
		# Error
		return 1
	fi
	# Dash at beginning or end
	if [ "${ishostname_f_char}" = "-" ] || [ "${ishostname_l_char}" = "-" ]; then
		unset -v ishostname_f_char
		unset -v ishostname_l_char
		# Error
		return 1
	fi

	unset -v ishostname_f_char
	unset -v ishostname_l_char

	# Multiple dots next to each other
	if echo "${1}" | grep -Eq '[.]{2,}'; then
		# Error
		return 1
	fi
	# Dash next to dot
	if echo "${1}" | grep -Eq '(\.-)|(-\.)'; then
		# Error
		return 1
	fi

	# Success
	return 0
}



############################################################
# Functions
############################################################

###
###
###
port_forward_get_lines() {

	if env_set "${1}"; then

		# Transform into newline separated forwards:
		#   local-port:host:remote-port\n
		#   local-port:host:remote-port\n
		pfl_forwards="$( env_get "${1}"  | sed 's/[[:space:]]*//g' | sed 's/,/\n/g' )"

		# loop over them line by line
		IFS='
		'
		for pfl_line in ${pfl_forwards}; do
			echo "${pfl_line}"
		done

		unset -v pfl_forwards
		unset -v pfl_line
	fi
}

port_forward_get_lport() {
	# local-port:host:remote-port\n
	echo "${1}" | awk -F':' '{print $1}'
}
port_forward_get_rhost() {
	# local-port:host:remote-port\n
	echo "${1}" | awk -F':' '{print $2}'
}
port_forward_get_rport() {
	# local-port:host:remote-port\n
	echo "${1}" | awk -F':' '{print $3}'
}



port_forward_validate() {
	pfv_env_varname="${1}"

	if ! env_set "${pfv_env_varname}"; then
		log "info" "\$${pfv_env_varname} not set."
		log "info" "Not ports from other machines will be forwarded to 127.0.0.1 inside this docker"
	else

		# Loop over forwards in order to validate them
		for pfv_line in $( port_forward_get_lines "${pfv_env_varname}" ); do
			pfv_lport="$( port_forward_get_lport "${pfv_line}" )"
			pfv_rhost="$( port_forward_get_rhost "${pfv_line}" )"
			pfv_rport="$( port_forward_get_rport "${pfv_line}" )"

			if ! isint "${pfv_lport}"; then
				log "err" "Port forwarding error: local port is not an integer: ${pfv_lport}"
				log "err" "Line: ${pfv_line}"
				exit 1
			fi
			if ! _isip "${pfv_rhost}" && ! _ishostname "${pfv_rhost}"; then
				log "err" "Port forwarding error: remote host is not a valid IP and not a valid hostname: ${pfv_rhost}"
				log "err" "Line: ${pfv_line}"
				log "err" ""
				exit 1
			fi
			if ! isint "${pfv_rport}"; then
				log "err" "Port forwarding error: remote port is not an integer: ${pfv_rport}"
				log "err" "Line: ${pfv_line}"
				log "err" ""
				exit 1
			fi

			log "info" "Forwarding ${pfv_rhost}:${pfv_rport} to 127.0.0.1:${pfv_lport} inside this docker."
		done

		unset -v pfv_line
		unset -v pfv_lport
		unset -v pfv_rhost
		unset -v pfv_rport
	fi

	unset -v pfv_env_varname
}


############################################################
# Sanity Checks
############################################################

if ! command -v awk >/dev/null 2>&1; then
	echo "awk not found, but required."
	exit 1
fi
if ! command -v cut >/dev/null 2>&1; then
	echo "cut not found, but required."
	exit 1
fi
if ! command -v sed >/dev/null 2>&1; then
	echo "sed not found, but required."
	exit 1
fi
