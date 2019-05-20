# Auto-generated via Ansible: edit build/ansible/DOCKERFILES/Dockerfile-work.j2 instead.
FROM devilbox/php-fpm:7.0-prod
MAINTAINER "cytopia" <cytopia@everythingcli.org>


###
### Labels
###
LABEL \
	name="cytopia's PHP-FPM 7.0 Image" \
	image="devilbox/php-fpm" \
	tag="7.0-work" \
	vendor="devilbox" \
	license="MIT"


###
### Envs
###
ENV BASH_PROFILE=".bashrc"


###
### Install Tools
###
RUN set -x \
	&& DEBIAN_FRONTEND=noninteractive apt-get update -qq \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests apt-utils \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
		curl \
		dirmngr \
		gnupg \
	&& echo "deb http://ftp.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/backports.list \
	&& curl -sS "https://packages.blackfire.io/gpg.key" 2>/dev/null | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - \
	&& echo "deb http://packages.blackfire.io/debian any main" > /etc/apt/sources.list.d/blackfire.list \
	&& APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv A1715D88E1DF1F24 \
	&& echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu wily main" > /etc/apt/sources.list.d/git.list \
	&& APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 \
	&& echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" > /etc/apt/sources.list.d/mongo.list \
	&& curl -sS https://www.postgresql.org/media/keys/ACCC4CF8.asc 2>/dev/null | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - \
	&& echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgsql.list \
	&& curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg 2>/dev/null | APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1 apt-key add - \
	&& echo "deb http://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
	&& DEBIAN_FRONTEND=noninteractive apt-get update -qq \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
		ack-grep \
		aspell \
		autoconf \
		automake \
		bash-completion \
		binutils \
		blackfire-agent \
		build-essential \
		bzip2 \
		coreutils \
		dnsutils \
		dos2unix \
		file \
		gawk \
		gcc \
		git \
		git-flow \
		git-svn \
		graphviz \
		hostname \
		htop \
		imagemagick \
		iputils-ping \
		jq \
		less \
		libc-dev \
		libffi-dev \
		libssl-dev \
		libyaml-dev \
		make \
		mongodb-org-shell \
		mongodb-org-tools \
		moreutils \
		mysql-client \
		nano \
		net-tools \
		netcat \
		openssh-client \
		patch \
		patchelf \
		postgresql-client \
		redis-tools \
		rsync \
		rubygems \
		ruby-dev \
		shellcheck \
		silversearcher-ag \
		subversion \
		sudo \
		tig \
		tree \
		unzip \
		vim \
		w3m \
		wget \
		whois \
		xz-utils \
		yarn \
		zip \
		zlib1g-dev \
		zsh \
	&& DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false apt-utils \
	&& rm -rf /var/lib/apt/lists/* \
	\
	&& (find /usr/local/bin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
	&& (find /usr/local/lib -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
	&& (find /usr/local/sbin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true)


###
### Install custom software
###
RUN set -x \
# composer
	&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
# pip
	&& DEBIAN_FRONTEND=noninteractive apt-get update -qq \
&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
  libpython-dev \
&& DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
&& rm -rf /var/lib/apt/lists/* \
\
&& curl -sS https://bootstrap.pypa.io/get-pip.py | python \
 \
# nvm
	&& git clone https://github.com/creationix/nvm /opt/nvm \
&& cd /opt/nvm \
&& git checkout "$(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))" \
\
&& { \
  echo 'export NVM_DIR="/opt/nvm"'; \
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm'; \
  echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion'; \
} >> /home/devilbox/.bashrc \
\
&& chown -R devilbox:devilbox /opt/nvm \
 \
	&& su  -c '. /opt/nvm/nvm.sh; nvm install node' devilbox \
&& su  -c '. /opt/nvm/nvm.sh; nvm install --lts' devilbox \
&& su  -c '. /opt/nvm/nvm.sh; nvm use node' devilbox \
 \
# awesomeci
	&& git clone https://github.com/cytopia/awesome-ci.git /usr/local/src/awesome-ci \
&& cd /usr/local/src/awesome-ci \
&& git checkout $(git describe --abbrev=0 --tags) \
&& ./configure --prefix=/usr/local \
&& make install \
&& cd / \
&& rm -rf /usr/local/src/awesome-ci \
 \
# deployer
	&& curl -sS https://deployer.org/deployer.phar -L -o /usr/local/bin/dep \
	&& chmod +x /usr/local/bin/dep \
# drush7
	&& git clone https://github.com/drush-ops/drush.git /usr/local/src/drush7 \
&& cd /usr/local/src/drush7 \
&& git checkout 7.4.0 \
 \
	&& chown -R ${MY_USER}:${MY_GROUP} /usr/local/src/drush7 \
&& su - ${MY_USER} -c 'PATH=/usr/local/bin:$PATH; cd /usr/local/src/drush7 && composer install --no-interaction --no-progress --no-dev' \
&& ln -s /usr/local/src/drush7/drush /usr/local/bin/drush7 \
&& rm -rf /usr/local/src/drush7/.git \
&& rm -rf /usr/local/src/drush7/docs \
&& rm -rf /usr/local/src/drush7/examples \
&& rm -rf /usr/local/src/drush7/misc \
 \
# drush8
	&& git clone https://github.com/drush-ops/drush.git /usr/local/src/drush8 \
&& cd /usr/local/src/drush8 \
&& git checkout $( git for-each-ref --format='%(*creatordate:raw)%(creatordate:raw) %(refname)' refs/tags | sort -n | grep -E 'tags/8[.0-9]+$' | tail -1 | sed 's|.*/||g' ) \
 \
	&& chown -R ${MY_USER}:${MY_GROUP} /usr/local/src/drush8 \
&& su - ${MY_USER} -c 'PATH=/usr/local/bin:$PATH; cd /usr/local/src/drush8 && composer install --no-interaction --no-progress --no-dev' \
&& ln -s /usr/local/src/drush8/drush /usr/local/bin/drush8 \
&& rm -rf /usr/local/src/drush8/.git \
&& rm -rf /usr/local/src/drush8/docs \
&& rm -rf /usr/local/src/drush8/examples \
&& rm -rf /usr/local/src/drush8/misc \
 \
# drush9
	&& git clone https://github.com/drush-ops/drush.git /usr/local/src/drush9 \
&& cd /usr/local/src/drush9 \
&& git checkout $( git for-each-ref --format='%(*creatordate:raw)%(creatordate:raw) %(refname)' refs/tags | sort -n | grep -E 'tags/9[.0-9]+$' | tail -1 | sed 's|.*/||g' ) \
 \
	&& chown -R ${MY_USER}:${MY_GROUP} /usr/local/src/drush9 \
&& su - ${MY_USER} -c 'PATH=/usr/local/bin:$PATH; cd /usr/local/src/drush9 && php -d memory_limit=-1 `which composer` install --no-interaction --no-progress' \
&& ln -s /usr/local/src/drush9/drush /usr/local/bin/drush9 \
&& rm -rf /usr/local/src/drush9/.git \
&& rm -rf /usr/local/src/drush9/docs \
&& rm -rf /usr/local/src/drush9/examples \
&& rm -rf /usr/local/src/drush9/misc \
 \
# drupalconsole
	&& curl https://drupalconsole.com/installer -L -o /usr/local/bin/drupal \
	&& chmod +x /usr/local/bin/drupal \
# gitflow
	&& git clone git://github.com/petervanderdoes/gitflow.git /tmp/gitflow \
&& cd /tmp/gitflow \
&& make install \
&& cd / && rm -rf /tmp/gitflow \
 \
# laravel
	&& git clone https://github.com/laravel/installer /usr/local/src/laravel-installer \
&& cd /usr/local/src/laravel-installer \
&& git checkout v2.0.0 \
 \
	&& chown -R ${MY_USER}:${MY_GROUP} /usr/local/src/laravel-installer \
&& su - ${MY_USER} -c 'PATH=/usr/local/bin:$PATH; cd /usr/local/src/laravel-installer && composer install --no-interaction --no-progress --no-dev' \
&& ln -s /usr/local/src/laravel-installer/laravel /usr/local/bin/laravel \
&& rm -rf /usr/local/src/laravel-installer/laravel/.git \
 \
# linkcheck
	&& curl https://raw.githubusercontent.com/cytopia/linkcheck/master/linkcheck > /usr/local/bin/linkcheck \
&& chmod +x /usr/local/bin/linkcheck \
 \
# linuxbrew
	&& git clone https://github.com/Linuxbrew/brew.git /usr/local/src/linuxbrew \
&& chown -R ${MY_USER}:${MY_GROUP} /usr/local/src/linuxbrew \
&& v="${BASH_PROFILE}" su ${MY_USER} -c -p \
    'echo "PATH=/usr/local/src/linuxbrew/bin:/usr/local/src/linuxbrew/sbin:/usr/bin:/usr/sbin:/bin:/sbin" >> /home/devilbox/${v}' \
&& v="${BASH_PROFILE}" su ${MY_USER} -c -p \
    'echo "export MANPATH=/usr/local/src/linuxbrew/share/man:${MANPATH}"   >> /home/devilbox/${v}' \
&& v="${BASH_PROFILE}" su ${MY_USER} -c -p \
    'echo "export INFOPATH=/usr/local/src/linuxbrew/share/man:${INFOPATH}" >> /home/devilbox/${v}' \
&& su - ${MY_USER} -c '/usr/local/src/linuxbrew/bin/brew config' \
 \
# mhsendmail
	&& wget https://github.com/mailhog/mhsendmail/releases/download/v0.2.0/mhsendmail_linux_amd64 \
&& chmod +x mhsendmail_linux_amd64 \
&& mv mhsendmail_linux_amd64 /usr/local/bin/mhsendmail \
 \
# mysqldumpsecure
	&& git clone https://github.com/cytopia/mysqldump-secure.git /usr/local/src/mysqldump-secure \
&& cd /usr/local/src/mysqldump-secure \
&& git checkout $(git describe --abbrev=0 --tags) \
&& cp /usr/local/src/mysqldump-secure/bin/mysqldump-secure /usr/local/bin \
&& cp /usr/local/src/mysqldump-secure/etc/mysqldump-secure.conf /etc \
&& cp /usr/local/src/mysqldump-secure/etc/mysqldump-secure.cnf /etc \
&& touch /var/log/mysqldump-secure.log \
&& chown ${MY_USER}:${MY_GROUP} /etc/mysqldump-secure.* \
&& chown ${MY_USER}:${MY_GROUP} /var/log/mysqldump-secure.log \
&& chmod 0400 /etc/mysqldump-secure.conf \
&& chmod 0400 /etc/mysqldump-secure.cnf \
&& chmod 0644 /var/log/mysqldump-secure.log \
&& sed -i'' 's/^COMPRESS_ARG=.*/COMPRESS_ARG="-9 -c"/g' /etc/mysqldump-secure.conf \
&& sed -i'' 's/^DUMP_DIR=.*/DUMP_DIR="\/shared\/backups\/mysql"/g' /etc/mysqldump-secure.conf \
&& sed -i'' 's/^DUMP_DIR_CHMOD=.*/DUMP_DIR_CHMOD="0755"/g' /etc/mysqldump-secure.conf \
&& sed -i'' 's/^DUMP_FILE_CHMOD=.*/DUMP_FILE_CHMOD="0644"/g' /etc/mysqldump-secure.conf \
&& sed -i'' 's/^LOG_CHMOD=.*/LOG_CHMOD="0644"/g' /etc/mysqldump-secure.conf \
&& sed -i'' 's/^NAGIOS_LOG=.*/NAGIOS_LOG=0/g' /etc/mysqldump-secure.conf \
&& cd / \
&& rm -rf /usr/local/src/mysqldump-secure \
 \
# phalcon
	&& git clone https://github.com/phalcon/phalcon-devtools /usr/local/src/phalcon-devtools \
&& cd /usr/local/src/phalcon-devtools \
&& git checkout $(git describe --abbrev=0 --tags) \
 \
	&& chown -R ${MY_USER}:${MY_GROUP} /usr/local/src/phalcon-devtools \
&& su - ${MY_USER} -c 'cd /usr/local/src/phalcon-devtools && ./phalcon.sh' \
&& ln -s /usr/local/src/phalcon-devtools/phalcon.php /usr/local/bin/phalcon \
&& cd / \
&& rm -rf /usr/local/src/phalcon-devtools/.git \
 \
# phpcs
	&& curl -sS -L https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar > /usr/local/bin/phpcs 2>/dev/null \
&& chmod +x /usr/local/bin/phpcs \
 \
# phpcbf
	&& curl -sS -L https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar > /usr/local/bin/phpcbf 2>/dev/null \
&& chmod +x /usr/local/bin/phpcbf \
 \
# php-cs-fixer
	&& curl -sS -L https://cs.symfony.com/download/php-cs-fixer-v2.phar > /usr/local/bin/php-cs-fixer 2>/dev/null \
&& chmod +x /usr/local/bin/php-cs-fixer \
 \
# phpunit
	&& curl -qL https://phar.phpunit.de/phpunit-6.phar > /usr/local/bin/phpunit 2>/dev/null \
&& chmod +x /usr/local/bin/phpunit \
 \
# symfony
	&& curl https://symfony.com/installer -L -o /usr/local/bin/symfony \
	&& chmod +x /usr/local/bin/symfony \
# wkhtmltopdf
	&& VERSION="$( curl -sSL https://github.com/wkhtmltopdf/wkhtmltopdf/releases | grep -Eo '/wkhtmltopdf/.+stretch_amd64\.deb' | head -1 )" \
	&& DEBIAN_FRONTEND=noninteractive apt-get update -qq \
&& DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
  libfontenc1 libxfont1 xfonts-75dpi xfonts-base xfonts-encodings xfonts-utils \
&& curl -sS -L -o /tmp/wkhtmltopdf.deb  https://github.com/${VERSION} \
&& dpkg -i /tmp/wkhtmltopdf.deb \
&& rm -f /tmp/wkhtmltopdf.deb \
 \
	&& DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false apt-utils \
&& rm -rf /var/lib/apt/lists/* \
 \
# wpcli
	&& curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -L -o /usr/local/bin/wp \
	&& chmod +x /usr/local/bin/wp \
# cleanup
	&& rm -rf /home/${MY_USER}/.*json \
&& rm -rf /home/${MY_USER}/.cache \
&& rm -rf /home/${MY_USER}/.composer \
&& rm -rf /home/${MY_USER}/.config \
&& rm -rf /home/${MY_USER}/.drush \
&& rm -rf /home/${MY_USER}/.subversion \
&& rm -rf /home/${MY_USER}/.v8* \
\
&& rm -rf /root/.*json \
&& rm -rf /root/.cache \
&& rm -rf /root/.composer \
&& rm -rf /root/.config \
&& rm -rf /root/.drush \
&& rm -rf /root/.subversion \
&& rm -rf /root/.v8* \
\
&& rm -rf /tmp/* \
&& (rm -rf /tmp/.* || true) \
 \
	\
	&& (rm -rf /root/.gem || true ) \
	&& (rm -rf /root/.cache || true) \
	&& (rm -rf /root/.composer || true) \
	&& (rm -rf /root/.config || true) \
	&& (rm -rf /root/.npm || true) \
	\
	&& (rm -rf /home/devilbox/.cache || true) \
	&& (rm -rf /home/devilbox/.composer || true) \
	&& (rm -rf /home/devilbox/.config || true) \
	&& (rm -rf /home/devilbox/.npm || true) \
	\
	&& (rm -rf /usr/local/src/composer/cache/* || true) \
	&& rm -rf /tmp/* \
	&& (rm -rf /tmp/.* || true)


###
### Install Composer (PHP)
###
RUN set -x \
# asgardcms
	&& COMPOSER_HOME="/usr/local/src/composer" composer global require  asgardcms/asgardcms-installer \
	&& ln -s /usr/local/src/composer/vendor/asgardcms/asgardcms-installer/asgardcms /usr/local/bin/ \
# codeception
	&& COMPOSER_HOME="/usr/local/src/composer" composer global require  codeception/codeception \
	&& ln -s /usr/local/src/composer/vendor/codeception/codeception/codecept /usr/local/bin/ \
# lumen
	&& COMPOSER_HOME="/usr/local/src/composer" composer global require  laravel/lumen-installer \
	&& ln -s /usr/local/src/composer/vendor/laravel/lumen-installer/lumen /usr/local/bin/ \
# photon
	&& COMPOSER_HOME="/usr/local/src/composer" composer global require  photoncms/installer \
	&& ln -s /usr/local/src/composer/vendor/photoncms/installer/photon /usr/local/bin/ \
# prestissimo
	&& COMPOSER_HOME="/usr/local/src/composer" composer global require  hirak/prestissimo \
	\
	&& rm -rf /tmp/* \
	&& (rm -rf /tmp/.* || true) \
	\
	&& (find /usr/local/bin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
	&& (find /usr/local/lib -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
	&& (find /usr/local/sbin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true)


###
### Install npm (Node)
###
RUN set -x \
# angular_cli
	&& su -c '. /opt/nvm/nvm.sh; npm install -g @angular/cli' devilbox \
# eslint
	&& su -c '. /opt/nvm/nvm.sh; npm install -g eslint' devilbox \
# grunt
	&& su -c '. /opt/nvm/nvm.sh; npm install -g grunt' devilbox \
# grunt_cli
	&& su -c '. /opt/nvm/nvm.sh; npm install -g grunt-cli' devilbox \
# gulp
	&& su -c '. /opt/nvm/nvm.sh; npm install -g gulp' devilbox \
# jsonlint
	&& su -c '. /opt/nvm/nvm.sh; npm install -g jsonlint' devilbox \
# pm2
	&& su -c '. /opt/nvm/nvm.sh; npm install -g pm2' devilbox \
# mdlint
	&& su -c '. /opt/nvm/nvm.sh; npm install -g mdlint' devilbox \
# vue_cli
	&& su -c '. /opt/nvm/nvm.sh; npm install -g @vue/cli' devilbox \
# vue_cli_service_global
	&& su -c '. /opt/nvm/nvm.sh; npm install -g @vue/cli-service-global' devilbox \
# webpack
	&& su -c '. /opt/nvm/nvm.sh; npm install -g webpack' devilbox \
# webpack_cli
	&& su -c '. /opt/nvm/nvm.sh; npm install -g webpack-cli' devilbox \
	\
	&& ln -sf $(dirname $(su -c '. /opt/nvm/nvm.sh; nvm which current' devilbox))/* /usr/local/bin/ \
	\
	&& su -c '. /opt/nvm/nvm.sh; npm cache clear --force' devilbox \
	&& su -c '. /opt/nvm/nvm.sh; nvm cache clear --force' devilbox \
	&& rm -rf /home/devilbox/.npm \
	&& rm -rf /home/devilbox/.config \
	&& rm -rf /tmp/* \
	&& (rm -rf /tmp/.* || true) \
	\
	&& (find /opt/nvm -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true)


###
### Install gem (Ruby)
###
RUN set -x \
# mixlib_config
	&& gem install mixlib-config -v 2.2.4 \
# rb_inotify
	&& gem install rb-inotify -v 0.9.10 \
# mdl
	&& gem install mdl \
# scss_lint
	&& gem install scss_lint -v 0.57.1 \
# sass
	&& gem install sass \
	\
	&& rm -rf /root/.gem \
	&& rm -rf /tmp/* \
	&& (rm -rf /tmp/.* || true) \
	\
	&& (find /usr/local/bin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
	&& (find /usr/local/lib -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
	&& (find /usr/local/sbin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true)


###
### Install pip (Python) packages
###
RUN set -x \
# ansible
	&& pip install --no-cache-dir --force-reinstall ansible \
# yamllint
	&& pip install --no-cache-dir --force-reinstall yamllint \
# yq
	&& pip install --no-cache-dir --force-reinstall yq \
	\
	&& rm -rf /root/.cache/pip \
	&& rm -rf /tmp/* \
	&& (rm -rf /tmp/.* || true) \
	\
	&& (find /usr/local/bin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
	&& (find /usr/local/lib -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true) \
	&& (find /usr/local/sbin -type f -print0 | xargs -n1 -0 strip --strip-all -p 2>/dev/null || true)


###
### Configure Bash
###
RUN \
	{ \
		echo "PATH=\${PATH}:/usr/local/bin:/usr/local/sbin:\${HOME}/.yarn/bin:/opt/nvm/versions/node/\$(nvm version default)/bin"; \
		echo "export PATH"; \
		echo ". /etc/bash-devilbox"; \
		echo "if [ -d /etc/bashrc-devilbox.d/ ]; then"; \
		echo "    for f in /etc/bashrc-devilbox.d/*.sh ; do"; \
		echo "        if [ -r \"\${f}\" ]; then"; \
		echo "            . \"\${f}\""; \
		echo "        fi"; \
		echo "    done"; \
		echo "    unset f"; \
		echo "fi"; \
	} | tee -a /home/${MY_USER}/${BASH_PROFILE} /root/${BASH_PROFILE} \
	&& chown ${MY_USER}:${MY_GROUP} /home/${MY_USER}/${BASH_PROFILE}


###
### Verify
###
RUN set -x \
	&& echo "date.timezone=UTC" > /usr/local/etc/php/php.ini \
	&& php -v | grep -oE 'PHP\s[.0-9]+' | grep -oE '[.0-9]+' | grep '^7.0' \
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

RUN set -x \
	&& composer --version 2>/dev/null | grep -E 'version\s*[.0-9]+' \
	&& su  -c '. /opt/nvm/nvm.sh; nvm --version' devilbox | grep -E '^[.0-9]+' \
	&& mdl --version | grep -E '[.0-9]+' \
&& scss-lint --version | grep -E '[.0-9]+' \
&& eslint -v | grep -E '[.0-9]+' \
&& jsonlint --version | grep -E '[.0-9]+' \
&& mdlint --version | grep -E '[.0-9]+' \
&& gulp --version | grep -E '[.0-9]+' \
 \
	&& dep --version 2>/dev/null | grep -Ei 'deployer\s*(version\s*)?[.0-9]+' \
	&& drush7 --version | grep -E '7[.0-9]+\s*$' \
	&& drush8 --version | grep -E '8[.0-9]+\s*$' \
	&& drush9 --version | grep -E '9[.0-9]+\s*$' \
	&& drupal --version | grep -E 'Drupal Console Launcher\s*[.0-9]' \
	&& git-flow version | grep -E '[.0-9]+' \
	&& laravel --version | grep -E '(Installer|version)\s*[.0-9]+' \
	&& linkcheck --version | grep -E '^linkcheck\sv[.0-9]+' \
	&& su - ${MY_USER} -c '/usr/local/src/linuxbrew/bin/brew --version' | grep -E 'Homebrew\s*[.0-9]+' \
	&& mysqldump-secure --version | grep -E 'Version:\s*[.0-9]+' \
	&& phalcon commands | grep -E '[.0-9]+' \
	&& phpcs --version | grep -E 'version [.0-9]+' \
	&& phpcbf --version | grep -E 'version [.0-9]+' \
	&& php-cs-fixer --version 2>&1 | grep -E 'Fixer\s+(version\s*)?[-_.0-9]+\s+' \
	&& phpunit --version | grep -iE '^PHPUnit\s[.0-9]+' \
	&& symfony --version | grep -E 'version\s*[.0-9]+' \
	&& wkhtmltopdf --version | grep -E "^wkhtmltopdf [.0-9]+\s+\(.+patched.+\)" \
	&& wp --allow-root --version | grep -E '[.0-9]+' \
 \
	&& asgardcms --version 2>/dev/null | grep -Ei 'AsgardCMS\sInstaller\s[.0-9]+' \
	&& codecept --version 2>/dev/null | grep -E '^Codeception(\sversion)?\s[.0-9]+$' \
	&& lumen --version 2>/dev/null | grep -E '^Lumen Installer\s[.0-9]+$' \
	&& photon --version | grep -E 'Installer [.0-9]+' \
 \
	&& ansible --version | grep -E '^ansible [.0-9]+$' \
	&& yamllint --version 2>&1 | grep -E '[.0-9]+' \
	&& yq --version 2>&1 | grep -E '^yq\s+[.0-9]+$' \
 \
	&& ng  version 2>&1 | grep -iE 'Angular CLI:\s*[.0-9]+' \
	&& eslint -v | grep -E '[.0-9]+' \
	&& grunt --version | grep -E '[.0-9]+' \
	&& gulp --version | grep -E '[.0-9]+' \
	&& jsonlint --version | grep -E '[.0-9]+' \
	&& pm2 --no-daemon --version | grep -E '[.0-9]+' \
	&& mdlint --version | grep -E '[.0-9]+' \
	&& vue --version | grep -E '[.0-9]+' \
	&& webpack --version | grep -E '[.0-9]+' \
 \
	&& mdl --version | grep -E '[.0-9]+' \
	&& sass --version | grep -E '[.0-9]+' \
 \
	&& rm -rf /home/devilbox/.config/ \
	&& rm -rf /root/.ansible \
	&& rm -rf /root/.console \
	&& rm -rf /root/.composer \
	&& rm -rf /root/.drush \
	&& rm -rf /root/.pm2 \
	&& rm -rf /tmp/* \
	&& (rm -rf /tmp/.* || true)


###
### Copy files
###
COPY ./data/php-ini.d/php-7.0.ini /usr/local/etc/php/conf.d/xxx-devilbox-default-php.ini
COPY ./data/php-fpm.conf/php-fpm-7.0.conf /usr/local/etc/php-fpm.conf

COPY ./data/docker-entrypoint.sh /docker-entrypoint.sh
COPY ./data/docker-entrypoint.d/*.sh /docker-entrypoint.d/
COPY ./data/bash-devilbox /etc/bash-devilbox
COPY ./data/sudo-devilbox /etc/sudoers.d/devilbox



###
### Volumes
###
VOLUME /shared/backups
VOLUME /var/log/php
VOLUME /var/mail


###
### Ports
###
EXPOSE 9000


###
### Where to start inside the container
###
WORKDIR /shared/httpd


###
### Entrypoint
###
ENTRYPOINT ["/docker-entrypoint.sh"]
