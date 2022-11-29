Permissions |
[Tags](docker-tags.md) |
[Architectures](supported-architectures.md) |
[Versions](php-versions.md) |
[Flavours](flavours.md) |
[Extensions](php-modules.md) |
[Tools](available-tools.md) |
[Env Vars](docker-env-variables.md) |
[Volumes](docker-volumes.md) |
[Base Images](base-images.md)

---

<h2><img name="Documentation" title="Documentation" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Documentation</h2>



### Motivation

One main problem with a running Docker container is to **synchronize the ownership of files in a mounted volume** in order to preserve security (Not having to use `chmod 0777`).


### Unsynchronized permissions

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


### It gets even worse

Consider your had created the `tmp/` directory on your host only with `0775` permissions:

```shell
                  [Host]                   |             [Container]
------------------------------------------------------------------------------------------
 $ ls -l                                   | $ ls -l
 -rw-r--r-- user group index.php           | -rw-r--r-- 1000 1000 index.php
 drwxrwxr-x user group tmp/                | drwxrwxr-x 1000 1000 tmp/
```

If your web application now wants to create some temporary files (via the PHP-FPM process) inside the `tmp/` directory, it will fail due to lacking permissions.


### The solution

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
