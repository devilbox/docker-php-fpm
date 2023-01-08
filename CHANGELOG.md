# Changelog


## Unreleased


## Release 0.151

### Added
- Allow to use supervisorctl to be able to reload PHP configuration without restarting


## Release 0.150

### Added
- Added `xhprof` PHP extension


## Release 0.149

### Added
- Added `net-tools` package


## Release 0.148

### Added
- Added `wscat` to work with websockets


## Release 0.147

### Fixed
- Fixed wkhtmltopdf version finder during install
- Fixed wp-cli runtime requirements (needs `less` in order to function)


## Release 0.146

This release adds lots of documentation about recently added features.

### Added
- Documentation


## Release 0.145

This is a massive restructuring release, which adds another layer on top of Ansible to easily manage/edit/add PHP tools and to configure their respective order of building and installing.

Additionally it introduces a new flavour: `slim` which is an intermediated stage between `prod` and `work`. It allows for a slim image with only required cli tools to work with the Devilbox.

### Added
- New PHP Flavour: `slim`
- Added `mhsendmail` for `arm64` architecture
- Added `wkhtmltopdf` for `arm64 architecture [#252](https://github.com/devilbox/docker-php-fpm/issues/252)
- Added `taskfile` (https://taskfile.dev/)
- Added mechanism to easily build custom images with custom set of PHP tools
- Added automated PHP tools dependency resolver (order of built is always correct)
- Added tons of documentation

### Changed
- Split out PHP tools into separate directories

### Fixed
- Fixed `xdebug` build


## Release 0.144

This is a massive restructuring release, which adds another layer on top of Ansible to easily manage/edit/add PHP extensions and to configure their respective order of building and loading.

### Added
- Added PHP extension: `lz4`
- Added PHP extension: `lzf`
- Added PHP extension: `zstd`
- Added mechanism to easily build custom images with custom set of PHP extensions
- Added automated PHP extension dependency resolver (order of built is always correct)
- Added tons of documentation
- Added Credit to contributors

### Changed
- Added serializer for Redis extension: `lz4`, `lzf` and `zstd`
- Restructured Documentation
- Split out PHP extensions into separate directories


## Release 0.143

### Added
- Added `phalcon` 5.x to PHP 8.0 and PHP 8.1


## Release 0.142

### Fixed
- Fixed `phalcon` module
- Fixed `swoole` module
- Fixed installation of wkhtmltopdf [#245](https://github.com/devilbox/docker-php-fpm/pull/245)
- FIxed installation of drupalconsole [#246](https://github.com/devilbox/docker-php-fpm/pull/246)
- Fixed installation of symfoni cli [#247](https://github.com/devilbox/docker-php-fpm/pull/247)
- Fixed installation of NodeJS
- Fixed installation of PostgreSQL client for PHP 5.6
- Fixed installation of PostgreSQL client for PHP 7.0
- Disabled Phalcon Devtools for PHP 7.4 as it breaks


## Release 0.141

### Fixed
- Fixed correct permission for `/opt/nvm` during startup


## Release 0.140

### Changed
- Ensure apt Jessie repositories are trusted beyond EOL


## Release 0.139

#### Added
- (Re-)added mongodb command line client
- (Re-)added postgresql command line client

### Changed
- Speed up `xargs` commands by using multi-CPU
- Use buildkit for building


## Release 0.138

#### Added
- Added arm64 support
- Added `vips` module for PHP 8.0
- Added `vips` module for PHP 8.1
- Added `swoole` module for PHP 8.1

#### Changed
- Separated nightly jobs


## Release 0.137

#### Fixed
- Fixed imklog: cannot open kernel log (/proc/kmsg): Operation not permitted.

#### Changed
- Ensured CI tests are platform agnostic (amd64 vs arm64)
- Ensured CI pipeline will work for long-running jobs

#### Removed
- Removed homebrew due to arm64 issues
- Removed postgres cmd client and apt repositories due to arm64 issues
- Removed mongodb cmd client and apt repositories due to arm64 issues
- Removed Ansible due to arm64 issues


## Release 0.136

#### Fixed
- Fixed `mongodb-org-shell` and `mongodb-org-tools` install

#### Added
- Re-added `mongodb` for PHP 5.3

#### Changed
- Switch PHP 5.4 base image to [devilbox/php-fpm-5.4](https://github.com/devilbox/docker-php-fpm-5.4) for potential arm64 support
- Switch PHP 5.5 base image to [devilbox/php-fpm-5.5](https://github.com/devilbox/docker-php-fpm-5.5) for potential arm64 support
- Changed base image back to Debian Jessie for PHP 5.2 and PHP 5.3


## Release 0.135

#### Fixed
- Fixed cloning of gitflow
- Fixed pidof issue on QUEMU by replacing it with pgrep [#854](https://github.com/cytopia/devilbox/issues/854)

#### Changed
- Changed PHP 5.2 and PHP 5.3 base images to Debian stretch
- Removed photoncms binaries (their GitHub organization went private)
- Removed `mongodb` extension from PHP 5.3 due to build errors
- Removed `ioncube` extension for PHP 5.2, PHP 5.3 and PHP 5.4 (arm64 only supported from PHP 5.5 onwards)
- Removed `codeception` from PHP 5.3


## Release 0.134

#### Changed
- Added extension `xdebug` to PHP 8.2


## Release 0.133

#### Added
- Added PHP 8.2: https://github.com/devilbox/docker-php-fpm-8.2


## Release 0.132

#### Fixed
- Fixed `nvm` PATH priority [#846](https://github.com/cytopia/devilbox/issues/846)

#### Added
- added extension `sqlsrv` to php 8.1
- added extension `pdo_sqlsrv` to php 8.1

#### Changed
- Changed postfix hostname to `localhost` instead of GitHub runners long name


## Release 0.131

#### Added
- Added binary `sqlite3` to all PHP images [#856](https://github.com/cytopia/devilbox/issues/856)
- Added binary `laravel` to PHP 8.0 and PHP 8.1 [#823](https://github.com/cytopia/devilbox/issues/823)
- Added AVIF support in GD for PHP 8.1 [#834](https://github.com/cytopia/devilbox/issues/834)
- Added extension `amqp` to PHP 8.0 and PHP 8.1 [#826](https://github.com/cytopia/devilbox/issues/826)
- Added extension `uploadprogress` to PHP 8.0 and PHP 8.1 [#158](https://github.com/devilbox/docker-php-fpm/pull/158)
- Added extension `imagick` to PHP 8.0 and PHP 8.1
- Added extension `rdkafka` to PHP 8.0 and PHP 8.1
- Added extension `xlswriter` to PHP 8.1
- Added extension `pdo_dblib` to PHP 8.1
- Added extension `uuid` to all PHP versions (except 5.2)

#### Changed
- Updated `php-cs-fixer` to latest version [#219](https://github.com/devilbox/docker-php-fpm/pull/219)


## Release 0.130

#### Fixed
- Fixed correct keys for `apt`

#### Added
- Added integration checks for `apt update`


## Release 0.129

#### Fixed
- Pinned module: `uploadprogress`
- Pinned module: `mongodb`
- Pinned lib: `libenchant`
- Pinned lib: `libicu`
- Pinned lib: `libvpx`
- Pinned PHP 8.0: https://github.com/devilbox/docker-php-fpm-8.0/pull/16
- Pinned PHP 8.1: https://github.com/devilbox/docker-php-fpm-8.1/pull/9
- Fixed `pgsql` apt key
- Fixed `deployer` download on cert issues
- Fixed `phpmd` download on cert issues
- Fixed `phpunit` download on cert issues
- Fixed `php-cs-fixer` download on cert issues
- Fixed building `sockets` on PHP 8.0 and PHP 8.1
- Fixed building `ffi` on PHP 7.4

#### Changed
- Removed `mcrypt` from PHP 8.1 as it is not yet supported
- Removed `enchant` from PHP 7.3 and PHP 7.4 as libenchant1 is not available via apt
- Updated PHP 8.0 base image to BullsEye: https://github.com/devilbox/docker-php-fpm-8.0/pull/17
- Updated PHP 8.1 base image to BullsEye: https://github.com/devilbox/docker-php-fpm-8.1/pull/10
- Updated PostgreSQL repos to Bullseye for PHP >= 7.3
- Updated `pip` to use Python3 for PHP >= 7.3


## Release 0.128

#### Added
- Adding `pdo_sqlsrv` to more PHP versions


## Release 0.127

#### Changed
- Adding `swoole` to more PHP 8.0


## Release 0.126

#### Changed
- Added Homebrew for all versions


## Release 0.125

#### Changed
- Re-added `opcache` for PHP 8.1
- Pin `ansible` version for all work images
- Pin `wp-cli` version for PHP 5.4 and 5.5


## Release 0.124

#### Fixed
- Fixed `pdo_sqlsrv` version for PHP 7.2
- Fixed `sqlsrv` version for PHP 7.2
- Fixed `swoole` version for PHP 7.1
- Fixed pip installation

#### Changed
- Removed `opcache` for PHP 8.1
- Removed `xlswriter` for PHP 8.1
- Removed `linuxbrew` for all versions
- [#201](https://github.com/devilbox/docker-php-fpm/issues/201) Deactivated `psr` and `phalcon` by default
- Removed `drush9` from PHP 7.0 and 7.1
- Removed `drupalconsole` from PHP 7.0 and 7.1


## Release 0.123

#### Fixed
- Fixex `redis` module compilation for PHP 8.1
- Fixed PHP Xdebug v3 defaults to:
  ```ini
  xdebug.mode               = Off
  xdebug.start_with_request = default
  xdebug.client_port        = 9000
  ```

#### Changed
- Removed `pdo_dblib` from PHP 8.1 due to errors


## Release 0.122

#### Added
- Added `apcu`, `blackfire`, `igbinary`, `imap`, `mcrypt`, `memcache`, `msgpack`, `oauth`, `psr`, `solr`, `xlswriter`, `yaml` to PHP 8.0
- Added `apcu`, `igbinary`, `imap`, `mcrypt`, `memcache`, `msgpack`, `oauth`, `psr`, `solr`, `xlswriter`, `yaml` to PHP 8.1

#### Changed
- Migrate from Travis CI to GitHub Actions


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
