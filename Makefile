ifneq (,)
.error This Makefile requires GNU Make.
endif


# -------------------------------------------------------------------------------------------------
# Docker configuration
# -------------------------------------------------------------------------------------------------

DIR = Dockerfiles
IMAGE = devilbox/php-fpm
NO_CACHE =
PHP_EXT_DIR =

# Run checks after each module has been installed (slow, but yields errors faster)
FAIL_FAST = False

# -------------------------------------------------------------------------------------------------
#  DEFAULT TARGET
# -------------------------------------------------------------------------------------------------

help:
	@echo
	@echo "             _         _ _ _            __   _           ___          "
	@echo "           _| |___ _ _<_| | |_ _____   / ___| |_ ___ ___| | ___._ _ _ "
	@echo "          / . / ._| | | | | . / . \ \// | . | . | . |___| || . | ' ' |"
	@echo "          \___\___|__/|_|_|___\___/\_/_/|  _|_|_|  _/   |_||  _|_|_|_|"
	@echo "                                        |_|     |_|        |_|        "
	@echo
	@echo
	@echo "Targets"
	@echo "--------------------------------------------------------------------------------"
	@echo
	@echo "gen-readme [VERSION=]         Update README with PHP modules from built images."
	@echo "gen-dockerfiles [FAIL_FAST=]  Generate Dockerfiles from templates."
	@echo
	@echo "build-base VERSION= [ARGS=]   Build base image by specified version"
	@echo "build-mods VERSION= [ARGS=]   Build mods image by specified version"
	@echo "build-prod VERSION= [ARGS=]   Build prod image by specified version"
	@echo "build-work VERSION= [ARGS=]   Build work image by specified version"
	@echo
	@echo "rebuild-base VERSION= [ARGS=] Rebuild base image by specified version"
	@echo "rebuild-mods VERSION= [ARGS=] Rebuild mods image by specified version"
	@echo "rebuild-prod VERSION= [ARGS=] Rebuild prod image by specified version"
	@echo "rebuild-work VERSION= [ARGS=] Rebuild work image by specified version"
	@echo
	@echo "test-base VERSION=            Test base image by specified version"
	@echo "test-mods VERSION=            Test mods image by specified version"
	@echo "test-prod VERSION=            Test prod image by specified version"
	@echo "test-work VERSION=            Test work image by specified version"
	@echo
	@echo
	@echo "Variables"
	@echo "--------------------------------------------------------------------------------"
	@echo
	@echo "VERSION                       One of '5.2', '5.3', '5.4', '5.5', '5.6', '7.0',"
	@echo "                                      '7.1', '7.2', '7.3', '7.4', '8.0'."
	@echo "                              For gen-readme target it is optional and if not"
	@echo "                              specified, it will generate for all versions."
	@echo
	@echo "FAIL_FAST                     Either 'True' or 'False' (defaults to 'False')."
	@echo "                              If set to 'True', each module install has an"
	@echo "                              immediate check, which is very slow for CI, but"
	@echo "                              yields errors immediately."
	@echo "                              If set to 'False', checks are done at the end."
	@echo
	@echo "ARGS                          Can be added to all build-* and rebuild-* targets"
	@echo "                              to supply additional docker build options."

# -------------------------------------------------------------------------------------------------
#  GENERATE TARGETS
# -------------------------------------------------------------------------------------------------

gen-readme:
ifeq ($(strip $(VERSION)),)
	@echo "Generate README.md for all PHP versions"
	cd build; ./gen-readme.sh
else
	@echo "Generate README.md for PHP $(VERSION)"
	@$(MAKE) --no-print-directory _check-version
	@$(MAKE) --no-print-directory _check-image-exists _EXIST_IMAGE=base
	@$(MAKE) --no-print-directory _check-image-exists _EXIST_IMAGE=mods
	cd build; ./gen-readme.sh $(VERSION)
endif


gen-dockerfiles:
	docker run --rm \
		$$(tty -s && echo "-it" || echo) \
		-e USER=ansible \
		-e MY_UID=$$(id -u) \
		-e MY_GID=$$(id -g) \
		-v ${PWD}:/data \
		-w /data/build/ansible \
		cytopia/ansible:2.6-tools ansible-playbook generate.yml \
			-e ANSIBLE_STRATEGY_PLUGINS=/usr/lib/python3.6/site-packages/ansible_mitogen/plugins/strategy \
			-e ANSIBLE_STRATEGY=mitogen_linear \
			-e ansible_python_interpreter=/usr/bin/python3 \
			-e \"{build_fail_fast: $(FAIL_FAST)}\" \
			--diff $(ARGS)


# -------------------------------------------------------------------------------------------------
#  BUILD TARGETS
# -------------------------------------------------------------------------------------------------

build-base: _check-version
build-base:
	docker build $(NO_CACHE) \
		--label "org.opencontainers.image.created"="$$(date --rfc-3339=s)" \
		--label "org.opencontainers.image.version"="$$(git rev-parse --abbrev-ref HEAD)" \
		--label "org.opencontainers.image.revision"="$$(git rev-parse HEAD))" \
		$(ARGS) \
		-t $(IMAGE):${VERSION}-base \
		-f $(DIR)/base/Dockerfile-${VERSION} $(DIR)/base


build-mods: _check-version
build-mods: _EXIST_IMAGE=base
build-mods: _check-image-exists
build-mods:
ifeq ($(strip $(TARGET)),)
	docker build $(NO_CACHE) \
		--target builder \
		-t $(IMAGE):$(VERSION)-mods \
		-f $(DIR)/mods/Dockerfile-$(VERSION) $(DIR)/mods;
	@# $(NO_CACHE) is removed, as it would otherwise rebuild the 'builder' image again.
	docker build \
		--target final \
		--label "org.opencontainers.image.created"="$$(date --rfc-3339=s)" \
		--label "org.opencontainers.image.version"="$$(git rev-parse --abbrev-ref HEAD)" \
		--label "org.opencontainers.image.revision"="$$(git rev-parse HEAD)" \
		--build-arg EXT_DIR="$$( docker run --rm --entrypoint=php $(IMAGE):$(VERSION)-mods -i \
			| grep ^extension_dir \
			| awk -F '=>' '{print $$2}' \
			| xargs \
		)" \
		$(ARGS) \
		-t $(IMAGE):$(VERSION)-mods \
		-f $(DIR)/mods/Dockerfile-$(VERSION) $(DIR)/mods;
else
	docker build $(NO_CACHE) \
		--target $(TARGET) \
		--label "org.opencontainers.image.created"="$$(date --rfc-3339=s)" \
		--label "org.opencontainers.image.version"="$$(git rev-parse --abbrev-ref HEAD)" \
		--label "org.opencontainers.image.revision"="$$(git rev-parse HEAD)" \
		$(ARGS) \
		-t $(IMAGE):$(VERSION)-mods \
		-f $(DIR)/mods/Dockerfile-$(VERSION) $(DIR)/mods
endif


build-prod: _check-version
build-prod: _EXIST_IMAGE=mods
build-prod: _check-image-exists
build-prod:
	docker build $(NO_CACHE) \
		--label "org.opencontainers.image.created"="$$(date --rfc-3339=s)" \
		--label "org.opencontainers.image.version"="$$(git rev-parse --abbrev-ref HEAD)" \
		--label "org.opencontainers.image.revision"="$$(git rev-parse HEAD)" \
		$(ARGS) \
		-t $(IMAGE):${VERSION}-prod \
		-f $(DIR)/prod/Dockerfile-${VERSION} $(DIR)/prod


build-work: _check-version
build-work: _EXIST_IMAGE=prod
build-work: _check-image-exists
build-work:
	docker build $(NO_CACHE) \
		--label "org.opencontainers.image.created"="$$(date --rfc-3339=s)" \
		--label "org.opencontainers.image.version"="$$(git rev-parse --abbrev-ref HEAD)" \
		--label "org.opencontainers.image.revision"="$$(git rev-parse HEAD)" \
		$(ARGS) \
		-t $(IMAGE):${VERSION}-work \
		-f $(DIR)/work/Dockerfile-${VERSION} $(DIR)/work


# -------------------------------------------------------------------------------------------------
#  REBUILD TARGETS
# -------------------------------------------------------------------------------------------------

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
#  DOCKERHUB TARGETS
# -------------------------------------------------------------------------------------------------
login:
ifeq ($(strip $(USERNAME)),)
	@$(info This make target requires the USERNAME variable to be set.)
	@$(info make login USERNAME= PASSWORD=)
	@$(info )
	@$(error Exiting)
endif
ifeq ($(strip $(PASSWORD)),)
	@$(info This make target requires the PASSWORD variable to be set.)
	@$(info make login USERNAME= PASSWORD=)
	@$(info )
	@$(error Exiting)
endif
	@yes | docker login --username "${USERNAME}" --password "${PASSWORD}"


push:
ifeq ($(strip $(TAG)),)
	@$(info This make target requires the TAG variable to be set.)
	@$(info make push TAG=)
	@$(info )
	@$(error Exiting)
endif
	docker push $(IMAGE):$(TAG)


tag:
ifeq ($(strip $(OLD_TAG)),)
	@$(info This make target requires the OLD_TAG variable to be set.)
	@$(info make tag OLD_TAG= NEW_TAG=)
	@$(info )
	@$(error Exiting)
endif
ifeq ($(strip $(NEW_TAG)),)
	@$(info This make target requires the NEW_TAG variable to be set.)
	@$(info make tag OLD_TAG= NEW_TAG=)
	@$(info )
	@$(error Exiting)
endif
	docker tag $(IMAGE):$(OLD_TAG) $(IMAGE):$(NEW_TAG)



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
	@echo "Version $(VERSION) is valid"


_check-image-exists:
	@if [ "$$(docker images -q $(IMAGE):$(VERSION)-$(_EXIST_IMAGE))" = "" ]; then \
		>&2 echo "Docker image '$(IMAGE):$(VERSION)-$(_EXIST_IMAGE)' was not found locally."; \
		>&2 echo "Either build it first or explicitly pull it from Dockerhub."; \
		>&2 echo "This is a safeguard to not automatically pull the Docker image."; \
		>&2 echo; \
		false; \
	fi;


_pull-root-image:
	@echo "Pulling root image for PHP ${VERSION}"
	@docker pull $(shell grep FROM $(DIR)/base/Dockerfile-${VERSION} | sed 's/^FROM\s*//g';)
