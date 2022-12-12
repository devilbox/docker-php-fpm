PHP Mods: Overview |
[PHP Mods: `options.yml`](../doc/contributor/PHP-EXT-options.yml.md) |
[PHP Mods: `install.yml`](../doc/contributor/PHP-EXT-install.yml.md)

---

<h2><img name="Documentation" title="Documentation" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Contributor Documentation: PHP Modules</h2>



## PHP Module definitions

This document describes how to create new or alter existing PHP modules.

All PHP modules (for all PHP versions and both for `amd64` and `arm64` platforms) are defined in the `php_modules/` directory in their corresponding sub directory. Modules defined in there will be built for the `mods` flavour.

**Directory Structure:**
```bash
php_modules/
└── <php-mod>/
    ├── install.yml
    ├── options.yml
    └── README.md
```


### Requirements

In order to create new or altere existing PHP modules you need to have the following tools installed locally:
* Python3
* Python [`PyYAML`](https://pypi.org/project/PyYAML/) module
* Docker
* The `make` command

Additionally you should have a brief understanding about what flavours exist and how they derive from each other: **[Documentation: Flavours](../doc/flavours.md)**.


## How to add PHP modules?

Simply add your new module definitions into `php_modules/` as shown in the above directory structure.

You can either look at existing modules to find out what needs to be added to `install.yml` and `options.yml` or you check out the documentation for that:

* See **[PHP-EXT-install.yml.md](../doc/contributor/PHP-EXT-install.yml.md)** how to alter the `install.yml` file.
* See **[PHP-EXT-options.yml.md](../doc/contributor/PHP-EXT-options.yml.md)** how to alter the `options.yml` file.

Below is a simple example of how the `xls` module was created:

```bash
# Enter the php_modules directory
cd php_modules/

# Create the xls directory
mkdir xls

# Create necessary empty files
touch xls/install.yml
touch xls/options.yml
```

Now let's edit `options.yml`:
```yaml
---
name: xls    # The name must match the directory name
exclude: []  # Any PHP versions to exclude?

depends_build: [libxml]  # The libxml module must be built before xls
```

Now let's edit the `install.yml`:
```yaml
---
all:
  type: builtin
  build_dep: [libxslt-dev]  # This Debian package is required to build xls
  run_rep: [libxslt1.1]     # This Debian package is required during run-time
```


## How to generate the Dockerfiles?

Dockerfiles are generated for all PHP versions with a single `make` command. If you do not specify any arguments, then all PHP modules found in the `php_modules/` directory are being added to the Dockerfiles.

You can however also generate Dockerfiles only containing the module that you have created/altered. This makes the `docker build` process much faster and you can troubleshoot potential errors quicker.

### Generate Dockerfiles for all PHP modules

Inside the root of this git repository execute the following:
```bash
# Generate Dockerfiles with all available PHP modules found in php_modules/ dir
make gen-dockerfiles
```

### Generate Dockerfiles for a single PHP module

Inside the root of this git repository execute the following:
```bash
# Generate Dockerfiles with only xls module
make gen-dockerfiles PHP_MODS="xls"
```

> **🛈 Note:** This will also add any modules that `xls` depends on (specified via `depends_build:` in `options.yml`)

You can also exlcude any dependent modules by specifying the `-i` flag.

```bash
# Generate Dockerfiles with only xls module and no dependent modules
make gen-dockerfiles PHP_MODS="-i xls"
```

> **⚠ Warning:** The `-i` option might break your build.

### Generate Dockerfiles for multiple PHP modules

Inside the root of this git repository execute the following:
```bash
# Generate Dockerfiles with only xls and xmlwriter module
make gen-dockerfiles PHP_MODS="xls xmlwriter"
```

> **🛈 Note:** This will also add any modules that `xls` and `xmlwriter` depends on (specified via `depends_build:` in `options.yml`)

You can also exlcude any dependent modules by specifying the `-i` flag.

```bash
# Generate Dockerfiles with only xls and xmlwriter module and no dependent modules
make gen-dockerfiles PHP_MODS="-i xls xmlwriter"
```


## How to build the Dockerfiles?

Once you have generated the Dockerfiles, pick a PHP version and an architecture (`linux/am64` or `linux/arm64`) and then build it via `make`.

> **🛈 Note 1:** PHP modules are generated into Dockerfiles of the `mods` flavour, so you will have to use `STAGE=mods` to build this flavour.<br/>
> **🛈 Note 2:** The `mods` flavour depends on the `base` flavour, so you need to ensure to either pull this Docker image or build it yourself.

The following example will show the build for:
* PHP version: `8.1`
* Architecture: `linux/amd64`

### Ensure to have `base` flavour

Either build it yourself for the specific PHP version and architecture.
```bash
make build STAGE=base VERSION=8.1 ARCH=linux/amd64
```
Or pull it from Dockerhub
```
make docker-pull-base-image STAGE=mods VERSION=8.1 ARCH=linux/amd64
```

### Build the `mods` flavour

This flavour will include the PHP modules you have generated above.
```bash
make build STAGE=mods VERSION=8.1 ARCH=linux/amd64
```
