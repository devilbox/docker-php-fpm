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
### Setup Postfix for catch-all
###
fix_mds_permissions() {
	mds_cfg=/etc/mysqldump-secure.conf
	mds_cnf=/etc/mysqldump-secure.cnf
	mds_log=/var/log/mysqldump-secure.log
	mds_dir=/shared/backups/mysql

	if [ ! -d "${mds_dir}" ]; then
		run "mkdir -p ${mds_dir}"
	fi

	run "chown ${MY_USER}:${MY_GROUP} ${mds_cfg}"
	run "chown ${MY_USER}:${MY_GROUP} ${mds_cnf}"
	run "chown ${MY_USER}:${MY_GROUP} ${mds_log}"
	run "chown ${MY_USER}:${MY_GROUP} ${mds_dir}"

	unset -v mds_cfg
	unset -v mds_cnf
	unset -v mds_log
	unset -v mds_dir
}

set_mds_settings() {
	mds_user_var="${1}"
	mds_pass_var="${2}"
	mds_host_var="${3}"

	mds_cnf=/etc/mysqldump-secure.cnf

	# MySQL user
	if ! env_set "${mds_user_var}"; then
		log "info" "\$${mds_user_var} not set for mysqldump-secure. Keeping default user."
	else
		mds_user_val="$( env_get "${mds_user_var}" )"
		log "info" "\$${mds_user_var} set for mysqldump-secure. Changing to '${mds_user_val}'"
		run "sed -i'' 's/^user.*/user = ${mds_user_val}/g' ${mds_cnf}"
	fi

	# MySQL pass
	if ! env_set "${mds_pass_var}"; then
		log "info" "\$${mds_pass_var} not set for mysqldump-secure. Keeping default password."
	else
		mds_pass_val="$( env_get "${mds_pass_var}" )"
		log "info" "\$${mds_pass_var} set for mysqldump-secure. Changing to '******'"
		run "sed -i'' 's/^password.*/password = ${mds_pass_val}/g' ${mds_cnf}"
	fi

	# MySQL host
	if ! env_set "${mds_host_var}"; then
		log "info" "\$${mds_host_var} not set for mysqldump-secure. Keeping default host."
	else
		mds_host_val="$( env_get "${mds_host_var}" )"
		log "info" "\$${mds_host_var} set for mysqldump-secure. Changing to '${mds_host_val}'"
		run "sed -i'' 's/^host.*/host = ${mds_host_val}/g' ${mds_cnf}"
	fi

	unset -v mds_user_var
	unset -v mds_pass_var
	unset -v mds_host_var
	unset -v mds_user_val
	unset -v mds_pass_val
	unset -v mds_host_val
	unset -v mds_cnf
}
