# Changelog


## Unreleased


## Release 0.121

#### Fixed
- Fixed `msgpack` install for PHP 7.0 - 7.4

#### Changed
- Compile `redis` extension with `msgpack` and `igbinary`


## Release 0.120

#### Fixed
- Fixed `zsh` install for PHP 5.6 and 7.0


## Release 0.119

#### Fixed
- Fixed `drupal` (drupal console launcher) for PHP 5.5, 5.6, 7.0 and 7.1
- Fixed `zsh` install for PHP 5.6 and 7.0


## Release 0.118

#### Fixed
- Fixed `mdl` rubygem

#### Added
- [#182](https://github.com/devilbox/docker-php-fpm/issues/182) Added `ioncube` to PHP 7.4
- Added `sqlsrv` to PHP 7.4

#### Changed
- Updated xdebug to latest possible version


## Release 0.117

#### Fixed
- [#755](https://github.com/cytopia/devilbox/issues/755) Add .composer/vendir/bin to $PATH variable

#### Added
- [#692](https://github.com/cytopia/devilbox/issues/692) Add custom supervisor config mountpoint


## Release 0.116

#### Fixed
- [#749](https://github.com/cytopia/devilbox/issues/749) Fix to disable PHP modules without trailing `*.so` extension


## Release 0.115

#### Fixed
- [#703](https://github.com/cytopia/devilbox/issues/703) Don't fail on uid/gid change


## Release 0.114

#### Fixed
- Use latest PHP 8.0 image
- Disabled gd-jis: https://bugs.php.net/bug.php?id=73582

#### Added
- Add PHP 8.1
- PHP module mongodb is added to PHP 8.0

#### Changed
- Composer is updated to v2 (/usr/local/bin/composer)
- Composer is available as v1 and v2 (/usr/local/bin/composer-[12])


## Release 0.113

#### Fixed
- Fixes nightly build pipeline


## Release 0.112

#### Fixed
- Fixes [166](https://github.com/devilbox/docker-php-fpm/issues/166) Missing `locale-gen` binary

#### Added
- Added vips extension
- Added xlswriter extension


## Release 0.111

#### Added
- Added xdebug for PHP 8.0


## Release 0.110

#### Fixed
- [169](https://github.com/devilbox/docker-php-fpm/issues/169) Fixes download for drupal console
- Fixes laravel installer for PHP 7.2


## Release 0.109

#### Fixed
- Fixed absolute paths in tests


## Release 0.108

#### Added
- Added ghostscript
- Added gsfonts
- Added imagick PDF support (via ghostscript)
- Added mupdf and mupdf-tools

#### Fixed
- Fixes Ansible installation
- Fixes MongoDB for PHP 5.6
- Fixes Redis for PHP 8.0
- Fixes policy.xml for Imagick

#### Changed
- Stricter version check for installed tools


## Release 0.107

#### Fixed
- Fixes login to Dockerhub for CI jobs
- Fixes imagick segfault by setting its threads to 1

#### Added
- Re-added imap for PHP 7.4
- Adding `certbot` binary


## Release 0.106

#### Fixed
- [#153](https://github.com/devilbox/docker-php-fpm/pull/153) Use numeric order for startup files
- Fix build of PHP-FPM 7.4 snmp module
- Disable PHP-FPM 8.0 uploadprogress module due to startup warnings


## Release 0.105

#### Fixed
- Fix pdo_sqlsrv install for PHP 7.1
- Fix sqlsrv install for PHP 7.1
- Fix composer memory issues during install

#### Added
- `phalcon` binary for PHP 7.3 and 7.4


## Release 0.104

#### Fixed
- Fix xdebug install for PHP 7.0


## Release 0.103

#### Added
- Add PHP [yaml](https://pecl.php.net/package/yaml) module


## Release 0.102

#### Added
- [#144](https://github.com/devilbox/docker-php-fpm/issues/144) Added CHANGELOG

#### Changed
- [#123](https://github.com/devilbox/docker-php-fpm/issues/123) Added Dart Sass and removed Ruby Sass
- Replace [scss-lint](https://github.com/sds/scss-lint) with [stylelint](https://github.com/stylelint/stylelint)
