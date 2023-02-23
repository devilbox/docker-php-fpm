#!/usr/bin/env bash

set -e
set -u
set -o pipefail

############################################################
# Functions
############################################################

###
### Execute project-supplied scripts
###
execute_project_scripts() {
  local debug="${1}"
  local script_dir
  local script_name
  local DEVILBOX_PROJECT_DIR
  local DEVILBOX_PROJECT_NAME
  local DEVILBOX_PROJECT_DOCROOT

  for DEVILBOX_PROJECT_DIR in /shared/httpd/*; do

    script_dir=${DEVILBOX_PROJECT_DIR}/$(env_get HTTPD_TEMPLATE_DIR ".devilbox")/autostart

    if [ -d "${DEVILBOX_PROJECT_DIR}" ] && [ -d "${script_dir}" ]; then

      DEVILBOX_PROJECT_NAME=$(basename "${DEVILBOX_PROJECT_DIR}")
      export DEVILBOX_PROJECT_NAME

      DEVILBOX_PROJECT_DOCROOT=${DEVILBOX_PROJECT_DIR}/$(env_get HTTPD_DOCROOT_DIR "htdocs")
      export DEVILBOX_PROJECT_DOCROOT

      script_files="$(find -L "${script_dir}" -type f -iname '*.sh' | sort -n)"

      # loop over them line by line
      IFS='
      '
      for script_f in ${script_files}; do

        script_name="$(basename "${script_f}")"

        log "info" "Executing project startup script: ${DEVILBOX_PROJECT_NAME}:${script_name}" "${debug}"

        if ! bash "${script_f}" "${debug}"; then
          log "err" "Failed to execute script" "${debug}"
          exit 1
        fi

      done
    fi
  done
}

############################################################
# Sanity Checks
############################################################

# find, sort, and basename are already checked in ./310-custom-startup-scripts.sh
