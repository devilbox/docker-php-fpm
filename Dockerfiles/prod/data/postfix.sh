#!/usr/bin/env bash
#
# Wrapper to have postfix run in foreground
# mode in order to be called by supvervisord
#
#
# CREDITS:
# This script is mostly based on the following Gist:
# https://gist.github.com/chrisnew/b0c1b8d310fc5ceaeac4
#



###
### Be strict
###
set -e
set -u
set -o pipefail


###
### Variables
###
MAILLOG="/var/log/mail.log"
MAILPID="/var/spool/postfix/pid/master.pid"


###
### Sanity checks
###
if ! command -v pidof >/dev/null 2>&1; then
	echo "pidof is required for cleaning up tail command."
	exit 1
fi

# Give rsyslogd some time to start up
sleep 2

if ! pidof rsyslogd >/dev/null 2>&1; then
	echo "rsyslogd is not running, but required for mail logging."
	exit 1
fi

# force new copy of hosts there (otherwise links could be outdated)
# TODO: check if required
#cp /etc/hosts /var/spool/postfix/etc/hosts


###
### Trap signals
###
trap "postfix stop" SIGINT
trap "postfix stop" SIGTERM
trap "postfix reload" SIGHUP


###
### Startup
###

# start postfix
postfix start

# Capture output
tail -qF -n 0 "${MAILLOG}" 2>/dev/null &
tail_pid="${?}"


###
### Warm-up time
###
sleep 3


###
### Wait for kill signales
###
while kill -0 "$(cat "${MAILPID}")" >/dev/null 2>&1; do
	# Check every second
	sleep 1
done


###
### Clean-up
###
kill "${tail_pid}"
