[Permissions](syncronize-file-permissions.md) |
[Tags](docker-tags.md) |
[Architectures](supported-architectures.md) |
[Versions](php-versions.md) |
Flavours |
[Extensions](php-modules.md) |
[Tools](available-tools.md) |
[Env Vars](docker-env-variables.md) |
[Volumes](docker-volumes.md) |
[Base Images](base-images.md)

---

<h2><img name="Documentation" title="Documentation" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Documentation</h2>



### Flavours

Flavours are just different PHP-FPM images that are build on top of each other. Each layer adding more functionality. This makes it easier to separate images based on certain criterias and allows the user to pick a flavor that suits.


#### base

> **builds from:** Official PHP images

Generic PHP-FPM base image. Use it to derive your own php-fpm docker image from it and add more extensions, tools and injectables.<br/><sub>(Does not offer any environment variables except for `NEW_UID` and `NEW_GID`)</sub>

#### mods

> **build from:** devilbox/php-fpm `base` flavour

Generic PHP-FPM image with fully loaded extensions. Use it to derive your own php-fpm docker image from it and add more extensions, tools and injectables.<br/><sub>(Does not offer any environment variables except for `NEW_UID` and `NEW_GID`)</sub>

#### prod

> **build from:** devilbox/php-fpm `mods` flavour

Devilbox production image. This Docker image comes with many injectables, port-forwardings, mail-catch-all and user/group rewriting.

#### slim

> **build from:** devilbox/php-fpm `prod` flavour

Devilbox intranet-ready image. Similar to `prod`, but contains least subset of required cli tools to make the Devilbox intranet work.

#### work

> **build from:** devilbox/php-fpm `slim` flavour

Devilbox development image. Same as `slim`, but comes with lots of locally installed [tools](available-tools.md) to make development inside the container as convenient as possible. See [Integrated Development Environment](../README.md#integrated-development-environment) for more information about this.
