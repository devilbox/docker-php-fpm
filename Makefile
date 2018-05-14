location = Dockerfiles/

###
### Default
###
help:
	@printf "################################################################################\n"
	@printf "# devilbox/php:XX-XX Makefile\n"
	@printf "################################################################################\n\n"
	@printf "%s\n\n" "Generate and build devilbox PHP-FPM docker images"
	@printf "%s\n" "make generate:           Generate Dockerfiles (requires Ansible)"
	@printf "%s\n" "make readme:             Update Readme with php modules (requires images to be built)"
	@printf "\n"
	@printf "%s\n" "make gen-build:          Generate and build all images"
	@printf "%s\n" "make gen-rebuild:        Generate and rebuild all images"
	@printf "\n"
	@printf "%s\n" "make build-all:          Build all images"
	@printf "%s\n" "make rebuild-all:        Rebuild all images"
	@printf "\n"
	@printf "%s\n" "make build-base:         Build all base images"
	@printf "%s\n" "make build-mods:         Build all mods images"
	@printf "%s\n" "make build-prod:         Build all prod images"
	@printf "%s\n" "make build-work:         Build all work images"
	@printf "\n"
	@printf "%s\n" "make rebuild-base:       Rebuild all base images"
	@printf "%s\n" "make rebuild-mods:       Rebuild all mods images"
	@printf "%s\n" "make rebuild-prod:       Rebuild all prod images"
	@printf "%s\n" "make rebuild-work:       Rebuild all work images"
	@printf "\n"
	@printf "%s\n" "make build-base-53:      Build PHP 5.3 base image"
	@printf "%s\n" "make build-base-54:      Build PHP 5.4 base image"
	@printf "%s\n" "make build-base-55:      Build PHP 5.5 base image"
	@printf "%s\n" "make build-base-56:      Build PHP 5.6 base image"
	@printf "%s\n" "make build-base-70:      Build PHP 7.0 base image"
	@printf "%s\n" "make build-base-71:      Build PHP 7.1 base image"
	@printf "%s\n" "make build-base-72:      Build PHP 7.2 base image"
	@printf "%s\n" "make build-base-73:      Build PHP 7.3 base image"
	@printf "\n"
	@printf "%s\n" "make build-mods-53:      Build PHP 5.3 mods image"
	@printf "%s\n" "make build-mods-54:      Build PHP 5.4 mods image"
	@printf "%s\n" "make build-mods-55:      Build PHP 5.5 mods image"
	@printf "%s\n" "make build-mods-56:      Build PHP 5.6 mods image"
	@printf "%s\n" "make build-mods-70:      Build PHP 7.0 mods image"
	@printf "%s\n" "make build-mods-71:      Build PHP 7.1 mods image"
	@printf "%s\n" "make build-mods-72:      Build PHP 7.2 mods image"
	@printf "%s\n" "make build-mods-73:      Build PHP 7.3 mods image"
	@printf "\n"
	@printf "%s\n" "make build-prod-53:      Build PHP 5.3 prod image"
	@printf "%s\n" "make build-prod-54:      Build PHP 5.4 prod image"
	@printf "%s\n" "make build-prod-55:      Build PHP 5.5 prod image"
	@printf "%s\n" "make build-prod-56:      Build PHP 5.6 prod image"
	@printf "%s\n" "make build-prod-70:      Build PHP 7.0 prod image"
	@printf "%s\n" "make build-prod-71:      Build PHP 7.1 prod image"
	@printf "%s\n" "make build-prod-72:      Build PHP 7.2 prod image"
	@printf "%s\n" "make build-prod-73:      Build PHP 7.3 prod image"
	@printf "\n"
	@printf "%s\n" "make build-work-54:      Build PHP 5.3 work image"
	@printf "%s\n" "make build-work-54:      Build PHP 5.4 work image"
	@printf "%s\n" "make build-work-55:      Build PHP 5.5 work image"
	@printf "%s\n" "make build-work-56:      Build PHP 5.6 work image"
	@printf "%s\n" "make build-work-70:      Build PHP 7.0 work image"
	@printf "%s\n" "make build-work-71:      Build PHP 7.1 work image"
	@printf "%s\n" "make build-work-72:      Build PHP 7.2 work image"
	@printf "%s\n" "make build-work-73:      Build PHP 7.3 work image"
	@printf "\n"
	@printf "%s\n" "make rebuild-base-53:    Build PHP 5.3 base image"
	@printf "%s\n" "make rebuild-base-54:    Build PHP 5.4 base image"
	@printf "%s\n" "make rebuild-base-55:    Build PHP 5.5 base image"
	@printf "%s\n" "make rebuild-base-56:    Build PHP 5.6 base image"
	@printf "%s\n" "make rebuild-base-70:    Build PHP 7.0 base image"
	@printf "%s\n" "make rebuild-base-71:    Build PHP 7.1 base image"
	@printf "%s\n" "make rebuild-base-72:    Build PHP 7.2 base image"
	@printf "%s\n" "make rebuild-base-73:    Build PHP 7.3 base image"
	@printf "\n"
	@printf "%s\n" "make rebuild-mods-53:    Build PHP 5.3 mods image"
	@printf "%s\n" "make rebuild-mods-54:    Build PHP 5.4 mods image"
	@printf "%s\n" "make rebuild-mods-55:    Build PHP 5.5 mods image"
	@printf "%s\n" "make rebuild-mods-56:    Build PHP 5.6 mods image"
	@printf "%s\n" "make rebuild-mods-70:    Build PHP 7.0 mods image"
	@printf "%s\n" "make rebuild-mods-71:    Build PHP 7.1 mods image"
	@printf "%s\n" "make rebuild-mods-72:    Build PHP 7.2 mods image"
	@printf "%s\n" "make rebuild-mods-73:    Build PHP 7.3 mods image"
	@printf "\n"
	@printf "%s\n" "make rebuild-prod-53:    Build PHP 5.3 prod image"
	@printf "%s\n" "make rebuild-prod-54:    Build PHP 5.4 prod image"
	@printf "%s\n" "make rebuild-prod-55:    Build PHP 5.5 prod image"
	@printf "%s\n" "make rebuild-prod-56:    Build PHP 5.6 prod image"
	@printf "%s\n" "make rebuild-prod-70:    Build PHP 7.0 prod image"
	@printf "%s\n" "make rebuild-prod-71:    Build PHP 7.1 prod image"
	@printf "%s\n" "make rebuild-prod-72:    Build PHP 7.2 prod image"
	@printf "%s\n" "make rebuild-prod-73:    Build PHP 7.3 prod image"
	@printf "\n"
	@printf "%s\n" "make rebuild-work-53:    Build PHP 5.3 work image"
	@printf "%s\n" "make rebuild-work-54:    Build PHP 5.4 work image"
	@printf "%s\n" "make rebuild-work-55:    Build PHP 5.5 work image"
	@printf "%s\n" "make rebuild-work-56:    Build PHP 5.6 work image"
	@printf "%s\n" "make rebuild-work-70:    Build PHP 7.0 work image"
	@printf "%s\n" "make rebuild-work-71:    Build PHP 7.1 work image"
	@printf "%s\n" "make rebuild-work-72:    Build PHP 7.2 work image"
	@printf "%s\n" "make rebuild-work-73:    Build PHP 7.3 work image"



###
### Generate
###
generate:
	cd build/ansible; ansible-playbook generate.yml --diff


###
### Update readme
###
readme:
	cd build; ./gen-readme.sh

###
### Generate and build
###
gen-build: generate build-all
gen-rebuild: generate rebuild-all



###
### Build all
###
build-all: build-base build-mods build-prod build-work
rebuild-all: rebuild-base rebuild-mods rebuild-prod rebuild-work



###
### Build categories
###
build-base: build-base-53 build-base-54 build-base-55 build-base-56 build-base-70 build-base-71 build-base-72 build-base-73
build-mods: build-mods-53 build-mods-54 build-mods-55 build-mods-56 build-mods-70 build-mods-71 build-mods-72 build-mods-73
build-prod: build-prod-53 build-prod-54 build-prod-55 build-prod-56 build-prod-70 build-prod-71 build-prod-72 build-prod-73
build-work: build-work-53 build-work-54 build-work-55 build-work-56 build-work-70 build-work-71 build-work-72 build-work-73

rebuild-base: rebuild-base-53 rebuild-base-54 rebuild-base-55 rebuild-base-56 rebuild-base-70 rebuild-base-71 rebuild-base-72 rebuild-base-73
rebuild-mods: rebuild-mods-53 rebuild-mods-54 rebuild-mods-55 rebuild-mods-56 rebuild-mods-70 rebuild-mods-71 rebuild-mods-72 rebuild-mods-73
rebuild-prod: rebuild-prod-53 rebuild-prod-54 rebuild-prod-55 rebuild-prod-56 rebuild-prod-70 rebuild-prod-71 rebuild-prod-72 rebuild-prod-73
rebuild-work: rebuild-work-53 rebuild-work-54 rebuild-work-55 rebuild-work-56 rebuild-work-70 rebuild-work-71 rebuild-work-72 rebuild-work-73



###
### Build separately
###
build-base-53: pull-from-53
	docker build -t devilbox/php-fpm:5.3-base -f $(location)/base/Dockerfile-5.3 $(location)/base
build-base-54: pull-from-54
	docker build -t devilbox/php-fpm:5.4-base -f $(location)/base/Dockerfile-5.4 $(location)/base
build-base-55: pull-from-55
	docker build -t devilbox/php-fpm:5.5-base -f $(location)/base/Dockerfile-5.5 $(location)/base
build-base-56: pull-from-56
	docker build -t devilbox/php-fpm:5.6-base -f $(location)/base/Dockerfile-5.6 $(location)/base
build-base-70: pull-from-70
	docker build -t devilbox/php-fpm:7.0-base -f $(location)/base/Dockerfile-7.0 $(location)/base
build-base-71: pull-from-71
	docker build -t devilbox/php-fpm:7.1-base -f $(location)/base/Dockerfile-7.1 $(location)/base
build-base-72: pull-from-72
	docker build -t devilbox/php-fpm:7.2-base -f $(location)/base/Dockerfile-7.2 $(location)/base
build-base-73: pull-from-73
	docker build -t devilbox/php-fpm:7.3-base -f $(location)/base/Dockerfile-7.3 $(location)/base

build-mods-53:
	docker build -t devilbox/php-fpm:5.3-mods -f $(location)/mods/Dockerfile-5.3 $(location)/mods
build-mods-54:
	docker build -t devilbox/php-fpm:5.4-mods -f $(location)/mods/Dockerfile-5.4 $(location)/mods
build-mods-55:
	docker build -t devilbox/php-fpm:5.5-mods -f $(location)/mods/Dockerfile-5.5 $(location)/mods
build-mods-56:
	docker build -t devilbox/php-fpm:5.6-mods -f $(location)/mods/Dockerfile-5.6 $(location)/mods
build-mods-70:
	docker build -t devilbox/php-fpm:7.0-mods -f $(location)/mods/Dockerfile-7.0 $(location)/mods
build-mods-71:
	docker build -t devilbox/php-fpm:7.1-mods -f $(location)/mods/Dockerfile-7.1 $(location)/mods
build-mods-72:
	docker build -t devilbox/php-fpm:7.2-mods -f $(location)/mods/Dockerfile-7.2 $(location)/mods
build-mods-73:
	docker build -t devilbox/php-fpm:7.3-mods -f $(location)/mods/Dockerfile-7.3 $(location)/mods

build-prod-53:
	docker build -t devilbox/php-fpm:5.3-prod -f $(location)/prod/Dockerfile-5.3 $(location)/prod
build-prod-54:
	docker build -t devilbox/php-fpm:5.4-prod -f $(location)/prod/Dockerfile-5.4 $(location)/prod
build-prod-55:
	docker build -t devilbox/php-fpm:5.5-prod -f $(location)/prod/Dockerfile-5.5 $(location)/prod
build-prod-56:
	docker build -t devilbox/php-fpm:5.6-prod -f $(location)/prod/Dockerfile-5.6 $(location)/prod
build-prod-70:
	docker build -t devilbox/php-fpm:7.0-prod -f $(location)/prod/Dockerfile-7.0 $(location)/prod
build-prod-71:
	docker build -t devilbox/php-fpm:7.1-prod -f $(location)/prod/Dockerfile-7.1 $(location)/prod
build-prod-72:
	docker build -t devilbox/php-fpm:7.2-prod -f $(location)/prod/Dockerfile-7.2 $(location)/prod
build-prod-73:
	docker build -t devilbox/php-fpm:7.3-prod -f $(location)/prod/Dockerfile-7.3 $(location)/prod

build-work-53:
	docker build -t devilbox/php-fpm:5.3-work -f $(location)/work/Dockerfile-5.3 $(location)/work
build-work-54:
	docker build -t devilbox/php-fpm:5.4-work -f $(location)/work/Dockerfile-5.4 $(location)/work
build-work-55:
	docker build -t devilbox/php-fpm:5.5-work -f $(location)/work/Dockerfile-5.5 $(location)/work
build-work-56:
	docker build -t devilbox/php-fpm:5.6-work -f $(location)/work/Dockerfile-5.6 $(location)/work
build-work-70:
	docker build -t devilbox/php-fpm:7.0-work -f $(location)/work/Dockerfile-7.0 $(location)/work
build-work-71:
	docker build -t devilbox/php-fpm:7.1-work -f $(location)/work/Dockerfile-7.1 $(location)/work
build-work-72:
	docker build -t devilbox/php-fpm:7.2-work -f $(location)/work/Dockerfile-7.2 $(location)/work
build-work-73:
	docker build -t devilbox/php-fpm:7.3-work -f $(location)/work/Dockerfile-7.3 $(location)/work



###
### Rebuild separately
###
rebuild-base-53: pull-from-53
	docker build --no-cache -t devilbox/php-fpm:5.3-base -f $(location)/base/Dockerfile-5.3 $(location)/base
rebuild-base-54: pull-from-54
	docker build --no-cache -t devilbox/php-fpm:5.4-base -f $(location)/base/Dockerfile-5.4 $(location)/base
rebuild-base-55: pull-from-55
	docker build --no-cache -t devilbox/php-fpm:5.5-base -f $(location)/base/Dockerfile-5.5 $(location)/base
rebuild-base-56: pull-from-56
	docker build --no-cache -t devilbox/php-fpm:5.6-base -f $(location)/base/Dockerfile-5.6 $(location)/base
rebuild-base-70: pull-from-70
	docker build --no-cache -t devilbox/php-fpm:7.0-base -f $(location)/base/Dockerfile-7.0 $(location)/base
rebuild-base-71: pull-from-71
	docker build --no-cache -t devilbox/php-fpm:7.1-base -f $(location)/base/Dockerfile-7.1 $(location)/base
rebuild-base-72: pull-from-72
	docker build --no-cache -t devilbox/php-fpm:7.2-base -f $(location)/base/Dockerfile-7.2 $(location)/base
rebuild-base-73: pull-from-73
	docker build --no-cache -t devilbox/php-fpm:7.3-base -f $(location)/base/Dockerfile-7.3 $(location)/base

rebuild-mods-53:
	docker build --no-cache -t devilbox/php-fpm:5.3-mods -f $(location)/mods/Dockerfile-5.3 $(location)/mods
rebuild-mods-54:
	docker build --no-cache -t devilbox/php-fpm:5.4-mods -f $(location)/mods/Dockerfile-5.4 $(location)/mods
rebuild-mods-55:
	docker build --no-cache -t devilbox/php-fpm:5.5-mods -f $(location)/mods/Dockerfile-5.5 $(location)/mods
rebuild-mods-56:
	docker build --no-cache -t devilbox/php-fpm:5.6-mods -f $(location)/mods/Dockerfile-5.6 $(location)/mods
rebuild-mods-70:
	docker build --no-cache -t devilbox/php-fpm:7.0-mods -f $(location)/mods/Dockerfile-7.0 $(location)/mods
rebuild-mods-71:
	docker build --no-cache -t devilbox/php-fpm:7.1-mods -f $(location)/mods/Dockerfile-7.1 $(location)/mods
rebuild-mods-72:
	docker build --no-cache -t devilbox/php-fpm:7.2-mods -f $(location)/mods/Dockerfile-7.2 $(location)/mods
rebuild-mods-73:
	docker build --no-cache -t devilbox/php-fpm:7.3-mods -f $(location)/mods/Dockerfile-7.3 $(location)/mods

rebuild-prod-53:
	docker build --no-cache -t devilbox/php-fpm:5.3-prod -f $(location)/prod/Dockerfile-5.3 $(location)/prod
rebuild-prod-54:
	docker build --no-cache -t devilbox/php-fpm:5.4-prod -f $(location)/prod/Dockerfile-5.4 $(location)/prod
rebuild-prod-55:
	docker build --no-cache -t devilbox/php-fpm:5.5-prod -f $(location)/prod/Dockerfile-5.5 $(location)/prod
rebuild-prod-56:
	docker build --no-cache -t devilbox/php-fpm:5.6-prod -f $(location)/prod/Dockerfile-5.6 $(location)/prod
rebuild-prod-70:
	docker build --no-cache -t devilbox/php-fpm:7.0-prod -f $(location)/prod/Dockerfile-7.0 $(location)/prod
rebuild-prod-71:
	docker build --no-cache -t devilbox/php-fpm:7.1-prod -f $(location)/prod/Dockerfile-7.1 $(location)/prod
rebuild-prod-72:
	docker build --no-cache -t devilbox/php-fpm:7.2-prod -f $(location)/prod/Dockerfile-7.2 $(location)/prod
rebuild-prod-73:
	docker build --no-cache -t devilbox/php-fpm:7.3-prod -f $(location)/prod/Dockerfile-7.3 $(location)/prod

rebuild-work-53:
	docker build --no-cache -t devilbox/php-fpm:5.3-work -f $(location)/work/Dockerfile-5.3 $(location)/work
rebuild-work-54:
	docker build --no-cache -t devilbox/php-fpm:5.4-work -f $(location)/work/Dockerfile-5.4 $(location)/work
rebuild-work-55:
	docker build --no-cache -t devilbox/php-fpm:5.5-work -f $(location)/work/Dockerfile-5.5 $(location)/work
rebuild-work-56:
	docker build --no-cache -t devilbox/php-fpm:5.6-work -f $(location)/work/Dockerfile-5.6 $(location)/work
rebuild-work-70:
	docker build --no-cache -t devilbox/php-fpm:7.0-work -f $(location)/work/Dockerfile-7.0 $(location)/work
rebuild-work-71:
	docker build --no-cache -t devilbox/php-fpm:7.1-work -f $(location)/work/Dockerfile-7.1 $(location)/work
rebuild-work-72:
	docker build --no-cache -t devilbox/php-fpm:7.2-work -f $(location)/work/Dockerfile-7.2 $(location)/work
rebuild-work-73:
	docker build --no-cache -t devilbox/php-fpm:7.3-work -f $(location)/work/Dockerfile-7.3 $(location)/work



###
### Pull base FROM images
###
pull-from-53:
	docker pull $(shell grep FROM $(location)/base/Dockerfile-5.3 | sed 's/^FROM//g'; done)
pull-from-54:
	docker pull $(shell grep FROM $(location)/base/Dockerfile-5.4 | sed 's/^FROM//g'; done)
pull-from-55:
	docker pull $(shell grep FROM $(location)/base/Dockerfile-5.5 | sed 's/^FROM//g'; done)
pull-from-56:
	docker pull $(shell grep FROM $(location)/base/Dockerfile-5.6 | sed 's/^FROM//g'; done)
pull-from-70:
	docker pull $(shell grep FROM $(location)/base/Dockerfile-7.0 | sed 's/^FROM//g'; done)
pull-from-71:
	docker pull $(shell grep FROM $(location)/base/Dockerfile-7.1 | sed 's/^FROM//g'; done)
pull-from-72:
	docker pull $(shell grep FROM $(location)/base/Dockerfile-7.2 | sed 's/^FROM//g'; done)
pull-from-73:
	docker pull $(shell grep FROM $(location)/base/Dockerfile-7.3 | sed 's/^FROM//g'; done)



###
### Tests
###
test-base-53:
	./tests/test.sh 5.3 base
test-base-54:
	./tests/test.sh 5.4 base
test-base-55:
	./tests/test.sh 5.5 base
test-base-56:
	./tests/test.sh 5.6 base
test-base-70:
	./tests/test.sh 7.0 base
test-base-71:
	./tests/test.sh 7.1 base
test-base-72:
	./tests/test.sh 7.2 base
test-base-73:
	./tests/test.sh 7.3 base

test-mods-53:
	./tests/test.sh 5.3 mods
test-mods-54:
	./tests/test.sh 5.4 mods
test-mods-55:
	./tests/test.sh 5.5 mods
test-mods-56:
	./tests/test.sh 5.6 mods
test-mods-70:
	./tests/test.sh 7.0 mods
test-mods-71:
	./tests/test.sh 7.1 mods
test-mods-72:
	./tests/test.sh 7.2 mods
test-mods-73:
	./tests/test.sh 7.3 mods

test-prod-53:
	./tests/test.sh 5.3 prod
test-prod-54:
	./tests/test.sh 5.4 prod
test-prod-55:
	./tests/test.sh 5.5 prod
test-prod-56:
	./tests/test.sh 5.6 prod
test-prod-70:
	./tests/test.sh 7.0 prod
test-prod-71:
	./tests/test.sh 7.1 prod
test-prod-72:
	./tests/test.sh 7.2 prod
test-prod-73:
	./tests/test.sh 7.3 prod

test-work-53:
	./tests/test.sh 5.3 work
test-work-54:
	./tests/test.sh 5.4 work
test-work-55:
	./tests/test.sh 5.5 work
test-work-56:
	./tests/test.sh 5.6 work
test-work-70:
	./tests/test.sh 7.0 work
test-work-71:
	./tests/test.sh 7.1 work
test-work-72:
	./tests/test.sh 7.2 work
test-work-73:
	./tests/test.sh 7.3 work
