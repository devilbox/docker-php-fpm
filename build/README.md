# Build helper

This directory contains all tools for building.

## `ansible/`

The `ansible/` directory contains a setup to generate all Dockerfiles. Once generated, they will be placed or updated into [../Dockerfiles](../Dockerfiles).

**How to generate via ansible command**
```bash
# From inside ansible directory
cd ansible
ansible-playbook generate.yml --diff
```

**How to generate via Makefile**
```bash
# From inside root git directory
cd ..
make generate
```

**Requirements**

In order to generate Dockerfiles, you will have to have ansible installed:
```
pip install ansible
```

## `gen-readme.sh`

`gen-readme.sh` will update the README.md with currently enabled PHP modules for each Docker image.

**How to update the README.md**

```bash
# Update for all Docker images
./gen-readme.sh

# Update for specific Docker image
./gen-readme.sh 5.4
./gen-readme.sh 5.5
./gen-readme.sh 5.6
./gen-readme.sh 7.0
./gen-readme.sh 7.1
./gen-readme.sh 7.2
```

**Requirements**

If you want to update the README.md for a specific Docker image, you must have built this image prior running `gen-readme.sh`.
