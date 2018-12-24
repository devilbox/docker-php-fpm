# Auto-generated via Ansible: edit build/ansible/DOCKERFILES/Dockerfile-prod.j2 instead.
FROM devilbox/php-fpm:5.3-mods
MAINTAINER "cytopia" <cytopia@everythingcli.org>


###
### Labels
###
LABEL \
	name="cytopia's PHP-FPM 5.3 Image" \
	image="devilbox/php-fpm" \
	tag="5.3-prod" \
	vendor="devilbox" \
	license="MIT"


###
### Install
###
RUN set -x \
	&& DEBIAN_FRONTEND=noninteractive apt-get update -qq \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests apt-utils \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
		locales-all \
		postfix \
		postfix-pcre \
		cron \
		rsyslog \
		socat \
		supervisor \
	&& DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false apt-utils \
	&& rm -rf /var/lib/apt/lists/* \
	\
	&& rm -rf /etc/supervisor* \
	&& mkdir -p /etc/supervisor/conf.d \
	&& mkdir -p /var/log/supervisor \
	\
	&& (find /usr/local/bin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
	&& (find /usr/local/lib -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
	&& (find /usr/local/sbin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true)



###
### Verify
###
RUN set -x \
	&& echo "date.timezone=UTC" > /usr/local/etc/php/php.ini \
	&& php -v | grep -oE 'PHP\s[.0-9]+' | grep -oE '[.0-9]+' | grep '^5.3' \
	&& /usr/local/sbin/php-fpm --test \
	\
	&& PHP_ERROR="$( php -v 2>&1 1>/dev/null )" \
	&& if [ -n "${PHP_ERROR}" ]; then echo "${PHP_ERROR}"; false; fi \
	&& PHP_ERROR="$( php -i 2>&1 1>/dev/null )" \
	&& if [ -n "${PHP_ERROR}" ]; then echo "${PHP_ERROR}"; false; fi \
	\
	&& PHP_FPM_ERROR="$( php-fpm -v 2>&1 1>/dev/null )" \
	&& if [ -n "${PHP_FPM_ERROR}" ]; then echo "${PHP_FPM_ERROR}"; false; fi \
	&& PHP_FPM_ERROR="$( php-fpm -i 2>&1 1>/dev/null )" \
	&& if [ -n "${PHP_FPM_ERROR}" ]; then echo "${PHP_FPM_ERROR}"; false; fi \
	&& rm -f /usr/local/etc/php/php.ini


###
### Copy files
###
COPY ./data/docker-entrypoint.sh /docker-entrypoint.sh
COPY ./data/docker-entrypoint.d/*.sh /docker-entrypoint.d/
COPY ./data/postfix.sh /usr/local/sbin/postfix.sh
COPY ./data/supervisord.conf /etc/supervisor/supervisord.conf


###
### Volumes
###
VOLUME /var/log/php
VOLUME /var/mail



###
### Ports
###
EXPOSE 9000


###
### Entrypoint
###
ENTRYPOINT ["/docker-entrypoint.sh"]
