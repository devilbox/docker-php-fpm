# Auto-generated via Ansible: edit build/ansible/DOCKERFILES/Dockerfile-mods.j2 instead.
FROM devilbox/php-fpm:5.5-base
MAINTAINER "cytopia" <cytopia@everythingcli.org>


###
### Labels
###
LABEL \
	name="cytopia's PHP-FPM 5.5 Image" \
	image="devilbox/php-fpm" \
	tag="5.5-mods" \
	vendor="devilbox" \
	license="MIT"


###
### Envs
###
ENV BUILD_DEPS \
	alien \
	firebird-dev \
	freetds-dev \
	libaio-dev \
	libbz2-dev \
	libc-client-dev \
	libcurl4-openssl-dev \
	libenchant-dev \
	libevent-dev \
	libfbclient2 \
	libfreetype6-dev \
	libgmp-dev \
	libib-util \
	libicu-dev \
	libjpeg-dev \
	libkrb5-dev \
	libldap2-dev \
	libmagickwand-dev \
	libmcrypt-dev \
	libmemcached-dev \
	libnghttp2-dev \
	libpcre3-dev \
	libpng-dev \
	libpq-dev \
	libpspell-dev \
	librabbitmq-dev \
	librdkafka-dev \
	librecode-dev \
	libsasl2-dev \
	libsnmp-dev \
	libssl-dev \
	libtidy-dev \
	libvpx-dev \
	libxml2-dev \
	libxpm-dev \
	libxslt-dev \
	snmp \
	zlib1g-dev \
	ca-certificates \
	git

ENV RUN_DEPS \
	libaio1 \
	libaspell15 \
	libc-client2007e \
	libenchant1c2a \
	libfbclient2 \
	libfreetype6 \
	libicu52 \
	libjpeg62-turbo \
	libmagickwand-6.q16-2 \
	libmcrypt4 \
	libmemcachedutil2 \
	libmysqlclient18 \
	libnghttp2-5 \
	libpng12-0 \
	libpq5 \
	librabbitmq1 \
	librdkafka1 \
	librecode0 \
	libsybdb5 \
	libtidy-0.99-0 \
	libvpx1 \
	libxpm4 \
	libxslt1.1 \
	snmp \
	ca-certificates


###
### Install
###
RUN set -x \
	&& DEBIAN_FRONTEND=noninteractive apt-get update -qq \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests apt-utils \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
		${BUILD_DEPS} \
	\
	\
# ---- Installing PHP Extension: ioncube ----
	&& EXTENSION_DIR="$( php -i | grep ^extension_dir | awk -F '=>' '{print $2}' | xargs )" \
&& if [ ! -d "${EXTENSION_DIR}" ]; then mkdir -p "${EXTENSION_DIR}"; fi \
&& curl https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz -L -o ioncube.tar.gz \
&& tar xvfz ioncube.tar.gz \
&& cd ioncube \
&& cp "ioncube_loader_lin_5.5.so" "${EXTENSION_DIR}/ioncube.so" \
&& cd ../ \
&& rm -rf ioncube \
&& rm -rf ioncube.tar.gz \
 \
	&& (rm -rf /usr/local/lib/php/test/ioncube || true) \
	&& (rm -rf /usr/local/lib/php/doc/ioncube || true) \
	\
# ---- Installing PHP Extension: amqp ----
	&& pecl install amqp-1.9.3 \
	&& docker-php-ext-enable amqp \
	&& (rm -rf /usr/local/lib/php/test/amqp || true) \
	&& (rm -rf /usr/local/lib/php/doc/amqp || true) \
	\
# ---- Installing PHP Extension: apcu ----
	&& pecl install apcu-4.0.11 \
	&& docker-php-ext-enable apcu \
	&& (rm -rf /usr/local/lib/php/test/apcu || true) \
	&& (rm -rf /usr/local/lib/php/doc/apcu || true) \
	\
# ---- Installing PHP Extension: bcmath ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) bcmath \
	&& (rm -rf /usr/local/lib/php/test/bcmath || true) \
	&& (rm -rf /usr/local/lib/php/doc/bcmath || true) \
	\
# ---- Installing PHP Extension: bz2 ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) bz2 \
	&& (rm -rf /usr/local/lib/php/test/bz2 || true) \
	&& (rm -rf /usr/local/lib/php/doc/bz2 || true) \
	\
# ---- Installing PHP Extension: calendar ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) calendar \
	&& (rm -rf /usr/local/lib/php/test/calendar || true) \
	&& (rm -rf /usr/local/lib/php/doc/calendar || true) \
	\
# ---- Installing PHP Extension: dba ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) dba \
	&& (rm -rf /usr/local/lib/php/test/dba || true) \
	&& (rm -rf /usr/local/lib/php/doc/dba || true) \
	\
# ---- Installing PHP Extension: enchant ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) enchant \
	&& (rm -rf /usr/local/lib/php/test/enchant || true) \
	&& (rm -rf /usr/local/lib/php/doc/enchant || true) \
	\
# ---- Installing PHP Extension: exif ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) exif \
	&& (rm -rf /usr/local/lib/php/test/exif || true) \
	&& (rm -rf /usr/local/lib/php/doc/exif || true) \
	\
# ---- Installing PHP Extension: gd ----
	&& ln -s /usr/lib/x86_64-linux-gnu/libXpm.* /usr/lib/ \
	&& /usr/local/bin/docker-php-ext-configure gd --with-gd --with-vpx-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr --with-zlib-dir=/usr --with-xpm-dir=/usr --with-freetype-dir=/usr --enable-gd-jis-conv --enable-gd-native-ttf \
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gd \
	&& (rm -rf /usr/local/lib/php/test/gd || true) \
	&& (rm -rf /usr/local/lib/php/doc/gd || true) \
	\
# ---- Installing PHP Extension: gettext ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gettext \
	&& (rm -rf /usr/local/lib/php/test/gettext || true) \
	&& (rm -rf /usr/local/lib/php/doc/gettext || true) \
	\
# ---- Installing PHP Extension: gmp ----
	&& ln /usr/include/x86_64-linux-gnu/gmp.h /usr/include/ \
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) gmp \
	&& (rm -rf /usr/local/lib/php/test/gmp || true) \
	&& (rm -rf /usr/local/lib/php/doc/gmp || true) \
	\
# ---- Installing PHP Extension: igbinary ----
	&& pecl install igbinary-2.0.8 \
	&& docker-php-ext-enable igbinary \
	&& (rm -rf /usr/local/lib/php/test/igbinary || true) \
	&& (rm -rf /usr/local/lib/php/doc/igbinary || true) \
	\
# ---- Installing PHP Extension: imagick ----
	&& pecl install imagick \
	&& docker-php-ext-enable imagick \
	&& (rm -rf /usr/local/lib/php/test/imagick || true) \
	&& (rm -rf /usr/local/lib/php/doc/imagick || true) \
	\
# ---- Installing PHP Extension: imap ----
	&& ln -s /usr/lib/x86_64-linux-gnu/libkrb5* /usr/lib/ \
	&& /usr/local/bin/docker-php-ext-configure imap --with-kerberos --with-imap-ssl --with-imap \
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) imap \
	&& (rm -rf /usr/local/lib/php/test/imap || true) \
	&& (rm -rf /usr/local/lib/php/doc/imap || true) \
	\
# ---- Installing PHP Extension: interbase ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) interbase \
	&& (rm -rf /usr/local/lib/php/test/interbase || true) \
	&& (rm -rf /usr/local/lib/php/doc/interbase || true) \
	\
# ---- Installing PHP Extension: intl ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) intl \
	&& (rm -rf /usr/local/lib/php/test/intl || true) \
	&& (rm -rf /usr/local/lib/php/doc/intl || true) \
	\
# ---- Installing PHP Extension: ldap ----
	&& ln -s /usr/lib/x86_64-linux-gnu/libldap* /usr/lib/ \
	&& /usr/local/bin/docker-php-ext-configure ldap --with-ldap --with-ldap-sasl \
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) ldap \
	&& (rm -rf /usr/local/lib/php/test/ldap || true) \
	&& (rm -rf /usr/local/lib/php/doc/ldap || true) \
	\
# ---- Installing PHP Extension: mcrypt ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mcrypt \
	&& (rm -rf /usr/local/lib/php/test/mcrypt || true) \
	&& (rm -rf /usr/local/lib/php/doc/mcrypt || true) \
	\
# ---- Installing PHP Extension: msgpack ----
	&& pecl install msgpack-0.5.7 \
	&& docker-php-ext-enable msgpack \
	&& (rm -rf /usr/local/lib/php/test/msgpack || true) \
	&& (rm -rf /usr/local/lib/php/doc/msgpack || true) \
	\
# ---- Installing PHP Extension: memcache ----
	&& pecl install memcache \
	&& docker-php-ext-enable memcache \
	&& (rm -rf /usr/local/lib/php/test/memcache || true) \
	&& (rm -rf /usr/local/lib/php/doc/memcache || true) \
	\
# ---- Installing PHP Extension: memcached ----
	&& pecl install memcached-2.2.0 \
	&& docker-php-ext-enable memcached \
	&& (rm -rf /usr/local/lib/php/test/memcached || true) \
	&& (rm -rf /usr/local/lib/php/doc/memcached || true) \
	\
# ---- Installing PHP Extension: mongo ----
	&& yes | pecl install mongo \
	&& docker-php-ext-enable mongo \
	&& (rm -rf /usr/local/lib/php/test/mongo || true) \
	&& (rm -rf /usr/local/lib/php/doc/mongo || true) \
	\
# ---- Installing PHP Extension: mongodb ----
	&& pecl install mongodb \
	&& docker-php-ext-enable mongodb \
	&& (rm -rf /usr/local/lib/php/test/mongodb || true) \
	&& (rm -rf /usr/local/lib/php/doc/mongodb || true) \
	\
# ---- Installing PHP Extension: mysql ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mysql \
	&& (rm -rf /usr/local/lib/php/test/mysql || true) \
	&& (rm -rf /usr/local/lib/php/doc/mysql || true) \
	\
# ---- Installing PHP Extension: mysqli ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) mysqli \
	&& (rm -rf /usr/local/lib/php/test/mysqli || true) \
	&& (rm -rf /usr/local/lib/php/doc/mysqli || true) \
	\
# ---- Installing PHP Extension: oauth ----
	&& pecl install oauth-1.2.3 \
	&& docker-php-ext-enable oauth \
	&& (rm -rf /usr/local/lib/php/test/oauth || true) \
	&& (rm -rf /usr/local/lib/php/doc/oauth || true) \
	\
# ---- Installing PHP Extension: oci8 ----
	&& ORACLE_HREF="$( curl -sS https://yum.oracle.com/repo/OracleLinux/OL7/oracle/instantclient/x86_64/ | tac | tac | grep -Eo 'href="getPackage/oracle-instantclient.+basiclite.+rpm"' | tail -1 )" \
&& ORACLE_VERSION_MAJOR="$( echo "${ORACLE_HREF}" | grep -Eo 'instantclient[.0-9]+' | sed 's/instantclient//g' )" \
&& ORACLE_VERSION_FULL="$( echo "${ORACLE_HREF}" | grep -Eo 'basiclite-[-.0-9]+' | sed -e 's/basiclite-//g' -e 's/\.$//g' )" \
\
&& rpm --import http://yum.oracle.com/RPM-GPG-KEY-oracle-ol7 \
&& curl -o /tmp/oracle-instantclient${ORACLE_VERSION_MAJOR}-basiclite-${ORACLE_VERSION_FULL}.x86_64.rpm \
  https://yum.oracle.com/repo/OracleLinux/OL7/oracle/instantclient/x86_64/getPackage/oracle-instantclient${ORACLE_VERSION_MAJOR}-basiclite-${ORACLE_VERSION_FULL}.x86_64.rpm \
&& curl -o /tmp/oracle-instantclient${ORACLE_VERSION_MAJOR}-devel-${ORACLE_VERSION_FULL}.x86_64.rpm \
  https://yum.oracle.com/repo/OracleLinux/OL7/oracle/instantclient/x86_64/getPackage/oracle-instantclient${ORACLE_VERSION_MAJOR}-devel-${ORACLE_VERSION_FULL}.x86_64.rpm \
&& alien -i /tmp/oracle-instantclient${ORACLE_VERSION_MAJOR}-basiclite-${ORACLE_VERSION_FULL}.x86_64.rpm \
&& alien -i /tmp/oracle-instantclient${ORACLE_VERSION_MAJOR}-devel-${ORACLE_VERSION_FULL}.x86_64.rpm \
&& rm -f /tmp/oracle-instantclient${ORACLE_VERSION_MAJOR}-basiclite-${ORACLE_VERSION_FULL}.x86_64.rpm \
&& rm -f /tmp/oracle-instantclient${ORACLE_VERSION_MAJOR}-devel-${ORACLE_VERSION_FULL}.x86_64.rpm \
&& (ln -s /usr/lib/oracle/${ORACLE_VERSION_MAJOR}/client64/lib/*.so* /usr/lib/ || true) \
 \
	&& /usr/local/bin/docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/lib/oracle/${ORACLE_VERSION_MAJOR}/client64/lib/,${ORACLE_VERSION_MAJOR} \
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) oci8 \
	&& (rm -rf /usr/local/lib/php/test/oci8 || true) \
	&& (rm -rf /usr/local/lib/php/doc/oci8 || true) \
	\
# ---- Installing PHP Extension: opcache ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) opcache \
	&& (rm -rf /usr/local/lib/php/test/opcache || true) \
	&& (rm -rf /usr/local/lib/php/doc/opcache || true) \
	\
# ---- Installing PHP Extension: pcntl ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pcntl \
	&& (rm -rf /usr/local/lib/php/test/pcntl || true) \
	&& (rm -rf /usr/local/lib/php/doc/pcntl || true) \
	\
# ---- Installing PHP Extension: pdo_dblib ----
	&& ln -s /usr/lib/x86_64-linux-gnu/libsybdb.* /usr/lib/ \
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pdo_dblib \
	&& (rm -rf /usr/local/lib/php/test/pdo_dblib || true) \
	&& (rm -rf /usr/local/lib/php/doc/pdo_dblib || true) \
	\
# ---- Installing PHP Extension: pdo_firebird ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pdo_firebird \
	&& (rm -rf /usr/local/lib/php/test/pdo_firebird || true) \
	&& (rm -rf /usr/local/lib/php/doc/pdo_firebird || true) \
	\
# ---- Installing PHP Extension: pdo_mysql ----
	&& /usr/local/bin/docker-php-ext-configure pdo_mysql --with-zlib-dir=/usr \
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pdo_mysql \
	&& (rm -rf /usr/local/lib/php/test/pdo_mysql || true) \
	&& (rm -rf /usr/local/lib/php/doc/pdo_mysql || true) \
	\
# ---- Installing PHP Extension: pdo_pgsql ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pdo_pgsql \
	&& (rm -rf /usr/local/lib/php/test/pdo_pgsql || true) \
	&& (rm -rf /usr/local/lib/php/doc/pdo_pgsql || true) \
	\
# ---- Installing PHP Extension: pgsql ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pgsql \
	&& (rm -rf /usr/local/lib/php/test/pgsql || true) \
	&& (rm -rf /usr/local/lib/php/doc/pgsql || true) \
	\
# ---- Installing PHP Extension: phalcon ----
	&& git clone https://github.com/phalcon/cphalcon /tmp/phalcon \
	&& cd /tmp/phalcon \
	&& git checkout v3.4.2 \
	&& cd build && ./install \
	&& docker-php-ext-enable phalcon \
	&& (rm -rf /usr/local/lib/php/test/phalcon || true) \
	&& (rm -rf /usr/local/lib/php/doc/phalcon || true) \
	\
# ---- Installing PHP Extension: pspell ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pspell \
	&& (rm -rf /usr/local/lib/php/test/pspell || true) \
	&& (rm -rf /usr/local/lib/php/doc/pspell || true) \
	\
# ---- Installing PHP Extension: recode ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) recode \
	&& (rm -rf /usr/local/lib/php/test/recode || true) \
	&& (rm -rf /usr/local/lib/php/doc/recode || true) \
	\
# ---- Installing PHP Extension: redis ----
	&& pecl install redis \
	&& docker-php-ext-enable redis \
	&& (rm -rf /usr/local/lib/php/test/redis || true) \
	&& (rm -rf /usr/local/lib/php/doc/redis || true) \
	\
# ---- Installing PHP Extension: rdkafka ----
	&& pecl install rdkafka-3.0.5 \
	&& docker-php-ext-enable rdkafka \
	&& (rm -rf /usr/local/lib/php/test/rdkafka || true) \
	&& (rm -rf /usr/local/lib/php/doc/rdkafka || true) \
	\
# ---- Installing PHP Extension: shmop ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) shmop \
	&& (rm -rf /usr/local/lib/php/test/shmop || true) \
	&& (rm -rf /usr/local/lib/php/doc/shmop || true) \
	\
# ---- Installing PHP Extension: snmp ----
	&& /usr/local/bin/docker-php-ext-configure snmp --with-openssl-dir \
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) snmp \
	&& (rm -rf /usr/local/lib/php/test/snmp || true) \
	&& (rm -rf /usr/local/lib/php/doc/snmp || true) \
	\
# ---- Installing PHP Extension: soap ----
	&& /usr/local/bin/docker-php-ext-configure soap --with-libxml-dir=/usr \
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) soap \
	&& (rm -rf /usr/local/lib/php/test/soap || true) \
	&& (rm -rf /usr/local/lib/php/doc/soap || true) \
	\
# ---- Installing PHP Extension: sockets ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) sockets \
	&& (rm -rf /usr/local/lib/php/test/sockets || true) \
	&& (rm -rf /usr/local/lib/php/doc/sockets || true) \
	\
# ---- Installing PHP Extension: swoole ----
	&& pecl install swoole-1.9.23 \
	&& docker-php-ext-enable swoole \
	&& (rm -rf /usr/local/lib/php/test/swoole || true) \
	&& (rm -rf /usr/local/lib/php/doc/swoole || true) \
	\
# ---- Installing PHP Extension: sysvmsg ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) sysvmsg \
	&& (rm -rf /usr/local/lib/php/test/sysvmsg || true) \
	&& (rm -rf /usr/local/lib/php/doc/sysvmsg || true) \
	\
# ---- Installing PHP Extension: sysvsem ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) sysvsem \
	&& (rm -rf /usr/local/lib/php/test/sysvsem || true) \
	&& (rm -rf /usr/local/lib/php/doc/sysvsem || true) \
	\
# ---- Installing PHP Extension: sysvshm ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) sysvshm \
	&& (rm -rf /usr/local/lib/php/test/sysvshm || true) \
	&& (rm -rf /usr/local/lib/php/doc/sysvshm || true) \
	\
# ---- Installing PHP Extension: tidy ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) tidy \
	&& (rm -rf /usr/local/lib/php/test/tidy || true) \
	&& (rm -rf /usr/local/lib/php/doc/tidy || true) \
	\
# ---- Installing PHP Extension: uploadprogress ----
	&& pecl install uploadprogress \
	&& docker-php-ext-enable uploadprogress \
	&& (rm -rf /usr/local/lib/php/test/uploadprogress || true) \
	&& (rm -rf /usr/local/lib/php/doc/uploadprogress || true) \
	\
# ---- Installing PHP Extension: wddx ----
	&& /usr/local/bin/docker-php-ext-configure wddx --with-libxml-dir=/usr \
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) wddx \
	&& (rm -rf /usr/local/lib/php/test/wddx || true) \
	&& (rm -rf /usr/local/lib/php/doc/wddx || true) \
	\
# ---- Installing PHP Extension: xdebug ----
	&& pecl install xdebug-2.4.1 \
	&& docker-php-ext-enable xdebug \
	&& (rm -rf /usr/local/lib/php/test/xdebug || true) \
	&& (rm -rf /usr/local/lib/php/doc/xdebug || true) \
	\
# ---- Installing PHP Extension: xmlrpc ----
	&& /usr/local/bin/docker-php-ext-configure xmlrpc --with-libxml-dir=/usr --with-iconv-dir=/usr \
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) xmlrpc \
	&& (rm -rf /usr/local/lib/php/test/xmlrpc || true) \
	&& (rm -rf /usr/local/lib/php/doc/xmlrpc || true) \
	\
# ---- Installing PHP Extension: xsl ----
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) xsl \
	&& (rm -rf /usr/local/lib/php/test/xsl || true) \
	&& (rm -rf /usr/local/lib/php/doc/xsl || true) \
	\
# ---- Installing PHP Extension: zip ----
	&& /usr/local/bin/docker-php-ext-configure zip --with-zlib-dir=/usr --with-pcre-dir=/usr \
	&& /usr/local/bin/docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) zip \
	&& (rm -rf /usr/local/lib/php/test/zip || true) \
	&& (rm -rf /usr/local/lib/php/doc/zip || true) \
	\
	&& if [ -f /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini ]; then \
			echo "ffi.enable = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini; \
		fi \
	&& chmod +x "$(php -r 'echo ini_get("extension_dir");')"/* \
	&& rm -rf /tmp/* \
	\
	&& DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false ${BUILD_DEPS} \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests ${RUN_DEPS} \
	&& DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false apt-utils \
	&& rm -rf /var/lib/apt/lists/* \
	\
	&& update-ca-certificates \
	\
	&& (find /usr/local/bin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
	&& (find /usr/local/lib -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
	&& (find /usr/local/sbin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
	&& (find "$(php -r 'echo ini_get("extension_dir");')" -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true)


###
### Verify
###
RUN set -x \
	&& echo "date.timezone=UTC" > /usr/local/etc/php/php.ini \
	&& php -v | grep -oE 'PHP\s[.0-9]+' | grep -oE '[.0-9]+' | grep '^5.5' \
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
	&& rm -f /usr/local/etc/php/php.ini \
	\
	&& php -m | grep -oiE '^amqp$' \
	&& php-fpm -m | grep -oiE '^amqp$' \
	&& php -m | grep -oiE '^apcu$' \
	&& php-fpm -m | grep -oiE '^apcu$' \
	&& php -m | grep -oiE '^bcmath$' \
	&& php-fpm -m | grep -oiE '^bcmath$' \
	&& php -m | grep -oiE '^bz2$' \
	&& php-fpm -m | grep -oiE '^bz2$' \
	&& php -m | grep -oiE '^calendar$' \
	&& php-fpm -m | grep -oiE '^calendar$' \
	&& php -m | grep -oiE '^ctype$' \
	&& php-fpm -m | grep -oiE '^ctype$' \
	&& php -m | grep -oiE '^curl$' \
	&& php-fpm -m | grep -oiE '^curl$' \
	&& php -m | grep -oiE '^dba$' \
	&& php-fpm -m | grep -oiE '^dba$' \
	&& php -m | grep -oiE '^dom$' \
	&& php-fpm -m | grep -oiE '^dom$' \
	&& php -m | grep -oiE '^enchant$' \
	&& php-fpm -m | grep -oiE '^enchant$' \
	&& php -m | grep -oiE '^exif$' \
	&& php-fpm -m | grep -oiE '^exif$' \
	&& php -m | grep -oiE '^fileinfo$' \
	&& php-fpm -m | grep -oiE '^fileinfo$' \
	&& php -m | grep -oiE '^filter$' \
	&& php-fpm -m | grep -oiE '^filter$' \
	&& php -m | grep -oiE '^ftp$' \
	&& php-fpm -m | grep -oiE '^ftp$' \
	&& php -m | grep -oiE '^gd$' \
	&& php-fpm -m | grep -oiE '^gd$' \
	&& php -m | grep -oiE '^gettext$' \
	&& php-fpm -m | grep -oiE '^gettext$' \
	&& php -m | grep -oiE '^gmp$' \
	&& php-fpm -m | grep -oiE '^gmp$' \
	&& php -m | grep -oiE '^hash$' \
	&& php-fpm -m | grep -oiE '^hash$' \
	&& php -m | grep -oiE '^iconv$' \
	&& php-fpm -m | grep -oiE '^iconv$' \
	&& php -m | grep -oiE '^igbinary$' \
	&& php-fpm -m | grep -oiE '^igbinary$' \
	&& php -m | grep -oiE '^imagick$' \
	&& php-fpm -m | grep -oiE '^imagick$' \
	&& php -m | grep -oiE '^imap$' \
	&& php-fpm -m | grep -oiE '^imap$' \
	&& php -m | grep -oiE '^interbase$' \
	&& php-fpm -m | grep -oiE '^interbase$' \
	&& php -m | grep -oiE '^intl$' \
	&& php-fpm -m | grep -oiE '^intl$' \
	&& php -m | grep -oiE '^json$' \
	&& php-fpm -m | grep -oiE '^json$' \
	&& php -m | grep -oiE '^ldap$' \
	&& php-fpm -m | grep -oiE '^ldap$' \
	&& php -m | grep -oiE '^libxml$' \
	&& php-fpm -m | grep -oiE '^libxml$' \
	&& php -m | grep -oiE '^mbstring$' \
	&& php-fpm -m | grep -oiE '^mbstring$' \
	&& php -m | grep -oiE '^mcrypt$' \
	&& php-fpm -m | grep -oiE '^mcrypt$' \
	&& php -m | grep -oiE '^msgpack$' \
	&& php-fpm -m | grep -oiE '^msgpack$' \
	&& php -m | grep -oiE '^memcache$' \
	&& php-fpm -m | grep -oiE '^memcache$' \
	&& php -m | grep -oiE '^memcached$' \
	&& php-fpm -m | grep -oiE '^memcached$' \
	&& php -m | grep -oiE '^mongo$' \
	&& php-fpm -m | grep -oiE '^mongo$' \
	&& php -m | grep -oiE '^mongodb$' \
	&& php-fpm -m | grep -oiE '^mongodb$' \
	&& php -m | grep -oiE '^mysql$' \
	&& php-fpm -m | grep -oiE '^mysql$' \
	&& php -m | grep -oiE '^mysqli$' \
	&& php-fpm -m | grep -oiE '^mysqli$' \
	&& php -m | grep -oiE '^mysqlnd$' \
	&& php-fpm -m | grep -oiE '^mysqlnd$' \
	&& php -m | grep -oiE '^oauth$' \
	&& php-fpm -m | grep -oiE '^oauth$' \
	&& php -m | grep -oiE '^oci8$' \
	&& php-fpm -m | grep -oiE '^oci8$' \
	&& php -m | grep -oiE '^Zend Opcache$' \
	&& php-fpm -m | grep -oiE '^Zend Opcache$' \
	&& php -m | grep -oiE '^openssl$' \
	&& php-fpm -m | grep -oiE '^openssl$' \
	&& php -m | grep -oiE '^pcntl$' \
	&& php-fpm -m | grep -oiE '^pcntl$' \
	&& php -m | grep -oiE '^pcre$' \
	&& php-fpm -m | grep -oiE '^pcre$' \
	&& php -m | grep -oiE '^pdo$' \
	&& php-fpm -m | grep -oiE '^pdo$' \
	&& php -m | grep -oiE '^pdo_dblib$' \
	&& php-fpm -m | grep -oiE '^pdo_dblib$' \
	&& php -m | grep -oiE '^pdo_firebird$' \
	&& php-fpm -m | grep -oiE '^pdo_firebird$' \
	&& php -m | grep -oiE '^pdo_mysql$' \
	&& php-fpm -m | grep -oiE '^pdo_mysql$' \
	&& php -m | grep -oiE '^pdo_pgsql$' \
	&& php-fpm -m | grep -oiE '^pdo_pgsql$' \
	&& php -m | grep -oiE '^pdo_sqlite$' \
	&& php-fpm -m | grep -oiE '^pdo_sqlite$' \
	&& php -m | grep -oiE '^pgsql$' \
	&& php-fpm -m | grep -oiE '^pgsql$' \
	&& php -m | grep -oiE '^phalcon$' \
	&& php-fpm -m | grep -oiE '^phalcon$' \
	&& php -m | grep -oiE '^phar$' \
	&& php-fpm -m | grep -oiE '^phar$' \
	&& php -m | grep -oiE '^posix$' \
	&& php-fpm -m | grep -oiE '^posix$' \
	&& php -m | grep -oiE '^pspell$' \
	&& php-fpm -m | grep -oiE '^pspell$' \
	&& php -m | grep -oiE '^readline$' \
	&& php -m | grep -oiE '^recode$' \
	&& php-fpm -m | grep -oiE '^recode$' \
	&& php -m | grep -oiE '^redis$' \
	&& php-fpm -m | grep -oiE '^redis$' \
	&& php -m | grep -oiE '^reflection$' \
	&& php-fpm -m | grep -oiE '^reflection$' \
	&& php -m | grep -oiE '^rdkafka$' \
	&& php-fpm -m | grep -oiE '^rdkafka$' \
	&& php -m | grep -oiE '^session$' \
	&& php-fpm -m | grep -oiE '^session$' \
	&& php -m | grep -oiE '^shmop$' \
	&& php-fpm -m | grep -oiE '^shmop$' \
	&& php -m | grep -oiE '^simplexml$' \
	&& php-fpm -m | grep -oiE '^simplexml$' \
	&& php -m | grep -oiE '^snmp$' \
	&& php-fpm -m | grep -oiE '^snmp$' \
	&& php -m | grep -oiE '^soap$' \
	&& php-fpm -m | grep -oiE '^soap$' \
	&& php -m | grep -oiE '^sockets$' \
	&& php-fpm -m | grep -oiE '^sockets$' \
	&& php -m | grep -oiE '^spl$' \
	&& php-fpm -m | grep -oiE '^spl$' \
	&& php -m | grep -oiE '^swoole$' \
	&& php-fpm -m | grep -oiE '^swoole$' \
	&& php -m | grep -oiE '^sysvmsg$' \
	&& php-fpm -m | grep -oiE '^sysvmsg$' \
	&& php -m | grep -oiE '^sysvsem$' \
	&& php-fpm -m | grep -oiE '^sysvsem$' \
	&& php -m | grep -oiE '^sysvshm$' \
	&& php-fpm -m | grep -oiE '^sysvshm$' \
	&& php -m | grep -oiE '^tidy$' \
	&& php-fpm -m | grep -oiE '^tidy$' \
	&& php -m | grep -oiE '^tokenizer$' \
	&& php-fpm -m | grep -oiE '^tokenizer$' \
	&& php -m | grep -oiE '^uploadprogress$' \
	&& php-fpm -m | grep -oiE '^uploadprogress$' \
	&& php -m | grep -oiE '^wddx$' \
	&& php-fpm -m | grep -oiE '^wddx$' \
	&& php -m | grep -oiE '^xdebug$' \
	&& php-fpm -m | grep -oiE '^xdebug$' \
	&& php -m | grep -oiE '^xml$' \
	&& php-fpm -m | grep -oiE '^xml$' \
	&& php -m | grep -oiE '^xmlreader$' \
	&& php-fpm -m | grep -oiE '^xmlreader$' \
	&& php -m | grep -oiE '^xmlrpc$' \
	&& php-fpm -m | grep -oiE '^xmlrpc$' \
	&& php -m | grep -oiE '^xmlwriter$' \
	&& php-fpm -m | grep -oiE '^xmlwriter$' \
	&& php -m | grep -oiE '^xsl$' \
	&& php-fpm -m | grep -oiE '^xsl$' \
	&& php -m | grep -oiE '^zip$' \
	&& php-fpm -m | grep -oiE '^zip$' \
	&& true


###
### Ports
###
EXPOSE 9000


###
### Entrypoint
###
ENTRYPOINT ["/docker-entrypoint.sh"]
