ifneq (,)
.error This Makefile requires GNU Make.
endif


# -------------------------------------------------------------------------------------------------
# Docker configuration
# -------------------------------------------------------------------------------------------------

DIR = Dockerfiles/
IMAGE = devilbox/php-fpm
NO_CACHE =


# -------------------------------------------------------------------------------------------------
#  DEFAULT TARGET
# -------------------------------------------------------------------------------------------------

help:
	@echo "################################################################################"
	@echo "# devilbox/php:XX-XX Makefile"
	@echo "################################################################################"
	@echo
	@echo "gen-readme [VERSION=]  Update README.md with PHP modules from built images."
	@echo "gen-dockerfiles        Generate Dockerfiles from templates."
	@echo
	@echo "build-base VERSION=    Build base image by specified version".
	@echo "build-mods VERSION=    Build mods image by specified version".
	@echo "build-prod VERSION=    Build prod image by specified version".
	@echo "build-work VERSION=    Build work image by specified version".
	@echo
	@echo "rebuild-base VERSION=  Rebuild base image by specified version".
	@echo "rebuild-mods VERSION=  Rebuild mods image by specified version".
	@echo "rebuild-prod VERSION=  Rebuild prod image by specified version".
	@echo "rebuild-work VERSION=  Rebuild work image by specified version".
	@echo
	@echo "test-base VERSION=     Test base image by specified version".
	@echo "test-mods VERSION=     Test mods image by specified version".
	@echo "test-prod VERSION=     Test prod image by specified version".
	@echo "test-work VERSION=     Test work image by specified version".


# -------------------------------------------------------------------------------------------------
#  GENERATE TARGETS
# -------------------------------------------------------------------------------------------------

gen-readme:
ifeq ($(strip $(VERSION)),)
	cd build; ./gen-readme.sh
else
	@$(MAKE) --no-print-directory _check-version
	@$(MAKE) --no-print-directory _check-image-exists _EXIST_IMAGE=base
	@$(MAKE) --no-print-directory _check-image-exists _EXIST_IMAGE=mods
	cd build; ./gen-readme.sh ${VERSION}
endif


gen-dockerfiles:
	docker run --rm \
		$$(tty -s && echo "-it" || echo) \
		-e USER=ansible \
		-e MY_UID=$$(id -u) \
		-e MY_GID=$$(id -g) \
		-v ${PWD}:/data \
		-w /data/build/ansible \
		cytopia/ansible:2.8 ansible-playbook generate.yml --diff


# -------------------------------------------------------------------------------------------------
#  BUILD TARGETS
# -------------------------------------------------------------------------------------------------

build-base: _check-version
build-base:
	docker build $(NO_CACHE) -t $(IMAGE):${VERSION}-base -f $(DIR)/base/Dockerfile-${VERSION} $(DIR)/base


build-mods: _check-version
build-mods: _EXIST_IMAGE=base
build-mods: _check-image-exists
build-mods:
	docker build $(NO_CACHE) -t $(IMAGE):${VERSION}-mods -f $(DIR)/mods/Dockerfile-${VERSION} $(DIR)/mods


build-prod: _check-version
build-prod: _EXIST_IMAGE=mods
build-prod: _check-image-exists
build-prod:
	docker build $(NO_CACHE) -t $(IMAGE):${VERSION}-prod -f $(DIR)/prod/Dockerfile-${VERSION} $(DIR)/prod


build-work: _check-version
build-work: _EXIST_IMAGE=prod
build-work: _check-image-exists
build-work:
	docker build $(NO_CACHE) -t $(IMAGE):${VERSION}-work -f $(DIR)/work/Dockerfile-${VERSION} $(DIR)/work


# -------------------------------------------------------------------------------------------------
#  REBUILD TARGETS
# -------------------------------------------------------------------------------------------------

rebuild-base: _check-version
rebuild-base: _pull-root-image
rebuild-base: NO_CACHE=--no-cache
rebuild-base: build-base


rebuild-mods: NO_CACHE=--no-cache
rebuild-mods: build-mods


rebuild-prod: NO_CACHE=--no-cache
rebuild-prod: build-prod


rebuild-work: NO_CACHE=--no-cache
rebuild-work: build-work


# -------------------------------------------------------------------------------------------------
#  TEST TARGETS
# -------------------------------------------------------------------------------------------------

test-base: _check-version
test-base: _EXIST_IMAGE=base
test-base: _check-image-exists
test-base:
	./tests/test.sh ${VERSION} base


test-mods: _check-version
test-mods: _EXIST_IMAGE=mods
test-mods: _check-image-exists
test-mods: _check-version
	./tests/test.sh ${VERSION} mods


test-prod: _check-version
test-prod: _EXIST_IMAGE=prod
test-prod: _check-image-exists
test-prod: _check-version
	./tests/test.sh ${VERSION} prod


test-work: _check-version
test-work: _EXIST_IMAGE=work
test-work: _check-image-exists
test-work: _check-version
	./tests/test.sh ${VERSION} work


# -------------------------------------------------------------------------------------------------
#  HELPER TARGETS
# -------------------------------------------------------------------------------------------------

_check-version:
ifeq ($(strip $(VERSION)),)
	@$(info This make target requires the VERSION variable to be set.)
	@$(info make build-<flavour> VERSION=7.3)
	@$(info )
	@$(error Exiting)
endif
ifeq ($(VERSION),5.2)
else
ifeq ($(VERSION),5.3)
else
ifeq ($(VERSION),5.4)
else
ifeq ($(VERSION),5.5)
else
ifeq ($(VERSION),5.6)
else
ifeq ($(VERSION),7.0)
else
ifeq ($(VERSION),7.1)
else
ifeq ($(VERSION),7.2)
else
ifeq ($(VERSION),7.3)
else
ifeq ($(VERSION),7.4)
else
ifeq ($(VERSION),8.0)
else
	@$(info VERSION can only be: '5.2', '5.3', '5.4', '5.5', '5.6', '7.0', '7.1', '7.2', '7.3', '7.4' or '8.0')
	@$(info )
	@$(error Exiting)
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif
endif


_check-image-exists:
	@if [ "$$(docker images -q $(IMAGE):$(VERSION)-$(_EXIST_IMAGE))" = "" ]; then \
		>&2 echo "Docker image '$(IMAGE):$(VERSION)-$(_EXIST_IMAGE)' is was not found locally."; \
		>&2 echo "Either build it first or explicitly pull it from Dockerhub."; \
		>&2 echo "This is a safeguard to not automatically pull the Docker image."; \
		>&2 echo; \
		false; \
	fi;


_pull-root-image:
	@echo "Pulling root image for PHP ${VERSION}"
	@docker pull $(shell grep FROM $(DIR)/base/Dockerfile-${VERSION} | sed 's/^FROM\s*//g';)
