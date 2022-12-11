[Permissions](syncronize-file-permissions.md) |
[Tags](docker-tags.md) |
[Architectures](supported-architectures.md) |
[Versions](php-versions.md) |
[Flavours](flavours.md) |
[Extensions](php-modules.md) |
[Tools](available-tools.md) |
Env Vars |
[Volumes](docker-volumes.md) |
[Base Images](base-images.md)

---

<h2><img name="Documentation" title="Documentation" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Documentation</h2>



### Environment Variables

1. [Overview](#overview)
2. [`DEBUG_ENTRYPOINT`][lnk_env_debug]
3. [`NEW_UID`][lnk_env_uid]
4. [`NEW_GID`][lnk_env_gid]
5. [`TIMEZONE`][lnk_env_timezone]
6. [`DOCKER_LOGS`][lnk_env_logs]
7. [`ENABLE_MODULES`][lnk_env_enable_mods]
8. [`DISABLE_MODULES`][lnk_env_disable_mods]
9. [`ENABLE_MAIL`][lnk_env_enable_mail]
10. [`FORWARD_PORTS_TO_LOCALHOST`][lnk_env_forward]
11. [`MYSQL_BACKUP_USER`][lnk_env_backup_user]
12. [`MYSQL_BACKUP_PASS`][lnk_env_backup_pass]
13. [`MYSQL_BACKUP_HOST`][lnk_env_backup_host]

[lnk_env_debug]: #-debug_entrypoint
[lnk_env_uid]: #-new_uid
[lnk_env_gid]: #-new_gid
[lnk_env_timezone]: #-timezone
[lnk_env_logs]: #-docker_logs
[lnk_env_enable_mods]: #-enable_modules
[lnk_env_disable_mods]: #-disable_modules
[lnk_env_enable_mail]: #-enable_mail
[lnk_env_forward]: #-forward_ports_to_localhost
[lnk_env_backup_user]: #-mysql_backup_user
[lnk_env_backup_pass]: #-mysql_backup_pass
[lnk_env_backup_host]: #-mysql_backup_host


### Overview

The following table gives an overview about which environment variable is available to which flavour.

| Environment Variable         | `base` | `mods` | `prod` | `slim` | `work` |
|------------------------------|--------|--------|--------|--------|--------|
| `DEBUG_ENTRYPOINT`           |   ✓    |   ✓    |   ✓    |   ✓    |   ✓    |
| `NEW_UID`                    |   ✓    |   ✓    |   ✓    |   ✓    |   ✓    |
| `NEW_GID`                    |   ✓    |   ✓    |   ✓    |   ✓    |   ✓    |
| `TIMEZONE`                   |        |        |   ✓    |   ✓    |   ✓    |
| `DOCKER_LOGS`                |        |        |   ✓    |   ✓    |   ✓    |
| `ENABLE_MODULES`             |        |        |   ✓    |   ✓    |   ✓    |
| `DISABLE_MODULES`            |        |        |   ✓    |   ✓    |   ✓    |
| `ENABLE_MAIL`                |        |        |   ✓    |   ✓    |   ✓    |
| `FORWARD_PORTS_TO_LOCALHOST` |        |        |   ✓    |   ✓    |   ✓    |
| `MYSQL_BACKUP_USER`          |        |        |        |   ✓    |   ✓    |
| `MYSQL_BACKUP_PASS`          |        |        |        |   ✓    |   ✓    |
| `MYSQL_BACKUP_HOST`          |        |        |        |   ✓    |   ✓    |


### ∑ `DEBUG_ENTRYPOINT`

This variable controls the debug level (verbosity) for the container startup. The more verbose, the more information is shown via docker logs during startup.

* **Var type:** `int`
* **Default:** `0`
* **Allowed:** `0`, `1`, `2`

When set to `0` (default), only errors and warnings are shown.
When set to `1`, all log messages are shown.
When set to `2`, all log messages and all commands that are being executed by the entrypoint script are shown.


### ∑ `NEW_UID`

This variable controls the user id of the php-fpm process.

* **Var type:** `int`
* **Default:** `1000`
* **Allowed:** any valid user id (use your local users' `uid`)

> **Backgrund:** The php-fpm docker image has a non-root user (and group) that the php-fpm process runs with. When one of your PHP scripts creates a file (cache, uploads, etc), it is being created with the user id and group id, the php-fpm process runs with. In order to make sure this is the same user id as your normal user locally on the host system, this env variable can be used to change the user id inside the container (during startup).
Why can't the php-fpm process run as root? It would then create files with root permissions and as those files are actually on your host system, you would require root permission to access/edit them again.
>
> You can read more about this topic here: [Syncronize file and folder Permissions](syncronize-file-permissions.md).

You want the PHP-FPM process to run with the same **user id** as the user on your host system.

What value should I set this to? Open up a terminal on your host system and type **`id -u`** to find out the user id of your local user.


### ∑ `NEW_GID`

This variable controls the group id of the php-fpm process.

* **Var type:** `int`
* **Default:** `1000`
* **Allowed:** any valid group id (use your local users' `gid`)

> **Background:** See the section in `NEW_UID`

You want the PHP-FPM process to run with the same **group id **as the user on your host system.

What value should I set this to? Open up a terminal on your host system and type **`id -g`** to find out the group id of your local user.


### ∑ `TIMEZONE`

This variable sets the timezone for the container as well as for the PHP-FPM process (via php.ini directives).

* **Var type:** `string`
* **Default:** `UTC`
* **Allowed:** any valid timezone (e.g.: `Europe/Berlin`)


### ∑ `DOCKER_LOGS`

This variable controls whether PHP access and error logs are written to a log file inside the container or shown via docker logs.

* **Var type:** `bool`
* **Default:** `1`
* **Allowed:** `0` or `1`

By default (value: `1`) all Docker images are configured to output their PHP-FPM access and error logs to stdout and stderr, which means it is shown by `docker logs` (or `docker-compose logs`).

If you want to log into files inside the container instead, change it to `0`. The respective log files are available as Docker volumes and can be mounted to your local file system so you can `cat`, `tail` or `grep` them for anything interesting.


### ∑ `ENABLE_MODULES`

Some PHP extensions are not enabled by default (e.g.: `blackfire`, `ioncube`, `swoole` and others). See [PHP modules](php-modules.md) to find out availalable modules and which are enabled/disabled by default. This variable explicitly enabled PHP modules during startup.

* **Var type:** comma separated `string` of modules to enable
* **Default:** ``
* **Allowed:** available modules as a commaa separated string

Example:
```bash
ENABLE_MODULES=swoole
ENABLE_MODULES=swoole,psr,phalcon
```

### ∑ `DISABLE_MODULES`

The PHP-FPM images come with lots of available and default-enabled PHP modules. You might not need all of them. This variable controls which of the modules you want to disable explicitly during startup.

**Note:** Not all modules can be disabled, as some of them are directly compiled into PHP itself. See [PHP modules](php-modules.md) to find out, which modules can be disabled.

* **Var type:** comma separated `string` of modules to disabled
* **Default:** ``
* **Allowed:** available modules as a commaa separated string

Example:
```bash
DISABLE_MODULES=imagick
DISABLE_MODULES=imagick,xdebug
```


### ∑ `ENABLE_MAIL`

This variable controls whether Postfix (smtpd) should run and how it should behave, when your PHP code sends emails. It can be configured to intercept any outbound send emails and keep them locally, so that you do not accidentally send mails out.

* **Var type:** `int`
* **Default:** `0`
* **Allowed:** `0`, `1` or `2`

By default (value: `0`), the Postfix service is disabled and not started locally inside the Docker container.

When set to `1`, the Postfix service is started normally with its out-of-the-box default configuration.

When set to `2`, the Postfix service is started	and configured for local delivery. That means that all mails sent (even to real existing domains) are intercepted and catched locally. No email will ever leave the system. The emails are then stored in the `devilbox` users' mail file locally in the container. Its directory can also be mounted to your local file system to browse the mails that have been sent.


### ∑ `FORWARD_PORTS_TO_LOCALHOST`

This variable allows you to forward remote ports to `127.0.0.1` into the PHP-FPM docker container. This might be handy if you have another MySQL database container running and still want to be able to use `127.0.0.1` in your PHP configuration for the database host.

* **Var type:** `string`
* **Default:** ``
* **Allowed:** `<local-port>:<remote-host>:<remote-port>`

**Note:** You can forward multiple ports by comma separating the allowd forwarding string.

Forward a remote MySQL database locally to port 3307
```bash
# Remote MYSQL host/ip:     mysqlhost
# Remote MYSQL port:        3306
# Local port to forward to: 3307
FORWARD_PORTS_TO_LOCALHOST=3307:mysqlhost:3306
```

Forward a remote MySQL and PostgreSQL locally to port 3307 and 5433
```bash
# Remote MYSQL host/ip:     mysqlhost
# Remote MYSQL port:        3306
# Local port to forward to: 3307

# Remote PGSQL host/ip:     pgsqlhost
# Remote PGSQL port:        5432
# Local port to forward to: 5433
FORWARD_PORTS_TO_LOCALHOST=3307:mysqlhost:3306, 5433:pgsqlhost:5432
```


### ∑ `MYSQL_BACKUP_USER`

You can just type `mysqldump-secure` inside the PHP-FPM container to easily backup your MySQL databases with one command. (See project: https://mysqldump-secure.org/).
In order to do so, you will need to pass a MySQL user to the PHP-FPM container, so it can auto-configure mysqldump-secure for you.

* **Var type:** `string`
* **Default:** ``
* **Allowed:** valid mysql user name


### ∑ `MYSQL_BACKUP_PASS`

You can just type `mysqldump-secure` inside the PHP-FPM container to easily backup your MySQL databases with one command. (See project: https://mysqldump-secure.org/).
In order to do so, you will need to pass a MySQL password to the PHP-FPM container, so it can auto-configure mysqldump-secure for you.

* **Var type:** `string`
* **Default:** ``
* **Allowed:** valid mysql password


### ∑ `MYSQL_BACKUP_HOST`

You can just type `mysqldump-secure` inside the PHP-FPM container to easily backup your MySQL databases with one command. (See project: https://mysqldump-secure.org/).
In order to do so, you will need to pass a MySQL hostname to the PHP-FPM container, so it can auto-configure mysqldump-secure for you.

* **Var type:** `string`
* **Default:** ``
* **Allowed:** valid hostname

**Note:** The hostname must be reachable from within the PHP-FPM container.
