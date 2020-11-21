#!/usr/bin/env bash

set -e
set -u
set -o pipefail


############################################################
# Functions
############################################################

###
### Helper
###
_get_username_by_uid() {
	if getent="$( getent passwd "${1}" )"; then
		echo "${getent//:*}"
		return 0
	fi
	return 1
}
_get_groupname_by_gid() {
	if getent="$( getent group "${1}" )"; then
		echo "${getent//:*}"
		return 0
	fi
	return 1
}


###
### Change UID
###
set_uid() {
	local uid_varname="${1}"
	local username="${2}"
	local homedir="${3}"
	local debug="${4}"

	local uid=				# new uid
	local spare_uid=9876	# spare uid to change another user to

	if ! env_set "${uid_varname}"; then
		log "info" "\$${uid_varname} not set. Keeping default uid for '${username}'." "${debug}"
	else
		uid="$( env_get "${uid_varname}" )"

		if ! isint "${uid}"; then
			log "err" "\$${uid_varname} is not an integer: '${uid}'" "${debug}"
			exit 1
		else
			# Username with this uid already exists
			if target_username="$( _get_username_by_uid "${uid}" )"; then
				# It is not our user, so we need to changes his/her uid to something else first
				if [ "${target_username}" != "${username}" ]; then
					log "warn" "User with ${uid} already exists: ${target_username}" "${debug}"
					log "info" "Changing UID of ${target_username} to ${spare_uid}" "${debug}"
					run "usermod -u ${spare_uid} ${target_username}" "${debug}"
				fi
			fi
			# Change uid and fix homedir permissions
			log "info" "Changing user '${username}' uid to: ${uid}" "${debug}"
			if ! run "usermod -u ${uid} ${username} 2>/dev/null" "${debug}"; then
				run "usermod -u ${uid} ${username}" "${debug}"
			fi
			run "chown -R ${username} ${homedir} 2>/dev/null || true" "${debug}"
			run "chown -R ${username} /var/lib/php/session" "${debug}"
			run "chown -R ${username} /var/lib/php/wsdlcache" "${debug}"
			if [ -f "/var/spool/mail/devilbox" ]; then
				run "chown -R ${username} /var/spool/mail/devilbox" "${debug}"
			fi
			if [ -d "/etc/supervisor/custom.d" ]; then
				run "chown -R ${username} /etc/supervisor/custom.d" "${debug}"
			fi
		fi
	fi
}


###
### Change GID
###
set_gid() {
	local gid_varname="${1}"
	local groupname="${2}"
	local homedir="${3}"
	local debug="${4}"

	local gid=				# new gid
	local spare_gid=9876	# spare gid to change another group to

	if ! env_set "${gid_varname}"; then
		log "info" "\$${gid_varname} not set. Keeping default gid for '${groupname}'." "${debug}"
	else
		# Retrieve the value from env
		gid="$( env_get "${gid_varname}" )"

		if ! isint "${gid}"; then
			log "err" "\$${gid_varname} is not an integer: '${gid}'" "${debug}"
			exit 1
		else
			# Groupname with this gid already exists
			if target_groupname="$( _get_groupname_by_gid "${gid}" )"; then
				# It is not our group, so we need to changes his/her gid to something else first
				if [ "${target_groupname}" != "${groupname}" ]; then
					log "warn" "Group with ${gid} already exists: ${target_groupname}" "${debug}"
					log "info" "Changing GID of ${target_groupname} to ${spare_gid}" "${debug}"
					run "groupmod -g ${spare_gid} ${target_groupname}" "${debug}"
				fi
			fi
			# Change gid and fix homedir permissions
			log "info" "Changing group '${groupname}' gid to: ${gid}" "${debug}"
			if ! run "groupmod -g ${gid} ${groupname} 2>/dev/null" "${debug}"; then
				run "groupmod -g ${gid} ${groupname}" "${debug}"
			fi
			run "chown -R :${groupname} ${homedir} 2>/dev/null || true" "${debug}"
			run "chown -R :${groupname} /var/lib/php/session" "${debug}"
			run "chown -R :${groupname} /var/lib/php/wsdlcache" "${debug}"
			if [ -f "/var/spool/mail/devilbox" ]; then
				run "chown -R :${groupname} /var/spool/mail/devilbox" "${debug}"
			fi
			if [ -d "/etc/supervisor/custom.d" ]; then
				run "chown -R :${groupname} /etc/supervisor/custom.d" "${debug}"
			fi
		fi
	fi
}


############################################################
# Sanity Checks
############################################################

if ! command -v usermod >/dev/null 2>&1; then
	log "err" "usermod not found, but required." "1"
	exit 1
fi
if ! command -v groupmod >/dev/null 2>&1; then
	log "err" "groupmod not found, but required." "1"
	exit 1
fi
if ! command -v getent >/dev/null 2>&1; then
	log "err" "getent not found, but required." "1"
	exit 1
fi
