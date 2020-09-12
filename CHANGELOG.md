# Changelog


## Unreleased


## Release 0.110

#### Fixed
- [169](https://github.com/devilbox/docker-php-fpm/issues/169) Fixes download for drupal console


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
