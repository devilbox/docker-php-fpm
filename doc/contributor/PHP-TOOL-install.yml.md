[PHP Tools: Overview](../../php_tools/README.md) |
[PHP Tools: `options.yml`](PHP-TOOL-options.yml.md) |
PHP Tools: `install.yml`

---

<h2><img name="Documentation" title="Documentation" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Contributor Documentation: PHP Tools</h2>



# Tool definition: `install.yml`


## Top level defines

| Yaml key        | Description |
|-----------------|-------------|
| `check`         | A check command to test that the tool has been installed correctly. |
| `all`           | Is generic for all PHP versions and will be used whenever no specific version is defined. |
| `7.2`           | A version specific block for PHP 7.2. Its child keys will overwrite what has been defined in `all`. |
**Example:**
```yaml
check: yq --version 2>&1 | grep -E '[0-9][.0-9]+' || (yq --version; false)

# Default for all PHP version if no overwrite exists
all:
  type: pip
  version:
  build_dep: []
  run_dep: []
  pre:
  post:


# PHP 5.2 is overwriting the version of yq to install
5.2:
  type: pip
  version: 0.1.0
```


## Second level defines

The following keys can be added below: `all`, `8.2`, `8.1`, `8.0`, `7.4`, ...

| Yaml key    | Required | Supports<br/>Shell code | Description |
|-------------|----------|-------------------------|-------------|
| `pre`       | No       | Yes | Specify a shell command to be run before module installation. |
| `post`      | No       | Yes | Specify a shell command to be run after module installation. |
| `build_dep` | No       | No  | Array Debian packages required to build the module (they won't be present in the final image - only used to built the module) If you don't need any, assign it an empty array: `build_dep: []`. |
| `run_dep`   | No       | No  | Array Debian packages required for the module run-time (they won't be present during the build stage - only in the final image). If you don't need any, assign it an empty array: `run_dep: []`. |
| `type`      | **Yes**  | No  | On of the following types to build the module: `apt`, `composer`, `npm`, `pip`, `rubygem` or `custom`. |

**Note:** When using `type: custom`, all data needs to be installed into `/usr/local/bin` as only this directory is copied into the next docker stage during multi-stage build.


## Second level defines for `type: apt`

| Yaml key    | Required | Supports<br/>Shell code | Description |
|-------------|----------|-------------------------|-------------|
| `package`   | Yes      | No                      | Specify the Debian apt package to install |

**Example:**
```yaml
all:
  type: apt
  package: netcat

5.3:
  type: apt
  package: netcat.traditional
```


## Second level defines for `type: composer`

| Yaml key    | Required | Supports<br/>Shell code | Description |
|-------------|----------|-------------------------|-------------|
| `package`   | Yes      | No                      | Specify the Composer package name to install |
| `composer`  | Yes      | No                      | Specify the composer version to use for installation: `1` or `2` |
| `version`   | No       | Yes                     | Specify the Composer package version to install |
| `binary`    | No       | Yes                     | Specify the composer relative binary path to symlink to `/usr/loca/bin/` |
| `flags`     | No       | Yes                     | Add composer flags to `composer require` |

**Example:**
```yaml
all:
  type: composer
  composer: 2
  package: laravel/installer
  binary: bin/laravel

7.1:
  type: composer
  version: 2.3.0
  binary: laravel
```


## Second level defines for `type: npm`

| Yaml key    | Required | Supports<br/>Shell code | Description |
|-------------|----------|-------------------------|-------------|
| `package`   | Yes      | No                      | Specify the NPM package name to install |
| `version`   | No       | Yes                     | Specify the NPM package version to install |
| `binary`    | No       | Yes                     | Specify the NPM relative binary path to symlink to `/usr/loca/bin/` |

**Example:**
```yaml
all:
  type: npm
  package: pm2
  binary: pm2
  version:
```


## Second level defines for `type: pip`

| Yaml key    | Required | Supports<br/>Shell code | Description |
|-------------|----------|-------------------------|-------------|
| `version`   | No       | Yes                     | Specify the Pip package version to install |

The PyPI package name defaults to the name specified in `options.yml`.

**Example:**
```yaml
all:
  type: pip
  version:
  build_dep: []
  run_dep: []
  pre:
  post: |
    ln -s pwncat /usr/local/bin/netcat \
```


## Second level defines for `type: rubygem`

| Yaml key    | Required | Supports<br/>Shell code | Description |
|-------------|----------|-------------------------|-------------|
| `package`   | Yes      | No                      | Specify the Rubygem package name to install |
| `version`   | No       | Yes                     | Specify the Rubygem package version to install |

**Example:**
```yaml
all:
  type: rubygem
  package: mdl
  build_dep: [ruby-dev]
  run_dep: [ruby]

7.2:
  type: rubygem
  version: 0.11.0
  pre: |
    gem install chef-utils -v 16.6.14 \
```


## Second level defines for `type: custom`

| Yaml key    | Required | Supports<br/>Shell code | Description |
|-------------|----------|-------------------------|-------------|
| `command`   | Yes      | Yes                     | Custom command to install a tool. |

**Note:** When using `type: custom`, all data needs to be installed into `/usr/local/bin` as only this directory is copied into the next docker stage during multi-stage build.

**Example:**
```yaml
all:
  type: custom
  command: curl -sS -k -L --fail -L "${PHP_CS_FIXER_URL}" -o /usr/local/bin/php-cs-fixer
  pre: PHP_CS_FIXER_URL="https://cs.symfony.com/download/php-cs-fixer-v3.phar"
  post: chmod +x /usr/local/bin/php-cs-fixer

7.3:
  type: custom
  pre: PHP_CS_FIXER_URL="https://cs.symfony.com/download/php-cs-fixer-v2.phar"
```


## Usage of shell code

### Single-line vs Multi-line

**Note:** All keys that support shell code can be written as a single line yaml definition or as a multi line yaml definition. Multi-line yaml definitions need a trailing `\` at the end of each line, including the last line.<br/>
**Single-line:**
```yaml
all:
  pre: VERSION="$( curl http://url | grep -Eo '[0-9.]+' )"
```
**Multi-line:**
```yaml
all:
  pre: |
    VERSION="$( \
      curl http://url \
      | grep -Eo '[0-9.]+' \
    )" \
```

### Single-command vs Multi-command

**Note:** All keys that support shell code also support to write multiple shell commands. If you use multiple shell commands, you need to separate them with `&&`.<br/>
**Single-command:**
```yaml
all:
  pre: |
    VERSION="$( \
      curl http://url \
      | grep -Eo '[0-9.]+' \
    )" \
```
**Multi-command:**
```yaml
all:
  pre: |
    URL="http://url" \
    && VERSION="$( \
      curl "${URL} \
      | grep -Eo '[0-9.]+' \
    )" \
    && echo "${VERSION}" \

```
