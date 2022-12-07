Build your own image

---

<h2><img name="Documentation" title="Documentation" width="20" src="https://github.com/devilbox/artwork/raw/master/submissions_logo/cytopia/01/png/logo_64_trans.png"> Abuser Documentation</h2>



### Build your own image

#### Software Requirements

You must have the following tools installed locally:
* Python3
* `PyYAML` Python package (either via pip or OS packet manager)
* `make`
* `docker`


#### Other Requirements
You should have a brief understanding about the different flavours available in this repository.

:information_source: For details see **[README.md#flavours](../../README.md#php-fpm-flavours)**<br/>
:information_source: For details see **[Documentation: Flavours](../flavours.md)**


#### How does it work?

This repository already has all the automation in place.

1. For each PHP version a `base` image is built to streamline settings across all PHP versions.
2. Based on the `base` image, a `mods` image is built, which only adds a whole bunch of PHP extensions.
3. Based on the `mods` image, a `prod` image is built, which adds features to alter the startup behaviour.
4. Based on the `prod` image, a `work` image is built, which acts as an integrated development environment in which you can actually work (adds a whole bunch of tools).

What you need to do, is to:

1. Ensure the `base` image is available locally on your system (either by building it or by pulling it).
2. Decide on the PHP extensions that you want to add
3. Decide on the PHP version you want to build
4. Decide on the architecture/platform you want to build the Docker image for (`amd64` or `arm64`).
5. Build the `mods` image (or just create the Dockerfile for it).

With this you will be all set, you can however decide to build the `prod` flavour on top of your custom `mods` image as it adds a lot of configurable environment variables to dynamically alter the startup behaviour.

In case you plan to use your custom image for the **[Devilbox](https://github.com/cytopia/devilbox)**, you must also go ahead and built the `work` flavour on top of the `prod` flavour.


#### Generate your custom Dockerfile

> **Note:** All commands are executed in the root of this repository

1. Generate Dockerfiles with desired PHP extensions
    ```bash
    # Generate Dockerfiles with all available PHP extensions
    make gen-dockerfiles
    ```
    ```bash
    # Generate Dockerfiles for selected PHP extensions only
    # Note: that also all dependent extensions will be added
    make gen-dockerfiles MODS="msgpack xsl"
    ```
    ```bash
    # Generate Dockerfiles for selected PHP extensions
    # and ignore dependencies
    make gen-dockerfiles MODS="-i msgpack xsl"
    ```


#### Build your custom Dockerfile

> **Note:** All commands are executed in the root of this repository

1. Ensure you have the `base` image locally for your desired version and architecture
    ```bash
    ARCH=linux/amd64
    VERSION=8.1
    make docker-pull-base-image STAGE=mods VERSION=${VERSION} ARCH=${ARCH}
    ```
2. Build the `mods` image
    ```bash
    ARCH=linux/amd64
    VERSION=8.1
    make build STAGE=mods VERSION=${VERSION} ARCH=${ARCH}
    ```
3. (Optional) Build the `prod` image
    ```bash
    ARCH=linux/amd64
    VERSION=8.1
    make build STAGE=prod VERSION=${VERSION} ARCH=${ARCH}
    ```
4. (Optional) Build the `work` image
    ```bash
    ARCH=linux/amd64
    VERSION=8.1
    make build STAGE=work VERSION=${VERSION} ARCH=${ARCH}
    ```


#### FAQ

1. Where do I find the generated Dockerfile?
2. How can I omit dependent PHP extensions when generating the Dockerfile?
3. How do I ensure that dependent PHP extensions are automatically added to the Dockerfile?
4. Where do I see what PHP extensions are available in this repository?
5. How do I know what each of the provided PHP extensions is for?
6. How can I add PHP extensions that are not provided here?
7. Switching architectures fails with errors, what should I do?
