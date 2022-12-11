[PHP Mods: Overview](../../php_modules/README.md) |
PHP Mods: `options.yml` |
[PHP Mods: `install.yml`](PHP-EXT-install.yml.md)

---

<h2><img name="Documentation" title="Documentation" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Contributor Documentation: PHP Modules</h2>



# Extension definition: `options.yml`

These options are purely for the module generator to decide whether or not to build the module, in what order to build it (order of dependencies) and when to enable it for PHP cli and PHP-FPM.


### `name`

* Required: Yes
* Type: `str`

The lower-case name of the extension as it is shown by `php -m` (must match directory name).


### `exclude`

* Required: Yes
* Type: `list[str]`
* Empty: `[]`

Add PHP versions to exclude from building/installing this extension. This could be due to build errors or deprecations.

Example:
```yaml
# Exclude PHP 5.2 and PHP 5.3
exclude: [5.2, 5.3]
```

**Note:** If this extension is already present, do not exclude it in here, but rather use `already_avail` in `install.yml`.


### `depends_build`

* Required: Yes
* Type: `list[str]`
* Empty: `[]`

If this PHP module requires another PHP module to be present prior building, you have to specify them in this list. The module generator will then ensure to build all available modules in order of dependencies.

Example:
```yaml
# Before building the current extension, it will be ensured that
# igbinary and msgpack are build and installed beforehand.
depends_build:
  - igbinary
  - msgpack
```


### `depends_load`

* Required: Yes
* Type: `list[str]`
* Empty: `[]`

If this PHP module requires another PHP module to be loaded beforehand in order to function correctly, you have to specify them in this list. The PHP docker image will then respect the order of loading modules as per specification in here.

Example:
```yaml
# Before loading the current module, ensure to load
# igbinary and msgpack first.
depends_load:
  - igbinary
  - msgpack
```

**Note:** This is the opposite of `loads_before`



### `loads_before`

* Required: No
* Type: `list[str]`
* Empty: `[]`

If this PHP module requires to be loaded before certain other PHP modules, specify them in this list. The PHP docker image will then respect the order of loading modules as per specification in here.

Example:
```yaml
# Before loading igbinary and msgpack, ensure to load
# the current module.
depends_load:
  - igbinary
  - msgpack
```

**Note:** This is the opposite of `depends_load`



### `conflicts_load`

* Required: Yes
* Type: `list[str]`
* Empty: `[]`

Specify any PHP modules that cause the current module to malfunction when loaded.

Example:
```yaml
# Make igbinary and msgpack as incompatible to load with this module.
conflicts_load:
  - igbinary
  - msgpack
```


### `enabled_php_cli`

* Required: Yes
* Type: `bool`

Specify if this module should be loaded and made available to the PHP cli (does not affect PHP-FPM).


### `enabled_php_fpm`

* Required: Yes
* Type: `bool`

Specify if this module should be loaded and made available to the PHP-FPM process (does not affect PHP cli).
