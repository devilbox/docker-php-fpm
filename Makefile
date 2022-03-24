ifneq (,)
.error This Makefile requires GNU Make.
endif

# Ensure additional Makefiles are present
MAKEFILES = Makefile.docker Makefile.lint
$(MAKEFILES): URL=https://raw.githubusercontent.com/devilbox/makefiles/master/$(@)
$(MAKEFILES):
	@if ! (curl --fail -sS -o $(@) $(URL) || wget -O $(@) $(URL)); then \
		echo "Error, curl or wget required."; \
		echo "Exiting."; \
		false; \
	fi
include $(MAKEFILES)

# Set default Target
.DEFAULT_GOAL := help


# -------------------------------------------------------------------------------------------------
# Default configuration
# -------------------------------------------------------------------------------------------------
# Own vars
TAG        = latest

# Makefile.docker overwrites
NAME       = PHP
#VERSION    = 5.5
IMAGE      = devilbox/php-fpm
#FLAVOUR    = base
FILE       = Dockerfile-$(VERSION)
DIR        = Dockerfiles/$(FLAVOUR)

ifeq ($(strip $(TAG)),latest)
DOCKER_TAG = $(VERSION)-$(FLAVOUR)
BASE_TAG   = $(VERSION)-base
MODS_TAG   = $(VERSION)-mods
PROD_TAG   = $(VERSION)-prod
WORK_TAG   = $(VERSION)-work
else
DOCKER_TAG = $(VERSION)-$(FLAVOUR)-$(TAG)
BASE_TAG   = $(VERSION)-base-$(TAG)
MODS_TAG   = $(VERSION)-mods-$(TAG)
PROD_TAG   = $(VERSION)-prod-$(TAG)
WORK_TAG   = $(VERSION)-work-$(TAG)
endif
ARCH       = linux/amd64


# Makefile.lint overwrites
FL_IGNORES  = .git/,.github/,tests/
SC_IGNORES  = .git/,.github/,tests/


# -------------------------------------------------------------------------------------------------
# Default Target
# -------------------------------------------------------------------------------------------------
.PHONY: help
help:
	@echo "lint                                     Lint project files and repository"
	@echo
	@echo "build [ARCH=...] [TAG=...]               Build Docker image"
	@echo "rebuild [ARCH=...] [TAG=...]             Build Docker image without cache"
	@echo "push [ARCH=...] [TAG=...]                Push Docker image to Docker hub"
	@echo
	@echo "manifest-create [ARCHES=...] [TAG=...]   Create multi-arch manifest"
	@echo "manifest-push [TAG=...]                  Push multi-arch manifest"
	@echo
	@echo "test [ARCH=...]                          Test built Docker image"
	@echo


# -------------------------------------------------------------------------------------------------
# Overwrite Targets
# -------------------------------------------------------------------------------------------------

# Append additional target to lint
lint: lint-changelog
lint: lint-ansible

###
### Ensures CHANGELOG has an entry
###
.PHONY: lint-changelog
lint-changelog:
	@echo "################################################################################"
	@echo "# Lint Changelog"
	@echo "################################################################################"
	@\
	GIT_CURR_MAJOR="$$( git tag | sort -V | tail -1 | sed 's|\.[0-9]*$$||g' )"; \
	GIT_CURR_MINOR="$$( git tag | sort -V | tail -1 | sed 's|^[0-9]*\.||g' )"; \
	GIT_NEXT_TAG="$${GIT_CURR_MAJOR}.$$(( GIT_CURR_MINOR + 1 ))"; \
	if ! grep -E "^## Release $${GIT_NEXT_TAG}$$" CHANGELOG.md >/dev/null; then \
		echo "[ERR] Missing '## Release $${GIT_NEXT_TAG}' section in CHANGELOG.md"; \
		exit 1; \
	else \
		echo "[OK] Section '## Release $${GIT_NEXT_TAG}' present in CHANGELOG.md"; \
	fi
	@echo

###
### Ensures Ansible Dockerfile generation is current
###
.PHONY: lint-ansible
lint-ansible: gen-dockerfiles
	@git diff --quiet || { echo "Build Changes"; git diff; git status; false; }


# -------------------------------------------------------------------------------------------------
# Docker Targets
# -------------------------------------------------------------------------------------------------

# ---- ONLY FOR "mods" images ----
# When builds mods, we have a builder image and then copy everything to the final
# target image. In order to do so, we pass a build-arg EXT_DIR, which contains
# the variable directory of extensions to copy.
# The only way to "LAZY" fetch it, is by doing a call to the base image and populate
# a Makefile variable with its value upon call.
ifeq ($(strip $(FLAVOUR)),mods)
EXT_DIR=$$( docker run --rm --platform $(ARCH) --entrypoint=php $(IMAGE):$(BASE_TAG) -r \
	'echo ini_get("extension_dir");'\
)
endif

.PHONY: build
build: check-flavour-is-set
build: check-parent-image-exists
build: ARGS+=--build-arg EXT_DIR=$(EXT_DIR)
build: docker-arch-build

.PHONY: rebuild
rebuild: check-flavour-is-set
rebuild: check-parent-image-exists
rebuild: ARGS+=--build-arg EXT_DIR=$(EXT_DIR)
rebuild: docker-arch-rebuild

.PHONY: push
push: docker-arch-push


# -------------------------------------------------------------------------------------------------
# Save / Load Targets
# -------------------------------------------------------------------------------------------------
.PHONY: save
docker-save: check-flavour-is-set
docker-save: check-version-is-set
docker-save: check-current-image-exists

.PHONY: load
docker-load: check-flavour-is-set
docker-load: check-version-is-set
docker-load: check-current-image-exists


# -------------------------------------------------------------------------------------------------
# Manifest Targets
# -------------------------------------------------------------------------------------------------
.PHONY: manifest-create
manifest-create: docker-manifest-create

.PHONY: manifest-push
manifest-push: docker-manifest-push


# -------------------------------------------------------------------------------------------------
# Test Targets
# -------------------------------------------------------------------------------------------------
.PHONY: test
test: check-flavour-is-set
test: check-current-image-exists
test: test-integration

.PHONY: test-integration
test-integration:
	./tests/test.sh $(IMAGE) $(ARCH) $(VERSION) $(FLAVOUR)


# -------------------------------------------------------------------------------------------------
# Generate Targets
# -------------------------------------------------------------------------------------------------

###
### Generate README (requires images to be built)
###
.PHONY: gen-readme
gen-readme: check-version-is-set
gen-readme:
	@echo "################################################################################"
	@echo "# Generate README.md for PHP $(VERSION) ($(IMAGE):$(DOCKER_TAG)) on $(ARCH)"
	@echo "################################################################################"
	./build/gen-readme.sh $(IMAGE) $(ARCH) $(BASE_TAG) $(MODS_TAG) $(VERSION)
	git diff --quiet || { echo "Build Changes"; git diff; git status; false; }

###
### Generate Dockerfiles
###
.PHONY: gen-dockerfiles
gen-dockerfiles:
	docker run --rm \
		$$(tty -s && echo "-it" || echo) \
		-e USER=ansible \
		-e MY_UID=$$(id -u) \
		-e MY_GID=$$(id -g) \
		-v ${PWD}:/data \
		-w /data/build/ansible \
		cytopia/ansible:2.8-tools ansible-playbook generate.yml \
			-e ANSIBLE_STRATEGY_PLUGINS=/usr/lib/python3.8/site-packages/ansible_mitogen/plugins/strategy \
			-e ANSIBLE_STRATEGY=mitogen_linear \
			-e ansible_python_interpreter=/usr/bin/python3 \
			-e \"{build_fail_fast: $(FAIL_FAST)}\" \
			--diff $(ARGS)



# -------------------------------------------------------------------------------------------------
# HELPER TARGETS
# -------------------------------------------------------------------------------------------------

###
### Ensures the VERSION variable is set
###
.PHONY: check-version-is-set
check-version-is-set:
	@if [ "$(VERSION)" = "" ]; then \
		echo "This make target requires the VERSION variable to be set."; \
		echo "make <target> VERSION="; \
		echo "Exiting."; \
		exit 1; \
	fi

###
### Ensures the FLAVOUR variable is set
###
.PHONY: check-flavour-is-set
check-flavour-is-set:
	@if [ "$(FLAVOUR)" = "" ]; then \
		echo "This make target requires the FLAVOUR variable to be set."; \
		echo "make <target> FLAVOUR="; \
		echo "Exiting."; \
		exit 1; \
	fi
	@if [ "$(FLAVOUR)" != "base" ] && [ "$(FLAVOUR)" != "mods" ] && [ "$(FLAVOUR)" != "prod" ] && [ "$(FLAVOUR)" != "work" ]; then \
		echo "Error, Flavour can only be one of 'base', 'mods', 'prod', or 'work'."; \
		echo "Exiting."; \
		exit 1; \
	fi

###
### Checks if current image exists and is of correct architecture
###
.PHONY: check-current-image-exists
check-current-image-exists: check-flavour-is-set
check-current-image-exists:
	@if [ "$$( docker images -q $(IMAGE):$(DOCKER_TAG) )" = "" ]; then \
		>&2 echo "Docker image '$(IMAGE):$(DOCKER_TAG)' was not found locally."; \
		>&2 echo "Either build it first or explicitly pull it from Dockerhub."; \
		>&2 echo "This is a safeguard to not automatically pull the Docker image."; \
		>&2 echo; \
		exit 1; \
	else \
		echo "OK: Image $(IMAGE):$(DOCKER_TAG) exists"; \
	fi; \
	OS="$$( docker image inspect $(IMAGE):$(DOCKER_TAG) --format '{{.Os}}' )"; \
	ARCH="$$( docker image inspect $(IMAGE):$(DOCKER_TAG) --format '{{.Architecture}}' )"; \
	if [ "$${OS}/$${ARCH}" != "$(ARCH)" ]; then \
		>&2 echo "Docker image '$(IMAGE):$(DOCKER_TAG)' has invalid architecture: $${OS}/$${ARCH}"; \
		>&2 echo "Expected: $(ARCH)"; \
		>&2 echo; \
		exit 1; \
	else \
		echo "OK: Image $(IMAGE):$(DOCKER_TAG) is of arch $${OS}/$${ARCH}"; \
	fi

###
### Checks if parent image exists and is of correct architecture
###
.PHONY: check-parent-image-exists
check-parent-image-exists: check-flavour-is-set
check-parent-image-exists:
	@if [ "$(FLAVOUR)" = "work" ]; then \
		if [ "$$( docker images -q $(IMAGE):$(PROD_TAG) )" = "" ]; then \
			>&2 echo "Docker image '$(IMAGE):$(PROD_TAG)' was not found locally."; \
			>&2 echo "Either build it first or explicitly pull it from Dockerhub."; \
			>&2 echo "This is a safeguard to not automatically pull the Docker image."; \
			>&2 echo; \
			exit 1; \
		fi; \
		OS="$$( docker image inspect $(IMAGE):$(PROD_TAG) --format '{{.Os}}' )"; \
		ARCH="$$( docker image inspect $(IMAGE):$(PROD_TAG) --format '{{.Architecture}}' )"; \
		if [ "$${OS}/$${ARCH}" != "$(ARCH)" ]; then \
			>&2 echo "Docker image '$(IMAGE):$(PROD_TAG)' has invalid architecture: $${OS}/$${ARCH}"; \
			>&2 echo "Expected: $(ARCH)"; \
			>&2 echo; \
			exit 1; \
		fi; \
	elif [ "$(FLAVOUR)" = "prod" ]; then \
		if [ "$$( docker images -q $(IMAGE):$(MODS_TAG) )" = "" ]; then \
			>&2 echo "Docker image '$(IMAGE):$(MODS_TAG)' was not found locally."; \
			>&2 echo "Either build it first or explicitly pull it from Dockerhub."; \
			>&2 echo "This is a safeguard to not automatically pull the Docker image."; \
			>&2 echo; \
			exit 1; \
		fi; \
		OS="$$( docker image inspect $(IMAGE):$(MODS_TAG) --format '{{.Os}}' )"; \
		ARCH="$$( docker image inspect $(IMAGE):$(MODS_TAG) --format '{{.Architecture}}' )"; \
		if [ "$${OS}/$${ARCH}" != "$(ARCH)" ]; then \
			>&2 echo "Docker image '$(IMAGE):$(MODS_TAG)' has invalid architecture: $${OS}/$${ARCH}"; \
			>&2 echo "Expected: $(ARCH)"; \
			>&2 echo; \
			exit 1; \
		fi; \
	elif [ "$(FLAVOUR)" = "mods" ]; then \
		if [ "$$( docker images -q $(IMAGE):$(BASE_TAG) )" = "" ]; then \
			>&2 echo "Docker image '$(IMAGE):$(BASE_TAG)' was not found locally."; \
			>&2 echo "Either build it first or explicitly pull it from Dockerhub."; \
			>&2 echo "This is a safeguard to not automatically pull the Docker image."; \
			>&2 echo; \
			exit 1; \
		fi; \
		OS="$$( docker image inspect $(IMAGE):$(BASE_TAG) --format '{{.Os}}' )"; \
		ARCH="$$( docker image inspect $(IMAGE):$(BASE_TAG) --format '{{.Architecture}}' )"; \
		if [ "$${OS}/$${ARCH}" != "$(ARCH)" ]; then \
			>&2 echo "Docker image '$(IMAGE):$(BASE_TAG)' has invalid architecture: $${OS}/$${ARCH}"; \
			>&2 echo "Expected: $(ARCH)"; \
			>&2 echo; \
			exit 1; \
		fi; \
	fi;
