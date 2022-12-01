[PHP Mods: Overview](../../php_modules/README.md) |
[PHP Mods: `options.yml`](PHP-EXT-options.yml.md) |
[PHP Mods: `build.yml`](PHP-EXT-build.yml.md) |
PHP Mods: `test.yml`

---

<h2><img name="Documentation" title="Documentation" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Contributor Documentation: PHP Modules</h2>



# Extension definition: `test.yml`

### Goal
The goal of these tests will be to ensure that each compiled module works as expected:
* Required system libraries are present
* Module has been loaded in correct order
* Module works properly

This will be accomplished by providing example PHP code, which makes calls to functions of the respective module. The tests will then check PHP error logs, stderr, unforseen exits and segfaults for potential errors.

Currently some basic tests already exist or a few modules **[here](../../tests/mods/modules)**.


### Configuration

This is not yet implemented and thus no documentation exists.
