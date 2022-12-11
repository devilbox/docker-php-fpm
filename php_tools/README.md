PHP Tools: Overview |
[PHP Tools: `options.yml`](../doc/contributor/PHP-TOOL-options.yml.md) |
[PHP Tools: `install.yml`](../doc/contributor/PHP-TOOL-install.yml.md)

---

<h2><img name="Documentation" title="Documentation" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Contributor Documentation: PHP Tools</h2>



# PHP Tool definitions

This document describes how to create new or alter existing PHP tools.

All PHP tools (for all PHP versions and both for `amd64` and `arm64` platforms) are defined in the `php_tools/` directory in their corresponding sub directory. Tools defined in there will be built for the `work` flavour.

**Directory Structure:**
```bash
php_tools/
└── <php-tool>/
    ├── install.yml
    ├── options.yml
    └── README.md
```


### Requirements

In order to create new or altere existing PHP tools you need to have the following tools installed locally:
* Python3
* Python [`PyYAML`](https://pypi.org/project/PyYAML/) module
* Docker
* The `make` command

Additionally you should have a brief understanding about what flavours exist and how they derive from each other: **[Documentation: Flavours](../doc/flavours.md)**.


## How to add PHP tools?

Simply add your new tool definitions into `php_tools/` as shown in the above directory structure.

You can either look at existing tools to find out what needs to be added to `install.yml` and `options.yml` or you check out the documentation for that:

* See **[PHP-TOOL-install.yml.md](../doc/contributor/PHP-TOOL-install.yml.md)** how to alter the `install.yml` file.
* See **[PHP-TOOL-options.yml.md](../doc/contributor/PHP-TOOL-options.yml.md)** how to alter the `options.yml` file.

Below is a simple example of how the `yq` tool was created:

```bash
# Enter the php_tools directory
cd php_tools/

# Create the yq directory
mkdir yq

# Create necessary empty files
touch yq/install.yml
touch yq/options.yml
```

Now let's edit `options.yml`:
```yaml
---
name: yq       # The name must match the directory name
exclude: []    # Any PHP versions to exclude?

depends: [jq]  # The jq tool must be installed (yq depends on it)
```

Now let's edit the `install.yml`:
```yaml
---
check: yq --version 2>&1 | grep -E '[0-9][.0-9]+' || (yq --version; false)

all:
  type: pip
  version:
  build_dep: []
  run_dep: []
  pre:
  post:
```


## How to generate the Dockerfiles?

Dockerfiles are generated for all PHP versions with a single `make` command. If you do not specify any arguments, then all PHP tools found in the `php_tools/` directory are being added to the Dockerfiles.

You can however also generate Dockerfiles only containing the tool that you have created/altered. This makes the `docker build` process much faster and you can troubleshoot potential errors quicker.

### Generate Dockerfiles for all PHP tools

Inside the root of this git repository execute the following:
```bash
# Generate Dockerfiles with all available PHP tools found in php_tools/ dir
make gen-dockerfiles
```

### Generate Dockerfiles for a single PHP tool

Inside the root of this git repository execute the following:
```bash
# Generate Dockerfiles with only yq tool
make gen-dockerfiles PHP_TOOLS="yq"
```

> **🛈 Note:** This will also add any tools that `yq` depends on (specified via `depends:` in `options.yml`)

You can also exlcude any dependent tools by specifying the `-i` flag.

```bash
# Generate Dockerfiles with only yq tool and no dependent tools
make gen-dockerfiles PHP_TOOLS="-i yq"
```

> **⚠ Warning:** The `-i` option might break your build.

### Generate Dockerfiles for multiple PHP tools

Inside the root of this git repository execute the following:
```bash
# Generate Dockerfiles with only yq and zsh tool
make gen-dockerfiles PHP_TOOLS="yq zsh"
```

> **🛈 Note:** This will also add any tools that `yq` and `zsh` depends on (specified via `depends:` in `options.yml`)

You can also exlcude any dependent tools by specifying the `-i` flag.

```bash
# Generate Dockerfiles with only yq and zsh tool and no dependent tools
make gen-dockerfiles PHP_TOOLS="-i yq zsh"
```


## How to build the Dockerfiles?

Once you have generated the Dockerfiles, pick a PHP version and an architecture (`linux/am64` or `linux/arm64`) and then build it via `make`.

> **🛈 Note 1:** PHP tools are generated into Dockerfiles of the `work` flavour, so you will have to use `STAGE=work` to build this flavour.<br/>
> **🛈 Note 2:** The `work` flavour depends on the `slim` flavour, so you need to ensure to either pull this Docker image or build it yourself.

The following example will show the build for:
* PHP version: `8.1`
* Architecture: `linux/amd64`

### Ensure to have `slim` flavour

Either build it yourself for the specific PHP version and architecture.
```bash
make build STAGE=slim VERSION=8.1 ARCH=linux/amd64
```
Or pull it from Dockerhub
```
make docker-pull-base-image STAGE=work VERSION=8.1 ARCH=linux/amd64
```

### Build the `work` flavour

This flavour will include the PHP tools you have generated above.
```bash
make build STAGE=work VERSION=8.1 ARCH=linux/amd64
```
