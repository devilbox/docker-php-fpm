# PHP-FPM Docker images

[![Build Status](https://travis-ci.org/devilbox/docker-php-fpm.svg?branch=master)](https://travis-ci.org/devilbox/docker-php-fpm)
[![release](https://img.shields.io/github/release/devilbox/docker-php-fpm.svg)](https://github.com/devilbox/docker-php-fpm/releases)
[![Join the chat at https://gitter.im/devilbox/Lobby](https://badges.gitter.im/devilbox/Lobby.svg)](https://gitter.im/devilbox/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Github](https://img.shields.io/badge/github-docker--php--fpm-red.svg)](https://github.com/devilbox/docker-php-fpm)
[![](https://images.microbadger.com/badges/license/devilbox/php-fpm.svg)](https://microbadger.com/images/devilbox/php-fpm "php-fpm")

**[devilbox/docker-php-fpm](https://github.com/devilbox/docker-php-fpm)**

This repository will provide you fully functional PHP-FPM Docker images in different flavours,
versions and packed with different types of integrated PHP modules. It also solves the problem of [syncronizing file permissions](#unsynchronized-permissions) of mounted volumes between the host and the container.

| Docker Hub | Upstream Project |
|------------|------------------|
| <a href="https://hub.docker.com/r/devilbox/php-fpm"><img height="82px" src="http://dockeri.co/image/devilbox/php-fpm" /></a> | <a href="https://github.com/cytopia/devilbox" ><img height="82px" src="https://raw.githubusercontent.com/devilbox/artwork/master/submissions_banner/cytopia/01/png/banner_256_trans.png" /></a> |

---

#### Table of Contents

1. **[Motivation](#motivation)**
    1. [Unsynchronized permissions](#unsynchronized-permissions)
    2. [It gets even worse](#it-gets-even-worse)
    3. [The solution](#the-solution)
2. **[PHP-FPM Flavours](#php-fpm-flavours)**
    1. [Assembly](#assembly)
    2. [Available Images](#available-images)
    3. [Tagging](#tagging)
    4. [PHP Modules](#php-modules)
3. **[PHP-FPM Features](#php-fpm-features)**
    1. [Image: base](#image-base)
    2. [Image: mods](#image-mods)
    3. [Image: prod](#image-prod)
    4. [Image: work](#image-work)
4. **[PHP-FPM Options](#php-fpm-options)**
    1. [Environment variables](#environment-variables)
    2. [Volumes](#volumes)
    3. [Ports](#ports)
5. **[PHP Default Configuration](#php-default-configuration)**
6. **[Integrated Development Environment](#integrated-development-environment)**
    1. [What toos can you expect](#what-tools-can-you-expect)
    2. [What else is available](#what-else-is-available)
7. **[Examples](#examples)**
    1. [Provide PHP-FPM port to host](#provide-php-fpm-port-to-host)
    2. [Alter PHP-FPM and system timezone](#alter-php-fpm-and-system-timezone)
    3. [Load custom PHP configuration](#load-custom-php-configuration)
    4. [Load custom PHP modules](#load-custom-php-modules)
    5. [MySQL connect via 127.0.0.1 (via port-forward)](#mysql-connect-via-127-0-0-1-via-port-forward-)
    6. [MySQL and Redis connect via 127.0.0.1 (via port-forward)](#mysql-and-redis-connect-via-127-0-0-1-via-port-forward-)
    7. [Launch Postfix for mail-catching](#launch-postfix-for-mail-catching)
    8. [Webserver and PHP-FPM](#webserver-and-php-fpm)
    9. [Create MySQL Backups](#create-mysql-backups)
8. **[Automated builds](#automated-builds)**
9. **[Contributing](#contributing)**
10. **[Credits](#credits)**
11. **[License](#license)**

----

<h2><img id="motivation" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Motivation</h2>

One main problem with a running Docker container is to **synchronize the ownership of files in a mounted volume** in order to preserve security (Not having to use `chmod 0777`).


#### Unsynchronized permissions

Consider the following directory structure of a mounted volume. Your hosts computer uid/gid are `1000` which does not have a corresponding user/group within the container. Fortunately the `tmp/` directory allows everybody to create new files in it. 

```shell
                  [Host]                   |             [Container]
------------------------------------------------------------------------------------------
 $ ls -l                                   | $ ls -l
 -rw-r--r-- user group index.php           | -rw-r--r-- 1000 1000 index.php
 drwxrwxrwx user group tmp/                | drwxrwxrwx 1000 1000 tmp/
```

Your web application might now have created some temporary files (via the PHP-FPM process) inside the `tmp/` directory:

```shell
                  [Host]                   |             [Container]
------------------------------------------------------------------------------------------
 $ ls -l tmp/                              | $ ls -l tmp/
 -rw-r--r-- 96 96 _tmp_cache01.php         | -rw-r--r-- www www _tmp_cache01.php
 -rw-r--r-- 96 96 _tmp_cache02.php         | -rw-r--r-- www www _tmp_cache01.php
```

On the Docker container side everything is still fine, but on your host computers side, those files now show a user id and group id of `96`, which is in fact the uid/gid of the PHP-FPM process running inside the container. On the host side you will now have to use `sudo` in order to delete/edit those files.

#### It gets even worse

Consider your had created the `tmp/` directory on your host only with `0775` permissions:

```shell
                  [Host]                   |             [Container]
------------------------------------------------------------------------------------------
 $ ls -l                                   | $ ls -l
 -rw-r--r-- user group index.php           | -rw-r--r-- 1000 1000 index.php
 drwxrwxr-x user group tmp/                | drwxrwxr-x 1000 1000 tmp/
```

If your web application now wants to create some temporary files (via the PHP-FPM process) inside the `tmp/` directory, it will fail due to lacking permissions.

#### The solution

To overcome this problem, it must be made sure that the PHP-FPM process inside the container runs under the same uid/gid as your local user that mouns the volumes and also wants to work on those files locally. However, you never know during Image build time what user id this would be. Therefore it must be something that can be changed during startup of the container.

This is achieved by two environment variables that can be provided during startup in order to change the uid/gid of the PHP-FPM user prior starting up PHP-FPM.

```shell
$ docker run -e NEW_UID=1000 -e NEW_GID=1000 -it devilbox/php-fpm:7.2-base
[INFO] Changing user 'devilbox' uid to: 1000
root $ usermod -u 1000 devilbox
[INFO] Changing group 'devilbox' gid to: 1000
root $ groupmod -g 1000 devilbox
[INFO] Starting PHP 7.2.0 (fpm-fcgi) (built: Oct 30 2017 12:05:19)
```

When **`NEW_UID`** and **`NEW_GID`** are provided to the startup command, the container will do a `usermod` and `groupmod` prior starting up in order to assign new uid/gid to the PHP-FPM user. When the PHP-FPM process finally starts up it actually runs with your local system user and making sure permissions will be in sync from now on.

At a minimum those two environment variables are offered by all flavours and types of the here provided PHP-FPM images.

**Note:**

To tackle this on the PHP-FPM side is only half a solution to the problem. The same applies to a web server Docker container when you offer **file uploads**. They will be uploaded and created by the web servers uid/gid. Therefore the web server itself must also provide the same kind of solution. See the following Web server Docker images for how this is done:

**[Apache 2.2](https://github.com/devilbox/docker-apache-2.2)** |
**[Apache 2.4](https://github.com/devilbox/docker-apache-2.4)** |
**[Nginx stable](https://github.com/devilbox/docker-nginx-stable)** |
**[Nginx mainline](https://github.com/devilbox/docker-nginx-mainline)**


<h2><img id="php-fpm-flavours" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> PHP-FPM Flavours</h2>

#### Assembly

The provided Docker images heavily rely on inheritance to guarantee smallest possible image size. Each of them provide a working PHP-FPM server and you must decide what version works best for you. Look at the sketch below to get an overview about the two provided flavours and each of their different types.

```shell
        [PHP]            # Base FROM image (Official PHP-FPM image)
          ^              #
          |              #
          |              #
        [base]           # Introduces env variables and adjusts entrypoint
          ^              #
          |              #
          |              #
        [mods]           # Installs additional PHP modules
          ^              # via pecl, git and other means
          |              #
          |              #
        [prod]           # Devilbox flavour for production
          ^              # (locales, postifx, socat and injectables)
          |              # (custom modules and *.ini files)
          |              #
        [work]           # Devilbox flavour for local development
                         # (includes backup and development tools)
                         # (sudo, custom bash and tool configs)
```

#### Available Images

The following table shows a more complete overview about the offered Docker images and what they should be used for.

<table>
 <thead>
  <tr>
   <th width="80">Type</th>
   <th width="280">Docker Image</th>
   <th width="320">Description</th>
  </tr>
 </thead>
 <tbody>

  <tr>
   <td rowspan="10"><strong>base</strong></td>
   <td><code>devilbox/php-fpm:5.2-base</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.2-base.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.2-base.svg" /></a>
   </td>
  </tr>
   <td><code>devilbox/php-fpm:5.3-base</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.3-base.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.3-base.svg" /></a>
   </td>
  </tr>
  </tr>
   <td><code>devilbox/php-fpm:5.4-base</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.4-base.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.4-base.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.5-base</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.5-base.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.5-base.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.6-base</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.6-base.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.6-base.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.0-base</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.0-base.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.0-base.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.1-base</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.1-base.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.1-base.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.2-base</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.2-base.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.2-base.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.3-base</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.3-base.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.3-base.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.4-base</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.4-base.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.4-base.svg" /></a>
   </td>
  </tr>

  <tr>
   <td rowspan="10"><strong>mods</strong></td>
   <td><code>devilbox/php-fpm:5.2-mods</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.2-mods.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.2-mods.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.3-mods</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.3-mods.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.3-mods.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.4-mods</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.4-mods.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.4-mods.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.5-mods</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.5-mods.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.5-mods.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.6-mods</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.6-mods.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.6-mods.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.0-mods</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.0-mods.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.0-mods.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.1-mods</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.1-mods.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.1-mods.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.2-mods</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.2-mods.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.2-mods.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.3-mods</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.3-mods.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.3-mods.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.4-mods</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.4-mods.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.4-mods.svg" /></a>
   </td>
  </tr>

  <tr>
   <td rowspan="10"><strong>prod</strong></td>
   <td><code>devilbox/php-fpm:5.2-prod</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.2-prod.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.2-prod.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.3-prod</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.3-prod.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.3-prod.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.4-prod</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.4-prod.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.4-prod.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.5-prod</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.5-prod.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.5-prod.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.6-prod</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.6-prod.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.6-prod.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.0-prod</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.0-prod.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.0-prod.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.1-prod</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.1-prod.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.1-prod.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.2-prod</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.2-prod.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.2-prod.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.3-prod</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.3-prod.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.3-prod.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.4-prod</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.4-prod.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.4-prod.svg" /></a>
   </td>
  </tr>

  <tr>
   <td rowspan="10"><strong>work</strong></td>
   <td><code>devilbox/php-fpm:5.2-work</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.2-work.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.2-work.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.3-work</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.3-work.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.3-work.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.4-work</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.4-work.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.4-work.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.5-work</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.5-work.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.5-work.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:5.6-work</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:5.6-work.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:5.6-work.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.0-work</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.0-work.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.0-work.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.1-work</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.1-work.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.1-work.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.2-work</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.2-work.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.2-work.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.3-work</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.3-work.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.3-work.svg" /></a>
   </td>
  </tr>
  <tr>
   <td><code>devilbox/php-fpm:7.4-work</code></td>
   <td>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/image/devilbox/php-fpm:7.4-work.svg" /></a>
    <a href="https://microbadger.com/images/devilbox/php-fpm"><img src="https://images.microbadger.com/badges/version/devilbox/php-fpm:7.4-work.svg" /></a>
   </td>
  </tr>

 </tbody>
</table>


#### Tagging

This repository uses Docker tags to refer to different flavours and types of the PHP-FPM Docker image. Therefore `:latest` and `:<git-branch-name>` as well as `:<git-tag-name>` must be presented differently. Refer to the following table to see how tagged Docker images are produced at Docker hub:

<table>
 <thead>
  <tr>
   <th width="190">Meant Tag</th>
   <th width="300">Actual Tag</th>
   <th>Comment</th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><code>:latest</code></td>
   <td>
    <code>:X.Y-base</code><br/>
    <code>:X.Y-mods</code><br/>
    <code>:X.Y-prod</code><br/>
    <code>:X.Y-work</code><br/>
   </td>
   <td>Stable<br/><sub>(rolling)</sub><br/><br/>These tags are produced by the master branch of this repository.</td>
  </tr>
  <tr>
   <td><code>:&lt;git-tag-name&gt;</code></td>
   <td>
    <code>:X.Y-base-&lt;git-tag-name&gt;</code><br/>
    <code>:X.Y-mods-&lt;git-tag-name&gt;</code><br/>
    <code>:X.Y-prod-&lt;git-tag-name&gt;</code><br/>
    <code>:X.Y-work-&lt;git-tag-name&gt;</code><br/>
   </td>
   <td>Stable<br/><sub>(fixed)</sub><br/><br/>Every git tag will produce and preserve these Docker tags.</td>
  </tr>
  <tr>
   <td><code>:&lt;git-branch-name&gt;</code></td>
   <td>
    <code>:X.Y-base-&lt;git-branch-name&gt;</code><br/>
    <code>:X.Y-mods-&lt;git-branch-name&gt;</code><br/>
    <code>:X.Y-prod-&lt;git-branch-name&gt;</code><br/>
    <code>:X.Y-work-&lt;git-branch-name&gt;</code><br/>
   </td>
   <td>Feature<br/><sub>(for testing)</sub><br/><br/>Tags produced by unmerged branches. Do not rely on them as they might come and go.</td>
  </tr>
 </tbody>
</table>


#### PHP Modules

Check out this table to see which Docker image provides what PHP modules.

<table>
 <thead>
  <tr>
   <th></th>
   <th width="45%"><code>base</code></th>
   <th width="45%"><code>mods</code>, <code>prod</code> and <code>work</code></th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <th>5.2</th>
   <td id="52-base">ctype, curl, date, dom, filter, hash, iconv, json, libxml, mbstring, mysql, mysqli, openssl, pcre, PDO, pdo_mysql, pdo_sqlite, posix, readline, Reflection, session, SimpleXML, soap, SPL, SQLite, standard, tokenizer, xml, xmlreader, xmlwriter, zlib</td>
   <td id="52-mods">amqp, bcmath, bz2, calendar, ctype, curl, date, dba, dom, enchant, exif, fileinfo, filter, ftp, gd, gettext, hash, iconv, igbinary, imap, interbase, intl, json, ldap, libxml, mbstring, mcrypt, memcache, memcached, mongo, msgpack, mysql, mysqli, openssl, pcntl, pcre, PDO, pdo_dblib, PDO_Firebird, pdo_mysql, pdo_pgsql, pdo_sqlite, pgsql, Phar, posix, pspell, readline, recode, redis, Reflection, session, shmop, SimpleXML, snmp, soap, sockets, SPL, SQLite, standard, sysvmsg, sysvsem, sysvshm, tidy, tokenizer, uploadprogress, wddx, xdebug, xml, xmlreader, xmlrpc, xmlwriter, xsl, Zend OPcache, zip, zlib</td>
  </tr>
  <tr>
   <th>5.3</th>
   <td id="53-base">Core, ctype, curl, date, dom, ereg, fileinfo, filter, hash, iconv, json, libxml, mysql, mysqlnd, openssl, pcre, PDO, pdo_sqlite, Phar, posix, readline, recode, Reflection, session, SimpleXML, SPL, SQLite, sqlite3, standard, tokenizer, xml, xmlreader, xmlwriter, zlib</td>
   <td id="53-mods">amqp, apc, apcu, bcmath, bz2, calendar, Core, ctype, curl, date, dba, dom, enchant, ereg, exif, fileinfo, filter, ftp, gd, gettext, gmp, hash, iconv, igbinary, imagick, imap, interbase, intl, json, ldap, libxml, mbstring, mcrypt, memcache, memcached, mongo, mongodb, msgpack, mysql, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_dblib, PDO_Firebird, pdo_mysql, pdo_pgsql, pdo_sqlite, pgsql, phalcon, Phar, posix, pspell, rdkafka, readline, recode, redis, Reflection, session, shmop, SimpleXML, snmp, soap, sockets, SPL, SQLite, sqlite3, standard, swoole, sysvmsg, sysvsem, sysvshm, tidy, tokenizer, uploadprogress, wddx, xdebug, xml, xmlreader, xmlrpc, xmlwriter, xsl, Zend OPcache, zip, zlib</td>
  </tr>
  <tr>
   <th>5.4</th>
   <td id="54-base">Core, ctype, curl, date, dom, ereg, fileinfo, filter, hash, iconv, json, libxml, mysqlnd, openssl, pcre, PDO, pdo_sqlite, Phar, posix, readline, recode, Reflection, session, SimpleXML, SPL, sqlite3, standard, tokenizer, xml, xmlreader, xmlwriter, zlib</td>
   <td id="54-mods">amqp, apc, apcu, bcmath, bz2, calendar, Core, ctype, curl, date, dba, dom, enchant, ereg, exif, fileinfo, filter, ftp, gd, gettext, gmp, hash, iconv, igbinary, imagick, imap, interbase, intl, json, ldap, libxml, mbstring, mcrypt, memcache, memcached, mongo, mongodb, msgpack, mysql, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_dblib, PDO_Firebird, pdo_mysql, pdo_pgsql, pdo_sqlite, pgsql, phalcon, Phar, posix, pspell, rdkafka, readline, recode, redis, Reflection, session, shmop, SimpleXML, snmp, soap, sockets, SPL, sqlite3, standard, swoole, sysvmsg, sysvsem, sysvshm, tidy, tokenizer, uploadprogress, wddx, xdebug, xml, xmlreader, xmlrpc, xmlwriter, xsl, Zend OPcache, zip, zlib</td>
  </tr>
  <tr>
   <th>5.5</th>
   <td id="55-base">Core, ctype, curl, date, dom, ereg, fileinfo, filter, ftp, hash, iconv, json, libxml, mbstring, mysqlnd, openssl, pcre, PDO, pdo_sqlite, Phar, posix, readline, Reflection, session, SimpleXML, SPL, sqlite3, standard, tokenizer, xml, xmlreader, xmlwriter, zlib</td>
   <td id="55-mods">amqp, apc, apcu, bcmath, bz2, calendar, Core, ctype, curl, date, dba, dom, enchant, ereg, exif, fileinfo, filter, ftp, gd, gettext, gmp, hash, iconv, igbinary, imagick, imap, interbase, intl, json, ldap, libxml, mbstring, mcrypt, memcache, memcached, mongo, mongodb, msgpack, mysql, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_dblib, PDO_Firebird, pdo_mysql, pdo_pgsql, pdo_sqlite, pgsql, phalcon, Phar, posix, pspell, rdkafka, readline, recode, redis, Reflection, session, shmop, SimpleXML, snmp, soap, sockets, SPL, sqlite3, standard, swoole, sysvmsg, sysvsem, sysvshm, tidy, tokenizer, uploadprogress, wddx, xdebug, xml, xmlreader, xmlrpc, xmlwriter, xsl, Zend OPcache, zip, zlib</td>
  </tr>
  <tr>
   <th>5.6</th>
   <td id="56-base">Core, ctype, curl, date, dom, ereg, fileinfo, filter, ftp, hash, iconv, json, libxml, mbstring, mhash, mysqlnd, openssl, pcre, PDO, pdo_sqlite, Phar, posix, readline, Reflection, session, SimpleXML, SPL, sqlite3, standard, tokenizer, xml, xmlreader, xmlwriter, zlib</td>
   <td id="56-mods">amqp, apc, apcu, bcmath, bz2, calendar, Core, ctype, curl, date, dba, dom, enchant, ereg, exif, fileinfo, filter, ftp, gd, gettext, gmp, hash, iconv, igbinary, imagick, imap, interbase, intl, json, ldap, libxml, mbstring, mcrypt, memcache, memcached, mhash, mongo, mongodb, msgpack, mysql, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_dblib, PDO_Firebird, pdo_mysql, pdo_pgsql, pdo_sqlite, pgsql, phalcon, Phar, posix, pspell, rdkafka, readline, recode, redis, Reflection, session, shmop, SimpleXML, snmp, soap, sockets, SPL, sqlite3, standard, swoole, sysvmsg, sysvsem, sysvshm, tidy, tokenizer, uploadprogress, wddx, xdebug, xml, xmlreader, xmlrpc, xmlwriter, xsl, Zend OPcache, zip, zlib</td>
  </tr>
  <tr>
   <th>7.0</th>
   <td id="70-base">Core, ctype, curl, date, dom, fileinfo, filter, ftp, hash, iconv, json, libxml, mbstring, mysqlnd, openssl, pcre, PDO, pdo_sqlite, Phar, posix, readline, Reflection, session, SimpleXML, SPL, sqlite3, standard, tokenizer, xml, xmlreader, xmlwriter, zlib</td>
   <td id="70-mods">amqp, apcu, bcmath, bz2, calendar, Core, ctype, curl, date, dba, dom, enchant, exif, fileinfo, filter, ftp, gd, gettext, gmp, hash, iconv, igbinary, imagick, imap, interbase, intl, json, ldap, libxml, mbstring, mcrypt, memcache, memcached, mongodb, msgpack, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_dblib, PDO_Firebird, pdo_mysql, pdo_pgsql, pdo_sqlite, pgsql, phalcon, Phar, posix, pspell, rdkafka, readline, recode, redis, Reflection, session, shmop, SimpleXML, snmp, soap, sockets, SPL, sqlite3, standard, swoole, sysvmsg, sysvsem, sysvshm, tidy, tokenizer, uploadprogress, wddx, xdebug, xml, xmlreader, xmlrpc, xmlwriter, xsl, Zend OPcache, zip, zlib</td>
  </tr>
  <tr>
   <th>7.1</th>
   <td id="71-base">Core, ctype, curl, date, dom, fileinfo, filter, ftp, hash, iconv, json, libxml, mbstring, mysqlnd, openssl, pcre, PDO, pdo_sqlite, Phar, posix, readline, Reflection, session, SimpleXML, SPL, sqlite3, standard, tokenizer, xml, xmlreader, xmlwriter, zlib</td>
   <td id="71-mods">amqp, apcu, bcmath, bz2, calendar, Core, ctype, curl, date, dba, dom, enchant, exif, fileinfo, filter, ftp, gd, gettext, gmp, hash, iconv, igbinary, imagick, imap, interbase, intl, json, ldap, libxml, mbstring, mcrypt, memcache, memcached, mongodb, msgpack, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_dblib, PDO_Firebird, pdo_mysql, pdo_pgsql, pdo_sqlite, pgsql, phalcon, Phar, posix, pspell, rdkafka, readline, recode, redis, Reflection, session, shmop, SimpleXML, snmp, soap, sockets, SPL, sqlite3, standard, swoole, sysvmsg, sysvsem, sysvshm, tidy, tokenizer, uploadprogress, wddx, xdebug, xml, xmlreader, xmlrpc, xmlwriter, xsl, Zend OPcache, zip, zlib</td>
  </tr>
  <tr>
   <th>7.2</th>
   <td id="72-base">Core, ctype, curl, date, dom, fileinfo, filter, ftp, hash, iconv, json, libxml, mbstring, mysqlnd, openssl, pcre, PDO, pdo_sqlite, Phar, posix, readline, Reflection, session, SimpleXML, sodium, SPL, sqlite3, standard, tokenizer, xml, xmlreader, xmlwriter, zlib</td>
   <td id="72-mods">amqp, apcu, bcmath, bz2, calendar, Core, ctype, curl, date, dba, dom, enchant, exif, fileinfo, filter, ftp, gd, gettext, gmp, hash, iconv, igbinary, imagick, imap, interbase, intl, json, ldap, libxml, mbstring, mcrypt, memcache, memcached, mongodb, msgpack, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_dblib, PDO_Firebird, pdo_mysql, pdo_pgsql, pdo_sqlite, pgsql, phalcon, Phar, posix, pspell, rdkafka, readline, recode, redis, Reflection, session, shmop, SimpleXML, snmp, soap, sockets, sodium, SPL, sqlite3, standard, swoole, sysvmsg, sysvsem, sysvshm, tidy, tokenizer, uploadprogress, wddx, xdebug, xml, xmlreader, xmlrpc, xmlwriter, xsl, Zend OPcache, zip, zlib</td>
  </tr>
  <tr>
   <th>7.3</th>
   <td id="73-base">Core, ctype, curl, date, dom, fileinfo, filter, ftp, hash, iconv, json, libxml, mbstring, mysqlnd, openssl, pcre, PDO, pdo_sqlite, Phar, posix, readline, Reflection, session, SimpleXML, sodium, SPL, sqlite3, standard, tokenizer, xml, xmlreader, xmlwriter, zlib</td>
   <td id="73-mods">apcu, bcmath, bz2, calendar, Core, ctype, curl, date, dba, dom, enchant, exif, fileinfo, filter, ftp, gd, gettext, gmp, hash, iconv, igbinary, imagick, imap, interbase, intl, json, ldap, libxml, mbstring, mcrypt, memcached, mongodb, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_dblib, PDO_Firebird, pdo_mysql, pdo_pgsql, pdo_sqlite, pgsql, Phar, posix, pspell, rdkafka, readline, recode, redis, Reflection, session, shmop, SimpleXML, snmp, soap, sockets, sodium, SPL, sqlite3, standard, swoole, sysvmsg, sysvsem, sysvshm, tidy, tokenizer, uploadprogress, wddx, xdebug, xml, xmlreader, xmlrpc, xmlwriter, xsl, Zend OPcache, zip, zlib</td>
  </tr>
  <tr>
   <th>7.4</th>
   <td id="74-base">Core, ctype, curl, date, dom, fileinfo, filter, ftp, hash, iconv, json, libxml, mbstring, mysqlnd, openssl, pcre, PDO, pdo_sqlite, Phar, posix, readline, Reflection, session, SimpleXML, sodium, SPL, sqlite3, standard, tokenizer, xml, xmlreader, xmlwriter, zlib</td>
   <td id="74-mods">bcmath, bz2, calendar, Core, ctype, curl, date, dba, dom, enchant, exif, fileinfo, filter, ftp, gd, gettext, gmp, hash, iconv, igbinary, imap, interbase, intl, json, ldap, libxml, mbstring, memcached, mongodb, mysqli, mysqlnd, openssl, pcntl, pcre, PDO, pdo_dblib, PDO_Firebird, pdo_mysql, pdo_pgsql, pdo_sqlite, pgsql, Phar, posix, pspell, rdkafka, readline, recode, redis, Reflection, session, shmop, SimpleXML, snmp, soap, sockets, sodium, SPL, sqlite3, standard, swoole, sysvmsg, sysvsem, sysvshm, tidy, tokenizer, uploadprogress, wddx, xml, xmlreader, xmlrpc, xmlwriter, xsl, Zend OPcache, zip, zlib</td>
  </tr>
 </tbody>
</table>



<h2><img id="php-fpm-features" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> PHP-FPM Features</h2>

#### Image: base
```shell
docker pull devilbox/php-fpm:5.2-base
docker pull devilbox/php-fpm:5.3-base
docker pull devilbox/php-fpm:5.4-base
docker pull devilbox/php-fpm:5.5-base
docker pull devilbox/php-fpm:5.6-base
docker pull devilbox/php-fpm:7.0-base
docker pull devilbox/php-fpm:7.1-base
docker pull devilbox/php-fpm:7.2-base
docker pull devilbox/php-fpm:7.3-base
docker pull devilbox/php-fpm:7.4-base
```

Generic PHP-FPM base image. Use it to derive your own php-fpm docker image from it and add more extensions, tools and injectables.<br/><br/><sub>(Does not offer any environment variables except for `NEW_UID` and `NEW_GID`)</sub>

#### Image: mods
```shell
docker pull devilbox/php-fpm:5.2-mods
docker pull devilbox/php-fpm:5.3-mods
docker pull devilbox/php-fpm:5.4-mods
docker pull devilbox/php-fpm:5.5-mods
docker pull devilbox/php-fpm:5.6-mods
docker pull devilbox/php-fpm:7.0-mods
docker pull devilbox/php-fpm:7.1-mods
docker pull devilbox/php-fpm:7.2-mods
docker pull devilbox/php-fpm:7.3-mods
docker pull devilbox/php-fpm:7.4-mods
```

Generic PHP-FPM image with fully loaded extensions. Use it to derive your own php-fpm docker image from it and add more extensions, tools and injectables.<br/><br/><sub>(Does not offer any environment variables except for `NEW_UID` and `NEW_GID`)</sub></td>

#### Image: prod
```shell
docker pull devilbox/php-fpm:5.2-prod
docker pull devilbox/php-fpm:5.3-prod
docker pull devilbox/php-fpm:5.4-prod
docker pull devilbox/php-fpm:5.5-prod
docker pull devilbox/php-fpm:5.6-prod
docker pull devilbox/php-fpm:7.0-prod
docker pull devilbox/php-fpm:7.1-prod
docker pull devilbox/php-fpm:7.2-prod
docker pull devilbox/php-fpm:7.3-prod
docker pull devilbox/php-fpm:7.4-prod
```

Devilbox production image. This Docker image comes with many injectables, port-forwardings, mail-catch-all and user/group rewriting.

#### Image: work
```shell
docker pull devilbox/php-fpm:5.2-work
docker pull devilbox/php-fpm:5.3-work
docker pull devilbox/php-fpm:5.4-work
docker pull devilbox/php-fpm:5.5-work
docker pull devilbox/php-fpm:5.6-work
docker pull devilbox/php-fpm:7.0-work
docker pull devilbox/php-fpm:7.1-work
docker pull devilbox/php-fpm:7.2-work
docker pull devilbox/php-fpm:7.3-work
docker pull devilbox/php-fpm:7.4-work
```

Devilbox development image. Same as prod, but comes with lots of locally installed tools to make development inside the container as convenient as possible. See [Integrated Development Environment](#integrated-development-environment) for more information about this.



<h2><img id="php-fpm-options" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> PHP-FPM Options</h2>

#### Environment variables

Have a look at the following table to see all supported environment variables for each Docker image flavour.
<table>
 <thead>
  <tr>
   <th>Image</th>
   <th>Env Variable</th>
   <th>Type</th>
   <th>Default</th>
   <th>Description</th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td rowspan="3"><strong>base</strong><br/><br/><strong>mods</strong><br/><br/><strong>prod</strong><br/><br/><strong>work</strong></td>
   <td><code>DEBUG_ENTRYPOINT</code></td>
   <td>int</td>
   <td><code>0</code></td>
   <td>Set debug level for startup.<br/><sub><code>0</code> Only warnings and errors are shown.<br/><code>1</code> All log messages are shown<br/><code>2</code> All log messages and executed commands are shown.</sub></td>
  </tr>
  <tr>
   <td><code>NEW_UID</code></td>
   <td>int</td>
   <td><code>1000</code></td>
   <td>Assign the PHP-FPM user a new <code>uid</code> in order to syncronize file system permissions with your host computer and the Docker container. You should use a value that matches your host systems local user.<br/><sub>(Type <code>id -u</code> for your uid).</sub></td>
  </tr>
  <tr>
   <td><code>NEW_GID</code></td>
   <td>int</td>
   <td><code>1000</code></td>
   <td>Assign the PHP-FPM group a new <code>gid</code> in order to syncronize file system permissions with your host computer and the Docker container. You should use a value that matches your host systems local group.<br/><sub>(Type <code>id -g</code> for your gid).</sub></td>
  </tr>
  <tr>
   <td colspan="5"></td>
  </tr>
  <tr>
   <td rowspan="6"><strong>prod</strong><br/><br/><strong>work</strong></td>
   <td><code>TIMEZONE</code></td>
   <td>string</td>
   <td><code>UTC</code></td>
   <td>Set docker OS timezone as well as PHP timezone.<br/>(Example: <code>Europe/Berlin</code>)</td>
  </tr>
  <tr>
   <td><code>DOCKER_LOGS</code></td>
   <td>bool</td>
   <td><code>1</code></td>
   <td>By default all Docker images are configured to output their PHP-FPM access and error logs to stdout and stderr. Those which support it can change the behaviour to log into files inside the container. Their respective directories are available as volumes that can be mounted to the host computer. This feature might help developer who are more comfortable with tailing or searching through actual files instead of using docker logs.<br/><br/>Set this variable to <code>0</code> in order to enable logging to files. Log files are avilable under <code>/var/log/php/</code> which is also a docker volume that can be mounted locally.</td>
  </tr>
  <tr>
   <td><code>ENABLE_MODULES</code></td>
   <td>string</td>
   <td><code>''</code></td>
   <td>Comma separated list of PHP modules to enable, which are not enabled by default.<br/><strong>Example:</strong><br/><code>ENABLE_MODULES=ioncube</code></td>
  </tr>
  <tr>
   <td><code>DISABLE_MODULES</code></td>
   <td>string</td>
   <td><code>''</code></td>
   <td>Comma separated list of PHP modules to disable.<br/><strong>Example:</strong><br/><code>DISABLE_MODULES=swoole,imagick</code></td>
  </tr>
  <tr>
   <td><code>ENABLE_MAIL</code></td>
   <td>bool</td>
   <td><code>0</code></td>
   <td>Enable local email catch-all.<br/>Postfix will be configured for local delivery and all mails sent (even to real domains) will be catched locally. No email will ever go out. They will all be stored in a local devilbox account.<br/>Value: <code>0</code> or <code>1</code></td>
  </tr>
  <tr>
   <td><code>FORWARD_PORTS_TO_LOCALHOST</code></td>
   <td>string</td>
   <td></td>
   <td>List of remote ports to forward to 127.0.0.1.<br/><strong>Format:</strong><br/><sub><code>&lt;local-port&gt;:&lt;remote-host&gt;:&lt;remote-port&gt;</code></sub><br/>You can separate multiple entries by comma.<br/><strong>Example:</strong><br/><sub><code>3306:mysqlhost:3306, 6379:192.0.1.1:6379</code></sub></td>
  </tr>
  <tr>
   <td colspan="5"></td>
  </tr>
  <tr>
   <td rowspan="3"><strong>work</strong></td>
   <td><code>MYSQL_BACKUP_USER</code></td>
   <td>string</td>
   <td><code>''</code></td>
   <td>Username for mysql backups used for bundled <a href="https://mysqldump-secure.org" >mysqldump-secure</a></td>
  </tr>
  <tr>
   <td><code>MYSQL_BACKUP_PASS</code></td>
   <td>string</td>
   <td><code>''</code></td>
   <td>Password for mysql backups used for bundled <a href="https://mysqldump-secure.org" >mysqldump-secure</a></td>
  </tr>
  <tr>
   <td><code>MYSQL_BACKUP_HOST</code></td>
   <td>string</td>
   <td><code>''</code></td>
   <td>Hostname for mysql backups used for bundled <a href="https://mysqldump-secure.org" >mysqldump-secure</a></td>
  </tr>
 </tbody>
</table>

#### Volumes

Have a look at the following table to see all offered volumes for each Docker image flavour.

<table>
 <thead>
  <tr>
   <th>Image</th>
   <th width="240">Volumes</th>
   <th>Description</th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td rowspan="5"><strong>prod</strong><br/><br/><strong>work</strong></td>
   <td><code>/etc/php-custom.d</code></td>
   <td>Mount this directory into your host computer and add custom <code>\*.ini</code> files in order to alter php behaviour.</td>
  </tr>
  <tr>
   <td><code>/etc/php-fpm-custom.d</code></td>
   <td>Mount this directory into your host computer and add custom PHP-FPM <code>\*.conf</code> files in order to alter PHP-FPM behaviour.</td>
  </tr>
  <tr>
   <td><code>/etc/php-modules.d</code></td>
   <td>Mount this directory into your host computer and add custo <code>\*.so</code> files in order to add your php modules.<br/><br/><strong>Note:</strong>Your should then also provide a custom <code>\*.ini</code> file in order to actually load your custom provided module.</td>
  </tr>
  <tr>
   <td><code>/var/log/php</code></td>
   <td>When setting environment variable <code>DOCKER_LOGS</code> to <code>0</code>, log files will be available under this directory.</td>
  </tr>
  <tr>
   <td><code>/var/mail</code></td>
   <td>Emails caught be the postfix catch-all (<code>ENABLE_MAIL=1</code>) will be available in this directory.</td>
  </tr>
  <tr>
   <td colspan="3"></td>
  </tr>
  <tr>
   <td rowspan="3"><strong>work</strong></td>
   <td><code>/etc/bashrc-devilbox.d</code></td>
   <td>Mount this directory into your host computer and add custom configuration files for <code>bash</code> and other tools.</td>
  </tr>
  <tr>
   <td><code>/shared/backups</code></td>
   <td>Mount this directory into your host computer to access MySQL backups created by <a href="https://mysqldump-secure.org" >mysqldump-secure</a>.</td>
  </tr>
  <tr>
   <td><code>/ca</code></td>
   <td>Mount this directory into your host computer to bake any *.crt file that is located in there as a trusted SSL entity.</td>
  </tr>
 </tbody>
</table>


#### Ports

Have a look at the following table to see all offered exposed ports for each Docker image flavour.

<table>
 <thead>
  <tr>
   <th>Image</th>
   <th width="200">Port</th>
   <th>Description</th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td rowspan="1"><strong>base</strong><br/><strong>mods</strong><br/><strong>prod</strong><br/><strong>work</strong></td>
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
| work    | [php.ini](Dockerfiles/work/data/php-ini.d/) [php-fpm.conf](Dockerfiles/work/data/php-fpm.conf/) |



<h2><img id="integrated-development-environment" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Integrated Development Environment</h2>

If you plan to use the PHP-FPM image for development, hence being able to execute common commands inside the container itself, you should go with the **work** Image.

The **work** Docker image has many common tools already installed which on one hand increases its image size, but on the other hand removes the necessity to install those tools locally.

You want to use tools such as `git`, `drush`, `composer`, `npm`, `eslint`, `phpcs` as well as many others, simply do it directly inside the container. As all Docker images are auto-built every night by travis-ci it is assured that you are always at the latest version of your favorite dev tool.


#### What tools can you expect

<table>
 <thead>
  <tr>
   <th width="200">Tool</th>
   <th>Description</th>
  </tr>
 </thead>
  <tr>
   <td><a href="https://www.ansible.com/">Ansible</a></td>
   <td>Automation tool.</td>
  </tr>
  <tr>
   <td><a href="https://asgardcms.com/install">asgardcms</a></td>
   <td>AsgardCMS cli installer.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/cytopia/awesome-ci">awesome-ci</a></td>
   <td>Various linting and source code analyzing tools.</td>
  </tr>
  <tr>
   <td><a href="https://codeception.com/">codeception</a></td>
   <td>Elegant and efficient testing for PHP.</td>
  </tr>
  <tr>
   <td><a href="https://getcomposer.org">composer</a></td>
   <td>Dependency Manager for PHP.</td>
  </tr>
  <tr>
   <td><a href="https://deployer.org/">deployer</a></td>
   <td>Deployment tool for PHP.</td>
  </tr>
  <tr>
   <td><a href="https://drupalconsole.com">drupal-console</a></td>
   <td>The Drupal CLI. A tool to generate boilerplate code, interact with and debug Drupal.</td>
  </tr>
  <tr>
   <td><a href="http://www.drush.org">drush</a></td>
   <td>Drush is a computer software shell-based application used to control, manipulate, and administer Drupal websites.</td>
  </tr>
  <tr>
   <td><a href="https://eslint.org">eslint</a></td>
   <td>The pluggable linting utility for JavaScript and JSX.</td>
  </tr>
  <tr>
   <td><a href="https://git-scm.com">git</a></td>
   <td>Git is a version control system for tracking changes in source files.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/nvie/gitflow">git-flow</a></td>
   <td>Git-flow tools.</td>
  </tr>
  <tr>
   <td><a href="https://gulpjs.com/">gulp</a></td>
   <td>Gulp command line JS tool.</td>
  </tr>
  <tr>
   <td><a href="https://gruntjs.com/">grunt</a></td>
   <td>Grunt command line JS tool.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/zaach/jsonlint">jsonlint</a></td>
   <td>Json command line linter.</td>
  </tr>
  <tr>
   <td><a href="https://stedolan.github.io/jq/">jq</a></td>
   <td>Command-line JSON processor.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/laravel/installer">laravel installer</a></td>
   <td>A CLI tool to easily install and manage the laravel framework.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/cytopia/linkcheck">linkcheck</a></td>
   <td>Search for URLs in files (optionally limited by extension) and validate their HTTP status code.</td>
  </tr>
  <tr>
   <td><a href="http://linuxbrew.sh">linuxbrew</a></td>
   <td>The Homebrew package manager for Linux.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/markdownlint/markdownlint">mdl</a></td>
   <td>Markdown command line linter.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/ChrisWren/mdlint">mdlint</a></td>
   <td>Markdown command line linter.</td>
  </tr>
  <tr>
   <td><a href="https://mysqldump-secure.org">mysqldump-secure</a></td>
   <td>Secury MySQL database backup tool with encryption.</td>
  </tr>
  <tr>
   <td><a href="https://nodejs.org">nodejs</a></td>
   <td>Node.js is an open-source, cross-platform JavaScript run-time environment for executing JavaScript code server-side.</td>
  </tr>
  <tr>
   <td><a href="https://www.npmjs.com">npm</a></td>
   <td>npm is a package manager for the JavaScript programming language.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/phalcon/phalcon-devtools">phalcon-devtools</a></td>
   <td>CLI tool to generate code helping to develop faster and easy applications that use with Phalcon framework.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/squizlabs/PHP_CodeSniffer">phpcs</a></td>
   <td>PHP_CodeSniffer tokenizes PHP, JavaScript and CSS files and detects violations of a defined set of coding standards.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/squizlabs/PHP_CodeSniffer">phpcbf</a></td>
   <td>PHP Code Beautifier and Fixer.</td>
  </tr>
  <tr>
   <td><a href="https://photoncms.com/resources/installing">photon</a></td>
   <td>Photon CMS cli.</td>
  </tr>
  <tr>
   <td><a href="http://sass-lang.com/">sass</a></td>
   <td>Sass CSS compiler.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/brigade/scss-lint">scss-lint</a></td>
   <td>Sass/CSS command line linter.</td>
  </tr>
  <tr>
   <td><a href="https://www.openssh.com/">ssh</a></td>
   <td>OpenSSH command line client.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/symfony/symfony-installer">symfony installer</a></td>
   <td>This is the official installer to start new projects based on the Symfony full-stack framework.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/jonas/tig">tig</a></td>
   <td>Text-mode Interface for Git.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/webpack/webpack">webpack</a></td>
   <td>A bundler for javascript and friends.</td>
  </tr>
  <tr>
   <td><a href="https://wp-cli.org">wp-cli</a></td>
   <td>WP-CLI is the command-line interface for WordPress.</td>
  </tr>
  <tr>
   <td><a href="https://github.com/adrienverge/yamllint">yamllint</a></td>
   <td>Yaml command line linter.</td>
  </tr>
  <tr>
   <td><a href="https://yarnpkg.com/en">yarn</a></td>
   <td>Fast, reliable and secure dependency management.</td>
  </tr>
 <tbody>
 </tbody>
</table>


#### What else is available

Apart from the provided tools, you will also be able to use the container similar as you would do with your host system. Just a few things to mention here:

* Mount custom bash configuration files so your config persists between restarts
* Use password-less `sudo` to become root and do whatever you need to do

If there is anything else you'd like to be able to do, drop me an issue.


<h2><img id="examples" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Examples</h2>

#### Provide PHP-FPM port to host
```shell
$ docker run -d \
    -p 127.0.0.1:9000:9000 \
    -t devilbox/php-fpm:7.2-prod
```

#### Alter PHP-FPM and system timezone
```shell
$ docker run -d \
    -p 127.0.0.1:9000:9000 \
    -e TIMEZONE=Europe/Berlin \
    -t devilbox/php-fpm:7.2-prod
```

#### Load custom PHP configuration

`config/` is a local directory that will hold the PHP *.ini files you want to load into the Docker container.
```shell
# Create config directory to be mounted with dummy configuration
$ mkdir config
$ echo "xdebug.enable = 1" > config/xdebug.ini

# Run container and mount it
$ docker run -d \
    -p 127.0.0.1:9000:9000 \
    -v config:/etc/php-custom.d \
    -t devilbox/php-fpm:7.2-prod
```

#### Load custom PHP modules

`modules/` is a local directory that will hold the PHP modules you want to mount into the Docker container. `config/` is a local directory that will hold the PHP *.ini files you want to load into the Docker container.

```shell
# Create module directory and place module into it
$ mkdir modules
$ cp /my/module/phalcon.so modules/

# Custom php config to load this module
$ mkdir config
$ echo "extension=/etc/php-modules.d/phalcon.so" > config/phalcon.ini

# Run container and mount it
$ docker run -d \
    -p 127.0.0.1:9000:9000 \
    -v config:/etc/php-custom.d \
    -v modules:/etc/php-modules.d \
    -t devilbox/php-fpm:7.2-prod
```

#### MySQL connect via 127.0.0.1 (via port-forward)

Forward MySQL Port from `172.168.0.30` (or any other IP address/hostname) and Port `3306` to the PHP docker on `127.0.0.1:3306`. By this, your PHP files inside the docker can use `127.0.0.1` to connect to a MySQL database.
```shell
$ docker run -d \
    -p 127.0.0.1:9000:9000 \
    -e FORWARD_PORTS_TO_LOCALHOST='3306:172.168.0.30:3306' \
    -t devilbox/php-fpm:7.2-prod
```

#### MySQL and Redis connect via 127.0.0.1 (via port-forward)

Forward MySQL Port from `172.168.0.30:3306` and Redis port from `redis:6379` to the PHP docker on `127.0.0.1:3306` and `127.0.0.1:6379`. By this, your PHP files inside the docker can use `127.0.0.1` to connect to a MySQL or Redis database.
```shell
$ docker run -d \
    -p 127.0.0.1:9000:9000 \
    -e FORWARD_PORTS_TO_LOCALHOST='3306:172.168.0.30:3306, 6379:redis:6379' \
    -t devilbox/php-fpm:7.2-prod
```

#### Launch Postfix for mail-catching

Once you set `$ENABLE_MAIL=1`, all mails sent via any of your PHP applications no matter to which domain, are catched locally into the `devilbox` account. You can also mount the mail directory locally to hook in with mutt and read those mails.
```shell
$ docker run -d \
    -p 127.0.0.1:9000:9000 \
    -v /tmp/mail:/var/mail \
    -e ENABLE_MAIL=1 \
    -t devilbox/php-fpm:7.2-prod
```

#### Webserver and PHP-FPM

`~/my-host-www` will be the directory that serves the php files (your document root). Make sure to mount it into both, php and the webserver.
```shell
# Start PHP-FPM container
$ docker run -d \
    -v ~/my-host-www:/var/www/default/htdocs \
    --name php \
    -t devilbox/php-fpm:7.2-prod

# Start webserver and link with PHP-FPM
$ docker run -d \
    -p 80:80 \
    -v ~/my-host-www:/var/www/default/htdocs \
    -e PHP_FPM_ENABLE=1 \
    -e PHP_FPM_SERVER_ADDR=php \
    -e PHP_FPM_SERVER_PORT=9000 \
    --link php \
    -t devilbox/nginx-mainline
```

#### Create MySQL Backups

**Note:** This will only work with `work` Docker images.

The MySQL server could be another Docker container linked to the PHP-FPM container. Let's assume the PHP-FPM container is able to access the MySQL container by the hostname `mysql`.

```
# Start container
$ docker run -d \
    -e MYSQL_BACKUP_USER=root \
    -e MYSQL_BACKUP_PASS=somepass \
    -e MYSQL_BACKUP_HOST=mysql \
    -v ~/backups:/shared/backsup \
    --name php \
    -t devilbox/php-fpm:7.2-work

# Run database dump
$ docker exec -it php mysqldump-secure
```

<h2><img id="automated-builds" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Automated builds</h2>

[![Build Status](https://travis-ci.org/devilbox/docker-php-fpm.svg?branch=master)](https://travis-ci.org/devilbox/docker-php-fpm)

Docker images are built and tested every night by **[travis-ci](https://travis-ci.org/devilbox/docker-php-fpm)** and pushed to **[Docker hub](https://hub.docker.com/r/devilbox/php-fpm/)** on success. This is all done automatically to ensure that sources as well as base images are always fresh and in case of security updates always have the latest patches.

<h2><img id="contributing" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Contributing</h2>

Contributors are welcome. Feel free to star and clone this repository and submit issues and pull-requests. Add examples and show what you have created with the provided images. If you see any errors or ways to improve this repository in any way, please do so.

<h2><img id="credits" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Credits</h2>

* **[cytopia](https://github.com/cytopia)**

<h2><img id="license" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> License</h2>

**[MIT License](LICENSE.md)**

Copyright (c) 2017 [cytopia](https://github.com/cytopia)
