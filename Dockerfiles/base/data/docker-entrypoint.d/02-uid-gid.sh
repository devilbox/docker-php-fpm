#!/bin/sh
#
# Available global variables:
#   + MY_USER
#   + MY_GROUP
#   + DEBUG_LEVEL

set -e
set -u


############################################################
# Functions
############################################################

###
### Change UID
###
set_uid() {
	uid_varname="${1}"

	if ! env_set "${uid_varname}"; then
		log "info" "\$${uid_varname} not set. Keeping default uid for '${MY_USER}'."
	else
		uid_env_uid="$( env_get "${uid_varname}" )"

		if ! isint "${uid_env_uid}"; then
			log "err" "\$${uid_varname} is not an integer: '${uid_env_uid}'"
			exit 1
		else
			if uid_getent_row="$( getent passwd "${uid_env_uid}" )"; then
				uid_getent_name="$( echo "${uid_getent_row}" | awk -F ':' '{print $1}' )"
				if [ "${uid_getent_name}" != "${MY_USER}" ]; then
					log "warn" "User with ${uid_env_uid} already exists: ${uid_getent_name}"
					log "info" "Changing UID of ${uid_getent_name} to 9999"
					run "usermod -u 9999 ${uid_getent_name}"
				fi
			fi
			log "info" "Changing user '${MY_USER}' uid to: ${uid_env_uid}"
			run "usermod -u ${uid_env_uid} ${MY_USER}"
		fi
	fi

	# Fix homedir permissions
	run "chown -R ${MY_USER} /home/${MY_USER}"

	unset -v uid_varname
	unset -v uid_env_uid
	unset -v uid_getent_row
	unset -v uid_getent_name
}


###
### Change GID
###
set_gid() {
	gid_varname="${1}"

	if ! env_set "${gid_varname}"; then
		log "info" "\$${gid_varname} not set. Keeping default gid for '${MY_GROUP}'."
	else
		# Retrieve the value from env
		gid_env_gid="$( env_get "${gid_varname}" )"

		if ! isint "${gid_env_gid}"; then
			log "err" "\$${gid_varname} is not an integer: '${gid_env_gid}'"
			exit 1
		else
			if gid_getent_row="$( getent group "${gid_env_gid}" )"; then
				gid_getent_name="$( echo "${gid_getent_row}" | awk -F ':' '{print $1}' )"
				if [ "${gid_getent_name}" != "${MY_GROUP}" ]; then
					log "warn" "Group with ${gid_env_gid} already exists: ${gid_getent_name}"
					log "info" "Changing GID of ${gid_getent_name} to 9999"
					run "groupmod -g 9999 ${gid_getent_name}"
				fi
			fi
			log "info" "Changing group '${MY_GROUP}' gid to: ${gid_env_gid}"
			run "groupmod -g ${gid_env_gid} ${MY_GROUP}"
		fi
	fi

	# Fix homedir permissions
	run "chown -R :${MY_GROUP} /home/${MY_USER}"

	unset -v gid_varname
	unset -v gid_env_gid
	unset -v gid_getent_row
	unset -v gid_getent_name
}


############################################################
# Sanity Checks
############################################################

if ! command -v usermod >/dev/null 2>&1; then
	log "err" "usermod not found, but required."
	exit 1
fi
if ! command -v groupmod >/dev/null 2>&1; then
	log "err" "groupmod not found, but required."
	exit 1
fi
