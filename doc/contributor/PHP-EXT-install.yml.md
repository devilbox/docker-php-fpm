[PHP Mods: Overview](../../php_modules/README.md) |
[PHP Mods: `options.yml`](PHP-EXT-options.yml.md) |
PHP Mods: `install.yml`

---

<h2><img name="Documentation" title="Documentation" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Contributor Documentation: PHP Modules</h2>



# Extension definition: `install.yml`


## Top level defines

| Yaml key        | Description |
|-----------------|-------------|
| `already_avail` | Array of PHP versions for which we don't have to install the module as it is already present via its FROM image. |
| `all`           | Is generic for all PHP versions and will be used whenever no specific version is defined. |
| `7.2`           | A version specific block for PHP 7.2. Its child keys will overwrite what has been defined in `all`. |

**Example:** Using `already_avail`
```yaml
# "{{ php_all_versions }}" Jinja2 variable is available and
# translates to an array of all available PHP versions.
already_avail: "{{ php_all_versions }}"
```

**Example:** Overwriting `git_ref` for a specific version
```yaml
already_avail: [5.2]

all:
  type: git
  git_url: https://github.com/phalcon/cphalcon
  git_ref: master

# PHP 8.1 is using a different git_ref
8.1:
  type: git
  git_ref: v1.0.0

# PHP 8.0 is using a different git_ref dynamically with latest tag found
# See the usage of supported shell code
8.0:
  type: git
  git_ref: $( git tag | sort -V | tail -1 )
```


## Second level defines

The following keys can be added below: `all`, `8.2`, `8.1`, `8.0`, `7.4`, ...

| Yaml key    | Required | Supports<br/>Shell code | Description |
|-------------|----------|-------------------------|-------------|
| `pre`       | No       | Yes | Specify a shell command to be run before module installation. |
| `post`      | No       | Yes | Specify a shell command to be run after module installation. |
| `build_dep` | No       | No  | Array Debian packages required to build the module (they won't be present in the final image - only used to built the module) If you don't need any, assign it an empty array: `build_dep: []`. |
| `run_dep`   | No       | No  | Array Debian packages required for the module run-time (they won't be present during the build stage - only in the final image). If you don't need any, assign it an empty array: `run_dep: []`. |
| `type`      | **Yes**  | No  | On of the following types to build the module: `builtin`, `pecl`, `git` or `custom`. |

**Example:**
```yaml
all:
  type: builtin
  pre: |
    ARCH="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE))" \
  post: |
    rm -f /tmp/file.txt \
  build_dep: [libmcrypt-dev]
  run_dep: [libmcrypt4]

8.1:
  type: builtin
  build_dep: []
  run_dep: []
```


## Second level defines for `type: builtin`

| Yaml key    | Required | Supports<br/>Shell code | Description |
|-------------|----------|-------------------------|-------------|
| `configure` | No       | Yes                     | Add `./configure` arguments. E.g.:<br/> `configure: --with-jpeg --with-png` |

**Example:**
```yaml
all:
  type: builtin

8.1:
  type: builtin
  configure: --with-jpeg --with-png

8.0:
  type: builtin
  configure: --with-jpeg
```


## Second level defines for `type: pecl`

| Yaml key    | Required | Supports<br/>Shell code | Description |
|-------------|----------|-------------------------|-------------|
| `version`   | No       | Yes                     | Pecl packet version |
| `command`   | No       | Yes                     | Overwrite pecl command (default: `pecl install <ext>`) |

**Example:**
```yaml
all:
  type: pecl
  command: echo "/usr" | pecl install amqp
  build_dep: [librabbitmq-dev]
  run_dep: [librabbitmq4]

5.5:
  type: pecl
  version: 1.9.3
  run_dep: [librabbitmq1]
```


## Second level defines for `type: git`

| Yaml key    | Required | Supports<br/>Shell code | Description |
|-------------|----------|-------------------------|-------------|
| `git_url`   | **Yes**  | Yes                     | Git repository URL |
| `git_ref`   | No       | Yes                     | Tag, branch, commit to check out (shell code supported to dynamically checkout) |
| `configure` | No       | Yes                     | Add `./configure` arguments. |
| `command`   | No       | Yes                     | Overwrite default command (default: `phpize && ./configure && make && make install`) |

**Example:**
```yaml
already_avail: [5.2]

# Default for all PHP versions if no overwrite exists
all:
  type: git
  git_url: https://github.com/phalcon/cphalcon
  git_ref: master

# PHP 8.1 is overwriting the git_ref
8.1:
  type: git
  git_ref: v1.0.0

# PHP 8.0 is using a different git_ref dynamically with latest tag found
# See the usage of supported shell code
8.0:
  type: git
  git_ref: $( git tag | sort -V | tail -1 )
```


## Second level defines for `type: custom`

| Yaml key    | Required | Supports<br/>Shell code | Description |
|-------------|----------|-------------------------|-------------|
| `command`   | **Yes**  | Yes                     | Custom command to install and enable a module |

**Example:**
```yaml
all:
  type: custom
  command: |
    wget http://url/file.tar.gz \
	&& tar xvfz file.tar.gz \
	&& cd file \
	&& phpize \
	&& ./configure \
	&& make \
	&& make install \
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
