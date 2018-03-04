#!/usr/bin/env bash

set -e
set -u
set -o pipefail


############################################################
# Helper Functions
############################################################

# Check whether a string is a valid IP address
_isip() {
	local o1=
	local o2=
	local o3=
	local o4=

	# IP is not in correct format
	if ! echo "${1}" | grep -Eq '^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})$'; then
		return 1
	fi

	# Get each octet
	o1="$( echo "${1}" | awk -F'.' '{print $1}' )"
	o2="$( echo "${1}" | awk -F'.' '{print $2}' )"
	o3="$( echo "${1}" | awk -F'.' '{print $3}' )"
	o4="$( echo "${1}" | awk -F'.' '{print $4}' )"

	# Cannot start with 0 and all must be below 256
	if [ "${o1}" -lt "1" ] || \
		[ "${o1}" -gt "255" ] || \
		[ "${o2}" -gt "255" ] || \
		[ "${o3}" -gt "255" ] || \
		[ "${o4}" -gt "255" ]; then
		# Error
		return 1
	fi
}

# Check whether a string is a valid hostname
_ishostname() {
	local hostname="${1}"
	local first_char=
	local last_char=

	# Does not have correct character class
	if ! echo "${hostname}" | grep -Eq '^[-.0-9a-zA-Z]+$'; then
		return 1
	fi

	# first and last character
	first_char="${hostname:0:1}"
	last_char="${hostname: -1}"

	# Dot at beginning or end
	if [ "${first_char}" = "." ] || [ "${last_char}" = "." ]; then
		# Error
		return 1
	fi
	# Dash at beginning or end
	if [ "${first_char}" = "-" ] || [ "${last_char}" = "-" ]; then
		# Error
		return 1
	fi

	# Multiple dots next to each other
	if echo "${hostname}" | grep -Eq '[.]{2,}'; then
		# Error
		return 1
	fi
	# Dash next to dot
	if echo "${hostname}" | grep -Eq '(\.-)|(-\.)'; then
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
### Convert comma separated port-forwards into newline separated "lport:host:rport"
###
port_forward_get_lines() {
	local forwards=
	local l=

	if env_set "${1}"; then

		# Transform into newline separated forwards:
		#   local-port:host:remote-port\n
		#   local-port:host:remote-port\n
		forwards="$( env_get "${1}"  | sed 's/[[:space:]]*//g' | sed 's/,/\n/g' )"

		# loop over them line by line
		IFS='
		'
		for l in ${forwards}; do
			echo "${l}"
		done
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
	local env_varname="${1}"
	local debug="${2}"
	local line=

	local lport=
	local rhost=
	local rport=

	if ! env_set "${env_varname}"; then
		log "info" "\$${env_varname} not set." "${debug}"
		log "info" "Not ports from other machines will be forwarded to 127.0.0.1 inside this docker" "${debug}"
	else

		# Loop over forwards in order to validate them
		for line in $( port_forward_get_lines "${env_varname}" ); do
			lport="$( port_forward_get_lport "${line}" )"
			rhost="$( port_forward_get_rhost "${line}" )"
			rport="$( port_forward_get_rport "${line}" )"

			# Wrong number of ':' separators
			if [ "$( echo "${line}" | grep -o ':' | wc -l )" -ne "2" ]; then
				log "err" "Port forwarding error: invalid number of ':' separators" "${debug}"
				log "err" "Line: ${line}" "${debug}"
				exit
			fi

			if ! isint "${lport}"; then
				log "err" "Port forwarding error: local port is not an integer: ${lport}" "${debug}"
				log "err" "Line: ${line}" "${debug}"
				exit 1
			fi
			if ! _isip "${rhost}" && ! _ishostname "${rhost}"; then
				log "err" "Port forwarding error: remote host is not a valid IP and not a valid hostname: ${rhost}" "${debug}"
				log "err" "Line: ${line}" "${debug}"
				log "err" "" "${debug}"
				exit 1
			fi
			if ! isint "${rport}"; then
				log "err" "Port forwarding error: remote port is not an integer: ${rport}" "${debug}"
				log "err" "Line: ${line}" "${debug}"
				log "err" "" "${debug}"
				exit 1
			fi

			log "info" "Forwarding ${rhost}:${rport} to 127.0.0.1:${lport} inside this docker." "${debug}"
		done
	fi
}


############################################################
# Sanity Checks
############################################################

if ! command -v socat >/dev/null 2>&1; then
	log "err" "socat not found, but required." "1"
	exit 1
fi
if ! command -v awk >/dev/null 2>&1; then
	log "awk not found, but required." "1"
	exit 1
fi
if ! command -v sed >/dev/null 2>&1; then
	log "sed not found, but required." "1"
	exit 1
fi
