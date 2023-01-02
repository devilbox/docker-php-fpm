# PHP-FPM Docker images

[![Release](https://img.shields.io/github/release/devilbox/docker-php-fpm.svg?colorB=orange)](https://github.com/devilbox/docker-php-fpm/releases)
[![](https://img.shields.io/badge/github-devilbox%2Fdocker--php--fpm-red.svg)](https://github.com/devilbox/docker-php-fpm "github.com/devilbox/docker-php-fpm")
[![lint](https://github.com/devilbox/docker-php-fpm/workflows/lint/badge.svg)](https://github.com/devilbox/docker-php-fpm/actions?workflow=lint)
[![build](https://github.com/devilbox/docker-php-fpm/workflows/build/badge.svg)](https://github.com/devilbox/docker-php-fpm/actions?workflow=build)
[![nightly](https://github.com/devilbox/docker-php-fpm/workflows/nightly/badge.svg)](https://github.com/devilbox/docker-php-fpm/actions?workflow=nightly)
[![License](https://img.shields.io/badge/license-MIT-%233DA639.svg)](https://opensource.org/licenses/MIT)

[![Discord](https://img.shields.io/discord/1051541389256704091?color=8c9eff&label=Discord&logo=discord)](https://discord.gg/2wP3V6kBj4)
[![Discourse](https://img.shields.io/discourse/https/devilbox.discourse.group/status.svg?colorB=%234CB697&label=Discourse&logo=discourse)](https://devilbox.discourse.group)

**Available Architectures:**  `amd64`, `arm64`

[![](https://img.shields.io/docker/pulls/devilbox/php-fpm.svg)](https://hub.docker.com/r/devilbox/php-fpm)

This repository will provide you fully functional PHP-FPM Docker images in different flavours,
versions and packed with different types of integrated PHP modules. It also solves the problem of **[syncronizing file permissions](doc/syncronize-file-permissions.md)** of mounted volumes between the host and the container.

:information_source: For details see **[Documentation: Syncronize File Permissions](doc/syncronize-file-permissions.md)**

This repository also allows you to quickly generate and **build your own custom PHP-FPM Docker image** with whatever PHP extension your desire for whatever PHP version you want and for any platform you're on (`amd64` or `arm64`). Jump to **[#Build your own image](#build-your-own-image)**.


| PHP-FPM          | Reference Implementation |
|:----------------:|:------------------------:|
| <a title="Docker PHP-FPM" href="https://github.com/devilbox/docker-php-fpm" ><img height="82px" src="https://raw.githubusercontent.com/devilbox/artwork/master/submissions_banner/cytopia/02/png/banner_256_trans.png" /></a> | <a title="Devilbox" href="https://github.com/cytopia/devilbox" ><img height="82px" src="https://raw.githubusercontent.com/devilbox/artwork/master/submissions_banner/cytopia/01/png/banner_256_trans.png" /></a> |
| Streamlined [PHP-FPM](https://github.com/devilbox/docker-php-fpm) images | The [Devilbox](https://github.com/cytopia/devilbox) |



<h2><img id="docker-tags" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Docker Tags</h2>

[![](https://img.shields.io/docker/pulls/devilbox/php-fpm.svg)](https://hub.docker.com/r/devilbox/php-fpm)

```bash
docker pull devilbox/php-fpm:<tag>
```

* [`5.2-base`](Dockerfiles/base/Dockerfile-5.2), [`5.3-base`](Dockerfiles/base/Dockerfile-5.3), [`5.4-base`](Dockerfiles/base/Dockerfile-5.4), [`5.5-base`](Dockerfiles/base/Dockerfile-5.5), [`5.6-base`](Dockerfiles/base/Dockerfile-5.6), [`7.0-base`](Dockerfiles/base/Dockerfile-7.0), [`7.1-base`](Dockerfiles/base/Dockerfile-7.1), [`7.2-base`](Dockerfiles/base/Dockerfile-7.2), [`7.3-base`](Dockerfiles/base/Dockerfile-7.3), [`7.4-base`](Dockerfiles/base/Dockerfile-7.4), [`8.0-base`](Dockerfiles/base/Dockerfile-8.0), [`8.1-base`](Dockerfiles/base/Dockerfile-8.1), [`8.2-base`](Dockerfiles/base/Dockerfile-8.2)
* [`5.2-mods`](Dockerfiles/mods/Dockerfile-5.2), [`5.3-mods`](Dockerfiles/mods/Dockerfile-5.3), [`5.4-mods`](Dockerfiles/mods/Dockerfile-5.4), [`5.5-mods`](Dockerfiles/mods/Dockerfile-5.5), [`5.6-mods`](Dockerfiles/mods/Dockerfile-5.6), [`7.0-mods`](Dockerfiles/mods/Dockerfile-7.0), [`7.1-mods`](Dockerfiles/mods/Dockerfile-7.1), [`7.2-mods`](Dockerfiles/mods/Dockerfile-7.2), [`7.3-mods`](Dockerfiles/mods/Dockerfile-7.3), [`7.4-mods`](Dockerfiles/mods/Dockerfile-7.4), [`8.0-mods`](Dockerfiles/mods/Dockerfile-8.0), [`8.1-mods`](Dockerfiles/mods/Dockerfile-8.1), [`8.2-mods`](Dockerfiles/mods/Dockerfile-8.2)
* [`5.2-prod`](Dockerfiles/prod/Dockerfile-5.2), [`5.3-prod`](Dockerfiles/prod/Dockerfile-5.3), [`5.4-prod`](Dockerfiles/prod/Dockerfile-5.4), [`5.5-prod`](Dockerfiles/prod/Dockerfile-5.5), [`5.6-prod`](Dockerfiles/prod/Dockerfile-5.6), [`7.0-prod`](Dockerfiles/prod/Dockerfile-7.0), [`7.1-prod`](Dockerfiles/prod/Dockerfile-7.1), [`7.2-prod`](Dockerfiles/prod/Dockerfile-7.2), [`7.3-prod`](Dockerfiles/prod/Dockerfile-7.3), [`7.4-prod`](Dockerfiles/prod/Dockerfile-7.4), [`8.0-prod`](Dockerfiles/prod/Dockerfile-8.0), [`8.1-prod`](Dockerfiles/prod/Dockerfile-8.1), [`8.2-prod`](Dockerfiles/prod/Dockerfile-8.2)
* [`5.2-slim`](Dockerfiles/slim/Dockerfile-5.2), [`5.3-slim`](Dockerfiles/slim/Dockerfile-5.3), [`5.4-slim`](Dockerfiles/slim/Dockerfile-5.4), [`5.5-slim`](Dockerfiles/slim/Dockerfile-5.5), [`5.6-slim`](Dockerfiles/slim/Dockerfile-5.6), [`7.0-slim`](Dockerfiles/slim/Dockerfile-7.0), [`7.1-slim`](Dockerfiles/slim/Dockerfile-7.1), [`7.2-slim`](Dockerfiles/slim/Dockerfile-7.2), [`7.3-slim`](Dockerfiles/slim/Dockerfile-7.3), [`7.4-slim`](Dockerfiles/slim/Dockerfile-7.4), [`8.0-slim`](Dockerfiles/slim/Dockerfile-8.0), [`8.1-slim`](Dockerfiles/slim/Dockerfile-8.1), [`8.2-slim`](Dockerfiles/slim/Dockerfile-8.2)
* [`5.2-work`](Dockerfiles/work/Dockerfile-5.2), [`5.3-work`](Dockerfiles/work/Dockerfile-5.3), [`5.4-work`](Dockerfiles/work/Dockerfile-5.4), [`5.5-work`](Dockerfiles/work/Dockerfile-5.5), [`5.6-work`](Dockerfiles/work/Dockerfile-5.6), [`7.0-work`](Dockerfiles/work/Dockerfile-7.0), [`7.1-work`](Dockerfiles/work/Dockerfile-7.1), [`7.2-work`](Dockerfiles/work/Dockerfile-7.2), [`7.3-work`](Dockerfiles/work/Dockerfile-7.3), [`7.4-work`](Dockerfiles/work/Dockerfile-7.4), [`8.0-work`](Dockerfiles/work/Dockerfile-8.0), [`8.1-work`](Dockerfiles/work/Dockerfile-8.1), [`8.2-work`](Dockerfiles/work/Dockerfile-8.2)

:information_source: For details see **[Documentation: Docker Tags](doc/docker-tags.md)**<br/>
:information_source: For details see **[Documentation: Supported Architectures](doc/supported-architectures.md)**



<h2><img id="docker-tags" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> PHP Versions</h2>

The following PHP versions are provided by this repository.

* `PHP 5.2`, `PHP 5.3`, `PHP 5.4`, `PHP 5.5`, `PHP 5.6`
* `PHP 7.0`, `PHP 7.1`, `PHP 7.2`, `PHP 7.3`, `PHP 7.4`
* `PHP 8.0`, `PHP 8.1`, `PHP 8.2`

> **Note:** Unreleased PHP versions are built from custom base images.

:information_source: For details see **[Documentation: PHP Versions](doc/php-versions.md)**<br/>
:information_source: For details see **[Documentation: Base Images](doc/base-images.md)**



<h2><img id="php-fpm-flavours" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Flavours</h2>

The provided Docker images heavily rely on inheritance to guarantee smallest possible image size. Each of them provide a working PHP-FPM server and you must decide what version works best for you. Look at the sketch below to get an overview about the two provided flavours and each of their different types.

```shell
        [PHP]            # Base FROM image (Official PHP-FPM image)
          ^              #
          |              #
          |              #
        [base]           # Streamlined base images with host user mapping
          ^              # environment variables and custom configs.
          |              #
          |              #
        [mods]           # Installs additional PHP modules
          ^              # via pecl, git and other means
          |              #
          |              #
        [prod]           # Devilbox flavour for production
          ^              # (locales, postifx, socat and injectables)
          |              # (custom *.ini files)
          |              #
        [slim]           # Devilbox flavour with only required
          ^              # cli tools to have a functional intranet.
          |              #
          |              #
        [work]           # Devilbox flavour for local development
                         # (includes backup and development tools)
                         # (sudo, custom bash and tool configs)
```

:information_source: For details see **[Documentation: Flavours](doc/flavours.md)**<br/>
:information_source: For details see **[Documentation: Base Images](doc/base-images.md)**



<h2><img id="php-extensions" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Available PHP extensions</h2>

> Click below listed extensions for details:

<!-- modules -->
[`amqp`](php_modules/amqp/)
[`apc`](php_modules/apc/)
[`apcu`](php_modules/apcu/)
[`bcmath`](php_modules/bcmath/)
[`blackfire`](php_modules/blackfire/)
[`bz2`](php_modules/bz2/)
[`calendar`](php_modules/calendar/)
[`ctype`](php_modules/ctype/)
[`curl`](php_modules/curl/)
[`date`](php_modules/date/)
[`dba`](php_modules/dba/)
[`dom`](php_modules/dom/)
[`enchant`](php_modules/enchant/)
[`ereg`](php_modules/ereg/)
[`exif`](php_modules/exif/)
[`FFI`](php_modules/ffi/)
[`fileinfo`](php_modules/fileinfo/)
[`filter`](php_modules/filter/)
[`ftp`](php_modules/ftp/)
[`gd`](php_modules/gd/)
[`gettext`](php_modules/gettext/)
[`gmp`](php_modules/gmp/)
[`hash`](php_modules/hash/)
[`iconv`](php_modules/iconv/)
[`igbinary`](php_modules/igbinary/)
[`imagick`](php_modules/imagick/)
[`imap`](php_modules/imap/)
[`interbase`](php_modules/interbase/)
[`intl`](php_modules/intl/)
[`ioncube`](php_modules/ioncube/)
[`json`](php_modules/json/)
[`ldap`](php_modules/ldap/)
[`libxml`](php_modules/libxml/)
[`lz4`](php_modules/lz4/)
[`lzf`](php_modules/lzf/)
[`mbstring`](php_modules/mbstring/)
[`mcrypt`](php_modules/mcrypt/)
[`memcache`](php_modules/memcache/)
[`memcached`](php_modules/memcached/)
[`mhash`](php_modules/mhash/)
[`mongo`](php_modules/mongo/)
[`mongodb`](php_modules/mongodb/)
[`msgpack`](php_modules/msgpack/)
[`mysql`](php_modules/mysql/)
[`mysqli`](php_modules/mysqli/)
[`mysqlnd`](php_modules/mysqlnd/)
[`OAuth`](php_modules/oauth/)
[`oci8`](php_modules/oci8/)
[`OPcache`](php_modules/opcache/)
[`openssl`](php_modules/openssl/)
[`pcntl`](php_modules/pcntl/)
[`pcre`](php_modules/pcre/)
[`PDO`](php_modules/pdo/)
[`pdo_dblib`](php_modules/pdo_dblib/)
[`PDO_Firebird`](php_modules/pdo_firebird/)
[`pdo_mysql`](php_modules/pdo_mysql/)
[`PDO_OCI`](php_modules/pdo_oci/)
[`pdo_pgsql`](php_modules/pdo_pgsql/)
[`pdo_sqlite`](php_modules/pdo_sqlite/)
[`pdo_sqlsrv`](php_modules/pdo_sqlsrv/)
[`pgsql`](php_modules/pgsql/)
[`phalcon`](php_modules/phalcon/)
[`Phar`](php_modules/phar/)
[`posix`](php_modules/posix/)
[`pspell`](php_modules/pspell/)
[`psr`](php_modules/psr/)
[`random`](php_modules/random/)
[`rdkafka`](php_modules/rdkafka/)
[`readline`](php_modules/readline/)
[`recode`](php_modules/recode/)
[`redis`](php_modules/redis/)
[`Reflection`](php_modules/reflection/)
[`session`](php_modules/session/)
[`shmop`](php_modules/shmop/)
[`SimpleXML`](php_modules/simplexml/)
[`snmp`](php_modules/snmp/)
[`soap`](php_modules/soap/)
[`sockets`](php_modules/sockets/)
[`sodium`](php_modules/sodium/)
[`solr`](php_modules/solr/)
[`SPL`](php_modules/spl/)
[`sqlite`](php_modules/sqlite/)
[`sqlite3`](php_modules/sqlite3/)
[`sqlsrv`](php_modules/sqlsrv/)
[`ssh2`](php_modules/ssh2/)
[`swoole`](php_modules/swoole/)
[`sysvmsg`](php_modules/sysvmsg/)
[`sysvsem`](php_modules/sysvsem/)
[`sysvshm`](php_modules/sysvshm/)
[`tidy`](php_modules/tidy/)
[`tokenizer`](php_modules/tokenizer/)
[`uploadprogress`](php_modules/uploadprogress/)
[`uuid`](php_modules/uuid/)
[`vips`](php_modules/vips/)
[`wddx`](php_modules/wddx/)
[`Xdebug`](php_modules/xdebug/)
[`xhprof`](php_modules/xhprof/)
[`xlswriter`](php_modules/xlswriter/)
[`xml`](php_modules/xml/)
[`xmlreader`](php_modules/xmlreader/)
[`xmlrpc`](php_modules/xmlrpc/)
[`xmlwriter`](php_modules/xmlwriter/)
[`xsl`](php_modules/xsl/)
[`yaml`](php_modules/yaml/)
[`zip`](php_modules/zip/)
[`zlib`](php_modules/zlib/)
[`zstd`](php_modules/zstd/)
<!-- /modules -->

:information_source: For details see **[Documentation: PHP Modules](doc/php-modules.md)**<br/>
:information_source: For details see **[Contributor Documentation: PHP Module definition](php_modules/README.md)**



<h2><img id="php-fpm-options" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Environment Variables</h2>

The provided Docker images offer environment variables to alter their startup behaviour.

:information_source: For details see **[Documentation: Environment Variables](doc/docker-env-variables.md)** or click on the variable name directly.

| Variable                                        | Short description                                             |
|-------------------------------------------------|---------------------------------------------------------------|
| [`DEBUG_ENTRYPOINT`][lnk_env_debug]             | Control docker log verbosity                                  |
| [`NEW_UID`][lnk_env_uid]                        | Syncronize user-id file system permissions                    |
| [`NEW_GID`][lnk_env_gid]                        | Syncronize group-id file system permissions                   |
| [`TIMEZONE`][lnk_env_timezone]                  | Set timezone                                                  |
| [`DOCKER_LOGS`][lnk_env_logs]                   | Make PHP log to file or docker logs                           |
| [`ENABLE_MODULES`][lnk_env_enable_mods]         | Enable specific PHP extensions                                |
| [`DISABLE_MODULES`][lnk_env_disable_mods]       | Disable specific PHP extensions                               |
| [`ENABLE_MAIL`][lnk_env_enable_mail]            | Control email-catch all (to not accidentally send out emails) |
| [`FORWARD_PORTS_TO_LOCALHOST`][lnk_env_forward] | Make remote ports available locally inside the container      |
| [`MYSQL_BACKUP_USER`][lnk_env_backup_user]      | Set MySQL username (for backups)                              |
| [`MYSQL_BACKUP_PASS`][lnk_env_backup_pass]      | Set MySQL password (for backups)                              |
| [`MYSQL_BACKUP_HOST`][lnk_env_backup_host]      | Set MySQL hostname (for backups)                              |

[lnk_env_debug]: doc/docker-env-variables.md#-debug_entrypoint
[lnk_env_uid]: doc/docker-env-variables.md#-new_uid
[lnk_env_gid]: doc/docker-env-variables.md#-new_gid
[lnk_env_timezone]: doc/docker-env-variables.md#-timezone
[lnk_env_logs]: doc/docker-env-variables.md#-docker_logs
[lnk_env_enable_mods]: doc/docker-env-variables.md#-enable_modules
[lnk_env_disable_mods]: doc/docker-env-variables.md#-disable_modules
[lnk_env_enable_mail]: doc/docker-env-variables.md#-enable_mail
[lnk_env_forward]: doc/docker-env-variables.md#-forward_ports_to_localhost
[lnk_env_backup_user]: doc/docker-env-variables.md#-mysql_backup_user
[lnk_env_backup_pass]: doc/docker-env-variables.md#-mysql_backup_pass
[lnk_env_backup_host]: doc/docker-env-variables.md#-mysql_backup_host



<h2><img id="php-fpm-options" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Volumes</h2>

The provided Docker images offer different volumes to be mounted.

:information_source: For details see **[Documentation: Volumes](doc/docker-volumes.md)** or click on the volume name directly.

| Volume                                             | Short description                     |
|----------------------------------------------------|---------------------------------------|
| [`/etc/php-custom.d/`][lnk_vol_php_custom]         | Add custom PHP `*.ini` files          |
| [`/etc/php-fpm-custom.d/`][lnk_vol_php_fpm_custom] | Add custom PHP-FPM `*.conf` files     |
| [`/startup.1.d/`][lnk_vol_startup1]                | Add custom startup `*.sh` files       |
| [`/startup.2.d/`][lnk_vol_startup2]                | Add custom startup `*.sh` files       |
| [`/var/log/php/`][lnk_vol_log_php]                 | Find PHP log files                    |
| [`/var/mail/`][lnk_vol_mail]                       | Find sent emails                      |
| [`/etc/supervisor/custom.d/`][lnk_vol_supervisor]  | Add custom supervisord `*.conf` files |
| [`/etc/bashrc-devilbox.d/`][lnk_vol_bashrc]        | Add custom bashrc files               |
| [`/shared/backups/`][lnk_vol_backups]              | Find MySQL backups                    |
| [`/ca/`][lnk_vol_ca]                               | Add custom Certificate Authority      |

[lnk_vol_php_custom]: doc/docker-volumes.md#-etcphp-customd
[lnk_vol_php_fpm_custom]: doc/docker-volumes.md#-etcphp-fpm-customd
[lnk_vol_startup1]: doc/docker-volumes.md#-startup1d
[lnk_vol_startup2]: doc/docker-volumes.md#-startup2d
[lnk_vol_log_php]: doc/docker-volumes.md#-varlogphp
[lnk_vol_mail]: doc/docker-volumes.md#-varmail
[lnk_vol_supervisor]: doc/docker-volumes.md#-etcsupervisorcustomd
[lnk_vol_bashrc]: doc/docker-volumes.md#-etcbashrc-devilboxd
[lnk_vol_backups]: doc/docker-volumes.md#-sharedbackups
[lnk_vol_ca]: doc/docker-volumes.md#-ca



<h2><img id="php-fpm-options" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Ports</h2>

Have a look at the following table to see all offered exposed ports for each Docker image flavour.

<table>
 <thead>
  <tr>
   <th>Flavour</th>
   <th width="200">Port</th>
   <th>Description</th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td rowspan="1"><strong>base</strong><br/><strong>mods</strong><br/><strong>prod</strong><br/><strong>slim</strong><br/><strong>work</strong></td>
   <td><code>9000</code></td>
   <td>PHP-FPM listening port</td>
  </tr>
 </tbody>
</table>



<h2><img id="php-default-configuration" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> PHP Default Configuration</h2>

Each PHP version is using the same sane default php.ini values, making it pain-free to switch versions and not having to worry about different php.ini settings.
**Note:** Flavours alway inherit the settings from its parent flavour if they have no own configuration.

| Flavour | Applied php.ini files|
|---------|------------------------------------------|
| base    | [php.ini](Dockerfiles/base/data/php-ini.d/) and [php-fpm.conf](Dockerfiles/base/data/php-fpm.conf/) |
| mods    | inherits from base                       |
| prod    | inherits from base                       |
| slim    | [php.ini](Dockerfiles/slim/data/php-ini.d/) and [php-fpm.conf](Dockerfiles/slim/data/php-fpm.conf/) |
| work    | inherits from slim                       |



<h2><img id="integrated-development-environment" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Integrated Development Environment</h2>

If you plan to use the PHP-FPM image for development, hence being able to execute common commands inside the container itself, you should go with the **work** Image.

The **work** Docker image has many common tools already installed which on one hand increases its image size, but on the other hand removes the necessity to install those tools locally.

You want to use tools such as `angular-cli`, `codeception`, **`composer`**, `deployer`, `eslint`, `git`, `grunt-cli`, `gulp`, `laravel-installer`, **`node`**, **`npm`**, **`nvm`**, `phalcon-devtools`, `phpcs`, `phpunit`, `pm2`, `symfony-cli`, `tig`, `vue`, `webpack-cli`, `wp-cli`, **`yarn`**, `yq`, `zsh` as well as many others, simply do it directly inside the container. As all Docker images are auto-built every night by GitHub Actions it is assured that you are always at the latest version of your favorite dev tool.

<!-- Generate as such
cat doc/available-tools.md | grep -Eo '\| \[.+\]\[' | sed -e 's/| \[//g' -e 's/].*//g' -e 's/*//g' | xargs -n1 sh -c 'printf "["\`"${1}"\`"](../php_tools/${1}/)\n"' -- | xclip
-->

:information_source: For details see **[Documentation: Available Tools](doc/available-tools.md)**

#### What else is available

Apart from the provided tools, you will also be able to use the container similar as you would do with your host system. Just a few things to mention here:

* Mount custom bash configuration files so your config persists between restarts
* Use password-less `sudo` to become root and do whatever you need to do



<h2><img id="examples" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Examples</h2>

#### Provide PHP-FPM port to host
```shell
docker run -d -it \
    -p 127.0.0.1:9000:9000 \
    devilbox/php-fpm:7.2-prod
```

#### Alter PHP-FPM and system timezone
```shell
docker run -d -it \
    -p 127.0.0.1:9000:9000 \
    -e TIMEZONE=Europe/Berlin \
    devilbox/php-fpm:7.2-prod
```

#### Load custom PHP configuration

`config/` is a local directory that will hold the PHP *.ini files you want to load into the Docker container.
```shell
# Create config directory to be mounted with dummy configuration
mkdir config
# Xdebug 2
echo "xdebug.enable = 1" > config/xdebug.ini
# Xdebug 3
echo "xdebug.mode = debug" > config/xdebug.ini

# Run container and mount it
docker run -d -it \
    -p 127.0.0.1:9000:9000 \
    -v config:/etc/php-custom.d \
    devilbox/php-fpm:7.2-prod
```

#### MySQL connect via 127.0.0.1 (via port-forward)

Forward MySQL Port from `172.168.0.30` (or any other IP address/hostname) and Port `3306` to the PHP docker on `127.0.0.1:3306`. By this, your PHP files inside the docker can use `127.0.0.1` to connect to a MySQL database.
```shell
docker run -d -it \
    -p 127.0.0.1:9000:9000 \
    -e FORWARD_PORTS_TO_LOCALHOST='3306:172.168.0.30:3306' \
    devilbox/php-fpm:7.2-prod
```

#### MySQL and Redis connect via 127.0.0.1 (via port-forward)

Forward MySQL Port from `172.168.0.30:3306` and Redis port from `redis:6379` to the PHP docker on `127.0.0.1:3306` and `127.0.0.1:6379`. By this, your PHP files inside the docker can use `127.0.0.1` to connect to a MySQL or Redis database.
```shell
docker run -d -it \
    -p 127.0.0.1:9000:9000 \
    -e FORWARD_PORTS_TO_LOCALHOST='3306:172.168.0.30:3306, 6379:redis:6379' \
    devilbox/php-fpm:7.2-prod
```

#### Launch Postfix for mail-catching

Once you set `$ENABLE_MAIL=2`, all mails sent via any of your PHP applications no matter to which domain, are catched locally into the `devilbox` account. You can also mount the mail directory locally to hook in with mutt and read those mails.
```shell
docker run -d -it \
    -p 127.0.0.1:9000:9000 \
    -v /tmp/mail:/var/mail \
    -e ENABLE_MAIL=2 \
    devilbox/php-fpm:7.2-prod
```

#### Webserver and PHP-FPM

`~/my-host-www` will be the directory that serves the php files (your document root). Make sure to mount it into both, php and the webserver.
```shell
# Start PHP-FPM container
docker run -d -it \
    -v ~/my-host-www:/var/www/default/htdocs \
    --name php \
    devilbox/php-fpm:7.2-prod

# Start webserver and link with PHP-FPM
docker run -d -it \
    -p 80:80 \
    -v ~/my-host-www:/var/www/default/htdocs \
    -e PHP_FPM_ENABLE=1 \
    -e PHP_FPM_SERVER_ADDR=php \
    -e PHP_FPM_SERVER_PORT=9000 \
    --link php \
    devilbox/nginx-mainline
```

#### Create MySQL Backups

**Note:** This will only work with `work` Docker images.

The MySQL server could be another Docker container linked to the PHP-FPM container. Let's assume the PHP-FPM container is able to access the MySQL container by the hostname `mysql`.

```
# Start container
docker run -d -it \
    -e MYSQL_BACKUP_USER=root \
    -e MYSQL_BACKUP_PASS=somepass \
    -e MYSQL_BACKUP_HOST=mysql \
    -v ~/backups:/shared/backups \
    --name php \
    devilbox/php-fpm:7.2-work

# Run database dump
docker exec -it php mysqldump-secure
```

#### Docker Compose reference implementation

If you want a fully functional Docker Compose setup, which allows to switch PHP versions easily, comes with web servers, database servers and much more, then head over to the **[Devilbox](https://github.com/cytopia/devilbox)** rerefence implementation :

| Reference Implementation |
|--------------------------|
| <a title="Devilbox" href="https://github.com/cytopia/devilbox" ><img title="Devilbox" height="82px" src="https://raw.githubusercontent.com/devilbox/artwork/master/submissions_banner/cytopia/01/png/banner_256_trans.png" /></a> |



<h2><img id="automated-builds" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Automated builds</h2>

[![nightly](https://github.com/devilbox/docker-php-fpm/workflows/nightly/badge.svg)](https://github.com/devilbox/docker-php-fpm/actions?workflow=nightly)

Docker images are built and tested every night by **[GitHub Actions](https://github.com/devilbox/docker-php-fpm/actions?workflow=nightly)** and pushed to **[Docker hub](https://hub.docker.com/r/devilbox/php-fpm/)** on success. This is all done automatically to ensure that sources as well as base images are always fresh and in case of security updates always have the latest patches.



<h2><img id="build-your-own-image" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Build your own image</h2>

You are not interested in the provided Docker images and want to (ab)use this repository purely to generate your own custom images?
You can do so with three easy commands:
```bash
# Generate Dockerfiles with only the following PHP extensions present
make gen-dockerfiles MODS="msgpack memcached pdo_mysql rdkafka"

# Pull base image for PHP 8.1 (if you don't have it locally already)
make docker-pull-base-image STAGE=mods VERSION=8.1 ARCH=linux/arm64

# Build PHP 8.1 for arm64 with above specified extensions
make build STAGE=mods VERSION=8.1 ARCH=linux/arm64
```

:information_source: For details see **[Abuser Documentation: Build your own image](doc/abuser/README.md)**



<h2><img id="contributing" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Contributing</h2>

Contributors are welcome. Feel free to star and clone this repository and submit issues and pull-requests. Add examples and show what you have created with the provided images. If you see any errors or ways to improve this repository in any way, please do so.

:information_source: For details see **[Contributor Documentation: PHP Module definitions](php_modules/README.md)**<br/>
:information_source: For details see **[Contributor Documentation: PHP Tools definitions](php_tools/README.md)**



<h2><img id="related-projects" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Related Project</h2>

If you want to add custom modules, tools or apply any other changes, but don't think it fits in here, you can do so over at the **[PHP-FPM Community Images](https://github.com/devilbox/docker-php-fpm-community)**.

See the reference implementation below:

<!-- PROJECTS_START -->
| Project                               | Author                                          | build                                         | Architecture                          | Docker Tag                   |
|---------------------------------------|-------------------------------------------------|-----------------------------------------------|---------------------------------------|------------------------------|
| :file_folder: [devilbox/]             | :octocat: [cytopia] (cytopia)                   | [![devilbox_build]](https://github.com/devilbox/docker-php-fpm-community/actions/workflows/devilbox_action.yml)<br/>[![devilbox_nightly]](https://github.com/devilbox/docker-php-fpm-community/actions/workflows/devilbox_action_schedule.yml)| :computer: amd64<br/>:computer: arm64 | `<V>-devilbox`               |

[devilbox/]: https://github.com/devilbox/docker-php-fpm-community/tree/master/Dockerfiles/devilbox
[cytopia]: https://github.com/cytopia
[devilbox_build]: https://github.com/devilbox/docker-php-fpm-community/workflows/devilbox_build/badge.svg
[devilbox_nightly]: https://github.com/devilbox/docker-php-fpm-community/workflows/devilbox_nightly/badge.svg
> <sup> :information_source: `<V>` in the Docker tag above stands for the PHP version. E.g.: `5.4` or `8.1`, etc</sup>
<!-- PROJECTS_END -->



<h2><img id="sister-projects" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Sister Projects</h2>

Show some love for the following sister projects.

<table>
 <tr>
  <th>🖤 Project</th>
  <th>🐱 GitHub</th>
  <th>🐋 DockerHub</th>
 </tr>
 <tr>
  <td><a title="Devilbox" href="https://github.com/cytopia/devilbox" ><img width="256px" src="https://raw.githubusercontent.com/devilbox/artwork/master/submissions_banner/cytopia/01/png/banner_256_trans.png" /></a></td>
  <td><a href="https://github.com/cytopia/devilbox"><code>Devilbox</code></a></td>
  <td></td>
 </tr>
 <tr>
  <td><a title="Docker MySQL" href="https://github.com/devilbox/docker-mysql" ><img width="256px" src="https://raw.githubusercontent.com/devilbox/artwork/master/submissions_banner/cytopia/04/png/banner_256_trans.png" /></a></td>
  <td><a href="https://github.com/devilbox/docker-mysql"><code>docker-mysql</code></a></td>
  <td><a href="https://hub.docker.com/r/devilbox/mysql"><code>devilbox/mysql</code></a></td>
 </tr>
 <tr>
  <td><img width="256px" src="https://raw.githubusercontent.com/devilbox/artwork/master/submissions_banner/cytopia/05/png/banner_256_trans.png" /></td>
  <td>
   <a href="https://github.com/devilbox/docker-apache-2.2"><code>docker-apache-2.2</code></a><br/>
   <a href="https://github.com/devilbox/docker-apache-2.4"><code>docker-apache-2.4</code></a><br/>
   <a href="https://github.com/devilbox/docker-nginx-stable"><code>docker-nginx-stable</code></a><br/>
   <a href="https://github.com/devilbox/docker-nginx-mainline"><code>docker-nginx-mainline</code></a>
  </td>
  <td>
   <a href="https://hub.docker.com/r/devilbox/apache-2.2"><code>devilbox/apache-2.2</code></a><br/>
   <a href="https://hub.docker.com/r/devilbox/apache-2.4"><code>devilbox/apache-2.4</code></a><br/>
   <a href="https://hub.docker.com/r/devilbox/nginx-stable"><code>devilbox/nginx-stable</code></a><br/>
   <a href="https://hub.docker.com/r/devilbox/nginx-mainline"><code>devilbox/nginx-mainline</code></a>
  </td>
 </tr>
</table>



<h2><img id="community" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Community</h2>

In case you seek help, go and visit the community pages.

<table width="100%" style="width:100%; display:table;">
 <thead>
  <tr>
   <th width="33%" style="width:33%;"><h3><a target="_blank" href="https://devilbox.readthedocs.io">📘 Documentation</a></h3></th>
   <th width="33%" style="width:33%;"><h3><a target="_blank" href="https://discord.gg/2wP3V6kBj4">🎮 Discord</a></h3></th>
   <th width="33%" style="width:33%;"><h3><a target="_blank" href="https://devilbox.discourse.group">🗪 Forum</a></h3></th>
  </tr>
 </thead>
 <tbody style="vertical-align: middle; text-align: center;">
  <tr>
   <td>
    <a target="_blank" href="https://devilbox.readthedocs.io">
     <img title="Documentation" name="Documentation" src="https://raw.githubusercontent.com/cytopia/icons/master/400x400/readthedocs.png" />
    </a>
   </td>
   <td>
    <a target="_blank" href="https://discord.gg/2wP3V6kBj4">
     <img title="Chat on Discord" name="Chat on Discord" src="https://raw.githubusercontent.com/cytopia/icons/master/400x400/discord.png" />
    </a>
   </td>
   <td>
    <a target="_blank" href="https://devilbox.discourse.group">
     <img title="Devilbox Forums" name="Forum" src="https://raw.githubusercontent.com/cytopia/icons/master/400x400/discourse.png" />
    </a>
   </td>
  </tr>
  <tr>
  <td><a target="_blank" href="https://devilbox.readthedocs.io">devilbox.readthedocs.io</a></td>
  <td><a target="_blank" href="https://discord.gg/2wP3V6kBj4">discord/devilbox</a></td>
  <td><a target="_blank" href="https://devilbox.discourse.group">devilbox.discourse.group</a></td>
  </tr>
 </tbody>
</table>



<h2><img id="credits" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Credits</h2>

Thanks for contributing 🖤

- **[@mrLexx](https://github.com/mrLexx)**
- **[@fibis](https://github.com/fibis)**
- **[@llaville](https://github.com/llaville)**
- **[@anatolinicolae](https://github.com/anatolinicolae)**
- **[@fschndr](https://github.com/fschndr)**
- **[@Tuurlijk](https://github.com/Tuurlijk)**



<h2><img id="maintainer" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Maintainer</h2>

**[@cytopia](https://github.com/cytopia)**

I try to keep up with literally **over 100 projects** besides a full-time job.
If my work is making your life easier, consider contributing. 🖤

* [GitHub Sponsorship](https://github.com/sponsors/cytopia)
* [Patreon](https://www.patreon.com/devilbox)
* [Open Collective](https://opencollective.com/devilbox)

**Findme:**
**🐱** [cytopia](https://github.com/cytopia) / [devilbox](https://github.com/devilbox) |
**🐋** [cytopia](https://hub.docker.com/r/cytopia/) / [devilbox](https://hub.docker.com/r/devilbox/) |
**🐦** [everythingcli](https://twitter.com/everythingcli) / [devilbox](https://twitter.com/devilbox) |
**📖** [everythingcli.org](http://www.everythingcli.org/)

**Contrib:** PyPI: [cytopia](https://pypi.org/user/cytopia/) **·**
Terraform: [cytopia](https://registry.terraform.io/namespaces/cytopia) **·**
Ansible: [cytopia](https://galaxy.ansible.com/cytopia)



<h2><img id="license" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> License</h2>

**[MIT License](LICENSE.md)**

Copyright (c) 2017 [cytopia](https://github.com/cytopia)
