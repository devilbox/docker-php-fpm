#!/usr/bin/env bash

set -e
set -u
set -o pipefail


############################################################
# Functions
############################################################

###
### Setup Postfix for catch-all
###
fix_mds_permissions() {
	local user="${1}"
	local group="${2}"
	local debug="${3}"

	local mds_cfg=/etc/mysqldump-secure.conf
	local mds_cnf=/etc/mysqldump-secure.cnf
	local mds_log=/var/log/mysqldump-secure.log
	local mds_dir=/shared/backups/mysql

	if [ ! -d "${mds_dir}" ]; then
		run "mkdir -p ${mds_dir}" "${debug}"
	fi

	run "chown ${user}:${group} ${mds_cfg}" "${debug}"
	run "chown ${user}:${group} ${mds_cnf}" "${debug}"
	run "chown ${user}:${group} ${mds_log}" "${debug}"
	run "chown ${user}:${group} ${mds_dir}" "${debug}"
}

set_mds_settings() {
	local mds_user_var="${1}"
	local mds_pass_var="${2}"
	local mds_host_var="${3}"
	local debug="${4}"

	local mds_cnf=/etc/mysqldump-secure.cnf

	# MySQL user
	if ! env_set "${mds_user_var}"; then
		log "info" "\$${mds_user_var} not set for mysqldump-secure. Keeping default user." "${debug}"
	else
		mds_user_val="$( env_get "${mds_user_var}" )"
		log "info" "\$${mds_user_var} set for mysqldump-secure. Changing to '${mds_user_val}'" "${debug}"
		run "sed -i'' 's/^user.*/user = ${mds_user_val}/g' ${mds_cnf}" "${debug}"
	fi

	# MySQL pass
	if ! env_set "${mds_pass_var}"; then
		log "info" "\$${mds_pass_var} not set for mysqldump-secure. Keeping default password." "${debug}"
	else
		mds_pass_val="$( env_get "${mds_pass_var}" )"
		log "info" "\$${mds_pass_var} set for mysqldump-secure. Changing to '******'" "${debug}"
		run "perl -pi -e 's/^password.*/password = ${mds_pass_val}/g' ${mds_cnf}" "${debug}"
	fi

	# MySQL host
	if ! env_set "${mds_host_var}"; then
		log "info" "\$${mds_host_var} not set for mysqldump-secure. Keeping default host." "${debug}"
	else
		mds_host_val="$( env_get "${mds_host_var}" )"
		log "info" "\$${mds_host_var} set for mysqldump-secure. Changing to '${mds_host_val}'" "${debug}"
		run "sed -i'' 's/^host.*/host = ${mds_host_val}/g' ${mds_cnf}" "${debug}"
	fi
}
