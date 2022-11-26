#!/usr/bin/env python3
import os
import yaml
import copy
from collections import OrderedDict


# --------------------------------------------------------------------------------------------------
# PATH FUNCTIONS
# --------------------------------------------------------------------------------------------------

def get_repository_path() -> str:
    """Returns the absolute repository directory path."""
    script_path = os.path.dirname(os.path.realpath(__file__))
    return os.path.dirname(os.path.dirname(script_path))


def get_module_path(repository_path) -> str:
    """Returns the absolute PHP module directory path."""
    return os.path.join(repository_path, "php_modules")


def get_group_vars_path(repository_path) -> str:
    """Returns the absolute mods group_vars directory path."""
    return os.path.join(repository_path, ".ansible", "group_vars", "all")


def get_module_dir_names(path: str) -> list[str]:
    """Returns a list of PHP module directory names."""
    directories = []
    with os.scandir(path) as it:
        for item in it:
            if not item.name.startswith('.') and item.is_dir():
                directories.append(item.name)
    return sorted(directories, key=str.lower)


# --------------------------------------------------------------------------------------------------
# MODULE FUNCTIONS
# --------------------------------------------------------------------------------------------------

def get_module_options(path: str) -> dict[str, str]:
    mod_opt_path = os.path.join(path, "options.yml")
    with open(mod_opt_path) as options:
        data = yaml.safe_load(options)
        return data


def get_module_dependency_tree(names: list[str], path: str) -> dict():
    """Returns dictionary of module dependency tree."""
    module_tree = OrderedDict()

    for name in names:
        # Full path of options.yml inside module directory
        opt_path = os.path.join(path, name)
        data = get_module_options(opt_path)

        mod_name = data["name"]
        mod_deps = data["requires"]

        module_tree[mod_name] = {}

        # Do we have module requirements?
        if len(mod_deps) > 0:
            module_tree[mod_name] = get_module_dependency_tree(mod_deps, path)
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
    # Get paths
    repository_path = get_repository_path()
    php_module_path = get_module_path(repository_path)
    group_vars_path = get_group_vars_path(repository_path)

    # Module directory names
    directory_names = get_module_dir_names(php_module_path)

    # Get modules in order of dependencies
    module_tree = get_module_dependency_tree(directory_names, php_module_path)
    modules = resolve_module_dependency_tree(module_tree)

    print("#", "-"*78)
    print("# Paths")
    print("#", "-"*78)
    print("Repository: ", repository_path)
    print("PHP Module: ", php_module_path)
    print("Group Vars: ", group_vars_path)
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
