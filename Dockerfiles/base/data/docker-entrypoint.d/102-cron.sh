#!/usr/bin/env bash

set -e
set -u
set -o pipefail


###########################################################
# Functions
############################################################

# add line to devilbox's crontab, if not already there
# and start cron service
cron_add() {
  # save the entire line in one variable
  line="$*"

  DEBUG_LEVEL="$( env_get "DEBUG_ENTRYPOINT" "0" )"

  # check if line already exists in crontab
  crontab -l -u devilbox | grep "$line" > /dev/null
  status=$?

  if [ $status -ne 0 ]
  then
    log "info" "cron: adding line '${line}' ..." "$DEBUG_LEVEL"
    (crontab -l -u devilbox; echo "$line";) | crontab -u devilbox -
  fi

  # make sure the cron service is running
  if ! service cron status >/dev/null
  then
    service cron start
  fi
}
export -f cron_add

cron_remove() {
  # save the entire line in one variable
  line=$*

  DEBUG_LEVEL="$( env_get "DEBUG_ENTRYPOINT" "0" )"

  # check if line already exists in crontab
  crontab -l -u devilbox | grep "$line" > /dev/null
  status=$?

  if [ $status -eq 0 ]; then
    log "info" "cron: removing line '${line}' ..." "$DEBUG_LEVEL"
    (crontab -l -u devilbox | grep -v "$line";) | crontab -u devilbox -
  fi
}
export -f cron_remove
