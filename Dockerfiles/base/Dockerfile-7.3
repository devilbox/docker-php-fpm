# Auto-generated via Ansible: edit build/ansible/DOCKERFILES/Dockerfile-base.j2 instead.
FROM php:7.3-fpm
MAINTAINER "cytopia" <cytopia@everythingcli.org>


###
### Labels
###
# https://github.com/opencontainers/image-spec/blob/master/annotations.md
#LABEL "org.opencontainers.image.created"=""
#LABEL "org.opencontainers.image.version"=""
#LABEL "org.opencontainers.image.revision"=""
LABEL "maintainer"="cytopia <cytopia@everythingcli.org>"
LABEL "org.opencontainers.image.authors"="cytopia <cytopia@everythingcli.org>"
LABEL "org.opencontainers.image.url"="https://github.com/devilbox/docker-php-fpm"
LABEL "org.opencontainers.image.documentation"="https://github.com/devilbox/docker-php-fpm"
LABEL "org.opencontainers.image.source"="https://github.com/devilbox/docker-php-fpm"
LABEL "org.opencontainers.image.vendor"="devilbox"
LABEL "org.opencontainers.image.licenses"="MIT"
LABEL "org.opencontainers.image.ref.name"="7.3-base"
LABEL "org.opencontainers.image.title"="PHP-FPM 7.3-base"
LABEL "org.opencontainers.image.description"="PHP-FPM 7.3-base"


###
### Envs
###
ENV MY_USER="devilbox" \
	MY_GROUP="devilbox" \
	MY_UID="1000" \
	MY_GID="1000" \
	PHP_VERSION="7.3"


###
### User/Group
###
RUN set -eux \
	&& groupadd -g ${MY_GID} -r ${MY_GROUP} \
	&& useradd -u ${MY_UID} -m -s /bin/bash -g ${MY_GROUP} ${MY_USER}


###
### Upgrade (install ps)
###
RUN set -eux \
	&& DEBIAN_FRONTEND=noninteractive apt-get update -qq \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests procps \
	&& rm -rf /var/lib/apt/lists/*


###
### Configure
###
RUN set -eux \
	&& rm -rf /usr/local/etc/php-fpm.d \
	&& mkdir -p /usr/local/etc/php-fpm.d \
	&& mkdir -p /var/lib/php/session \
	&& mkdir -p /var/lib/php/wsdlcache \
	&& chown -R devilbox:devilbox /var/lib/php/session \
	&& chown -R devilbox:devilbox /var/lib/php/wsdlcache


###
### Copy files
###
COPY ./data/php-ini.d/php-7.3.ini /usr/local/etc/php/conf.d/xxx-devilbox-default-php.ini
COPY ./data/php-fpm.conf/php-fpm-7.3.conf /usr/local/etc/php-fpm.conf

COPY ./data/docker-entrypoint.sh /docker-entrypoint.sh
COPY ./data/docker-entrypoint.d /docker-entrypoint.d


###
### Verify
###
RUN set -eux \
	&& echo "date.timezone=UTC" > /usr/local/etc/php/php.ini \
	&& php -v | grep -oE 'PHP\s[.0-9]+' | grep -oE '[.0-9]+' | grep '^7.3' \
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
### Ports
###
EXPOSE 9000


###
### Entrypoint
###
CMD ["/usr/local/sbin/php-fpm"]
ENTRYPOINT ["/docker-entrypoint.sh"]
