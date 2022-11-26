#!/usr/bin/env python3
import os
import yaml
import copy
from collections import OrderedDict


SCRIPT_PATH = os.path.dirname(os.path.realpath(__file__))
REPOSITORY_PATH = os.path.dirname(os.path.dirname(SCRIPT_PATH))
PHP_MODULE_PATH = os.path.join(REPOSITORY_PATH, "php_modules")
GROUP_VARS_PATH = os.path.join(REPOSITORY_PATH, ".ansible", "group_vars", "all")

# --------------------------------------------------------------------------------------------------
# PATH FUNCTIONS
# --------------------------------------------------------------------------------------------------

def get_repository_path() -> str:
    """Returns the absolute repository directory path."""
    script_path = os.path.dirname(os.path.realpath(__file__))
    return os.path.dirname(os.path.dirname(script_path))


def get_module_path(repository_path: str) -> str:
    """Returns the absolute PHP module directory path."""
    return os.path.join(repository_path, "php_modules")


def get_group_vars_path(repository_path: str) -> str:
    """Returns the absolute mods group_vars directory path."""
    return os.path.join(repository_path, ".ansible", "group_vars", "all")


# --------------------------------------------------------------------------------------------------
# MODULE FUNCTIONS
# --------------------------------------------------------------------------------------------------

def get_module_options(module_dirname: str) -> dict[str, str]:
    """Returns yaml dict options of a PHP module given by its absolute file path."""
    with open(os.path.join(PHP_MODULE_PATH, module_dirname, "options.yml")) as fp:
        data = yaml.safe_load(fp)
        return data


def get_module_dir_names() -> list[str]:
    """Returns a list of PHP module directory names."""
    directories = []
    with os.scandir(PHP_MODULE_PATH) as it:
        for item in it:
            if not item.name.startswith('.') and item.is_dir():
                directories.append(item.name)
    return sorted(directories, key=str.lower)


def get_module_dependency_tree(names: list[str]) -> dict():
    """Returns dictionary of module dependency tree."""
    module_tree = OrderedDict()

    for name in names:
        data = get_module_options(name)

        mod_name = data["name"]
        mod_deps = data["requires"]

        module_tree[mod_name] = {}

        # Do we have module requirements?
        if len(mod_deps) > 0:
            module_tree[mod_name] = get_module_dependency_tree(mod_deps)
    return module_tree


def resolve_module_dependency_tree(tree):
    """Returns sorted list of resolved dependencies."""
    resolved = []
    for key, value in tree.items():
        # Has dependenies
        if tree[key]:
            childs = resolve_module_dependency_tree(tree[key])
            for child in childs:
                if child not in resolved:
                    resolved.append(child)
        # Add current node, if not already available
        if key not in resolved:
            resolved.append(key)
    return resolved


# --------------------------------------------------------------------------------------------------
# PRINT FUNCTIONS
# --------------------------------------------------------------------------------------------------

def print_dependency_tree(tree, lvl=0):
    for key, value in tree.items():
        print(" "*lvl, "-", key)
        if value:
            print_dependency_tree(tree[key], lvl+2)


# --------------------------------------------------------------------------------------------------
# MAIN FUNCTION
# --------------------------------------------------------------------------------------------------

def main():
    # Module directory names
    directory_names = get_module_dir_names()

    # Get modules in order of dependencies
    module_tree = get_module_dependency_tree(directory_names)
    modules = resolve_module_dependency_tree(module_tree)

    print("#", "-"*78)
    print("# Paths")
    print("#", "-"*78)
    print("Repository: ", REPOSITORY_PATH)
    print("PHP Module: ", PHP_MODULE_PATH)
    print("Group Vars: ", GROUP_VARS_PATH)
    print()

    print("#", "-"*78)
    print("# Module directories")
    print("#", "-"*78)
    print(directory_names)
    print()

    print("#", "-"*78)
    print("# Dependency Tree")
    print("#", "-"*78)
    print_dependency_tree(module_tree)
    print()

    print("#", "-"*78)
    print("# Sorted PHP modules")
    print("#", "-"*78)
    print(modules)


if __name__ == "__main__":
    main()
