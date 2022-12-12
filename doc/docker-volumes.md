[Permissions](syncronize-file-permissions.md) |
[Tags](docker-tags.md) |
[Architectures](supported-architectures.md) |
[Versions](php-versions.md) |
[Flavours](flavours.md) |
[Extensions](php-modules.md) |
[Tools](available-tools.md) |
[Env Vars](docker-env-variables.md) |
Volumes |
[Base Images](base-images.md)

---

<h2><img name="Documentation" title="Documentation" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Documentation</h2>



### Docker Volumes

1. [Overview](#overview)
2. [`/etc/php-custom.d/`][lnk_vol_php_custom]
3. [`/etc/php-fpm-custom.d/`][lnk_vol_php_fpm_custom]
4. [`/startup.1.d/`][lnk_vol_startup1]
5. [`/startup.2.d/`][lnk_vol_startup2]
6. [`/var/log/php/`][lnk_vol_log_php]
7. [`/var/mail/`][lnk_vol_mail]
8. [`/etc/supervisor/custom.d/`][lnk_vol_supervisor]
9. [`/etc/bashrc-devilbox.d/`][lnk_vol_bashrc]
10. [`/shared/backups/`][lnk_vol_backups]
11. [`/ca/`][lnk_vol_ca]

[lnk_vol_php_custom]: #-etcphp-customd
[lnk_vol_php_fpm_custom]: #-etcphp-fpm-customd
[lnk_vol_startup1]: #-startup1d
[lnk_vol_startup2]: #-startup2d
[lnk_vol_log_php]: #-varlogphp
[lnk_vol_mail]: #-varmail
[lnk_vol_supervisor]: #-etcsupervisorcustomd
[lnk_vol_bashrc]: #-etcbashrc-devilboxd
[lnk_vol_backups]: #-sharedbackups
[lnk_vol_ca]: #-ca


### Overview

The following table gives an overview about which volume is available to which flavour.

| Docker Volume               | `base` | `mods` | `prod` | `slim` | `work` |
|-----------------------------|--------|--------|--------|--------|--------|
| `/etc/php-custom.d/`        |        |        |   ✓    |   ✓    |   ✓    |
| `/etc/php-fpm-custom.d/`    |        |        |   ✓    |   ✓    |   ✓    |
| `/startup.1.d/`             |        |        |   ✓    |   ✓    |   ✓    |
| `/startup.2.d/`             |        |        |   ✓    |   ✓    |   ✓    |
| `/var/log/php/`             |        |        |   ✓    |   ✓    |   ✓    |
| `/var/mail/`                |        |        |   ✓    |   ✓    |   ✓    |
| `/etc/supervisor/custom.d/` |        |        |   ✓    |   ✓    |   ✓    |
| `/etc/bashrc-devilbox.d/`   |        |        |        |   ✓    |   ✓    |
| `/shared/backups/`          |        |        |        |   ✓    |   ✓    |
| `/ca/`                      |        |        |        |   ✓    |   ✓    |


### 📂 `/etc/php-custom.d/`

Mount this directory into your host system and add custom PHP `*.ini` files in order to alter PHP behaviour.


### 📂 `/etc/php-fpm-custom.d/`

Mount this directory into your host system and add custom PHP-FPM `*.conf` files in order to alter PHP-FPM behaviour.


### 📂 `/startup.1.d/`

Any executable scripts ending by `*.sh` found in this directory will be executed during startup. This is useful to supply additional commands (such as installing custom software) when the container starts up. (will run before `/startup.2.d`).


### 📂 `/startup.2.d/`

Any executable scripts ending by `*.sh` found in this directory will be executed during startup. This is useful to supply additional commands (such as installing custom software) when the container starts up. (will run after `/startup.1.d`).


### 📂 `/var/log/php/`

When setting environment variable `DOCKER_LOGS` to `0`, PHP and PHP-FPM log files will be available in this directory.


### 📂 `/var/mail/`

Emails caught be the postfix catch-all (`ENABLE_MAIL=2`) will be available in this directory.


### 📂 `/etc/supervisor/custom.d/`

Mount this directory into your host computer and add your own `*.conf` supervisor start-up files.

**Note:** Directory and file permission will be recursively set to this of `NEW_UID` and `NEW_GID`.


### 📂 `/etc/bashrc-devilbox.d/`

Mount this directory into your host computer and add custom configuration files for `bash` and other tools.


### 📂 `/shared/backups/`

Mount this directory into your host computer to access MySQL backups created by [mysqldump-secure](https://mysqldump-secure.org/).


### 📂 `/ca/`

Mount this directory into your host computer to bake any `*.crt` file that is located in there as a trusted SSL entity.
