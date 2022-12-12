[PHP Tools: Overview](../../php_tools/README.md) |
PHP Tools: `options.yml` |
[PHP Tools: `install.yml`](../doc/contributor/PHP-TOOL-install.yml.md)

---

<h2><img name="Documentation" title="Documentation" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Contributor Documentation: PHP Tools</h2>



# Tool definition: `options.yml`

These options are purely for the tool generator to decide whether or not to build the tool and in what order to build it (order of dependencies).


### `name`

* Required: Yes
* Type: `str`

The lower-case name of the tool (must match directory name).


### `exclude`

* Required: Yes
* Type: `list[str]`
* Empty: `[]`

Add PHP versions to exclude from building/installing this tool. This could be due to build errors or deprecations.

Example:
```yaml
# Exclude PHP 5.2 and PHP 5.3
exclude: [5.2, 5.3]
```


### `depends`

* Required: Yes
* Type: `list[str]`
* Empty: `[]`

If this tool requires another tool to be present prior building/installing (or just to function properly during run-time), you have to specify them in this list. The tool generator will then ensure to build all available tools in order of dependencies.

Example:
```yaml
# Before installing the current tool, it will be ensured that
# jq is build and installed beforehand.
depends_build:
  - jq
```
