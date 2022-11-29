# PHP Module definitions

This document describes how to create new or alter existing PHP module definitions.

All PHP modules/extensions (for all PHP versions and both for `amd64` and `arm64` platforms) are defined in the `php_modules/` directory in their corresponding sub directory. These definitions are then transformed to Ansible group_vars and afterwards Ansible will generate the corresponding Dockerfiles (Stage: `mods`).


## How to add PHP modules?

1. **Inside `php_modules/` directory:**
    1. Create a new directory with the name of the PHP module in `php_modules/`
    2. Add `build.yml`, `options.yml` and `test.yml` into your newly created directory
    3. Alter `build.yml`, `options.yml` and `test.yml` according to documentation below

2. **Inside the root of this git repository:**
    1. Run `make gen-modules` to create Ansible group_vars
    2. Run `make gen-dockerfiles` to generate Dockerfiles via Ansible
    3. Run `make build STAGE=mods VERSION=8.1 ARCH=linux/amd64` to build the `mods` Docker image with version `8.1` for platform `linux/amd64`

**Note:** If you want to test if your new module builds correctly, you can generate Dockerfiles which only contain this one module and all others removed. This allows for much faster Docker builds and you don't have to wait for all other modules to be built. To do so, you generate group_vars for your one module only via:

```bash
# Commands shown here are executed from root of this repository

# Only generate group_vars for curl
# Note: if curl has other modules as requirements to be built beforehand, those will also be added
python3 ./bin/module-generate.py curl
make gen-dockerfiles
```


## Extension definition: `build.yml`

See **[PHP-EXT-build.yml.md](../doc/PHP-EXT-build.yml.md)** how to alter the `build.yml` file.


## Extension definition: `options.yml`

See **[PHP-EXT-options.yml.md](../doc/PHP-EXT-options.yml.md)** how to alter the `options.yml` file.


## Extension definition: `test.yml`

See **[PHP-EXT-test.yml.md](../doc/PHP-EXT-test.yml.md)** how to alter the `test.yml` file.