#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Generate Ansible group_vars from module definition."""
import os
import sys
from collections import OrderedDict
from typing import Dict, List, Any
import yaml


# --------------------------------------------------------------------------------------------------
# GLOBALS
# --------------------------------------------------------------------------------------------------

SCRIPT_PATH = str(os.path.dirname(os.path.realpath(__file__)))
REPOSITORY_PATH = str(os.path.dirname(os.path.dirname(SCRIPT_PATH)))
PHP_MODULE_PATH = str(os.path.join(REPOSITORY_PATH, "php_modules"))
GROUP_VARS_PATH = str(os.path.join(REPOSITORY_PATH, ".ansible", "group_vars", "all"))


# --------------------------------------------------------------------------------------------------
# HELPER FUNCTIONS
# --------------------------------------------------------------------------------------------------


def get_el_by_name(items: List[Dict[str, Any]], name: str) -> Dict[str, Any]:
    """Returns an element from a dict list by its 'name' key with given value."""
    for item in items:
        if item["name"] == name:
            return item
    print("error, key name not found by value", name, "in list: ", items)
    sys.exit(1)


def load_yaml(path: str) -> Dict[str, Any]:
    """Load yaml file and return its dict()."""
    with open(path, encoding="utf8") as fp:
        data = yaml.safe_load(fp)
        return data


# --------------------------------------------------------------------------------------------------
# MODULE FUNCTIONS
# --------------------------------------------------------------------------------------------------


def get_module_options(module_dirname: str) -> Dict[str, Any]:
    """Returns yaml dict options of a PHP module given by its absolute file path."""
    return load_yaml(os.path.join(PHP_MODULE_PATH, module_dirname, "options.yml"))


def get_module_build(module_dirname: str) -> Dict[str, Any]:
    """Returns yaml dict build configuration of a PHP module given by its absolute file path."""
    return load_yaml(os.path.join(PHP_MODULE_PATH, module_dirname, "build.yml"))


def get_module_test(module_dirname: str) -> Dict[str, Any]:
    """Returns yaml dict test configuration of a PHP module given by its absolute file path."""
    return load_yaml(os.path.join(PHP_MODULE_PATH, module_dirname, "test.yml"))


def get_modules() -> List[Dict[str, Any]]:
    """Returns a list of PHP module directory names."""
    modules = []
    with os.scandir(PHP_MODULE_PATH) as it:
        for item in it:
            if not item.name.startswith(".") and item.is_dir():
                data = get_module_options(item.name)
                modules.append({"dir": item.name, "name": data["name"], "deps": data["requires"]})
    # Convert list of deps into dict(dir, name, deps)
    items = []
    for module in modules:
        if module["deps"]:
            deps = []
            for dep in module["deps"]:
                deps.append(get_el_by_name(modules, dep))
            module["deps"] = deps
            items.append(module)
        else:
            items.append(module)
    return sorted(items, key=lambda item: item["dir"])


def get_module_dependency_tree(modules: List[Dict[str, Any]]) -> OrderedDict[str, Any]:
    """Returns dictionary of module dependency tree."""
    module_tree = OrderedDict()  # type: OrderedDict[str, Any]

    for module in modules:
        mod_name = module["name"]
        mod_deps = module["deps"]

        module_tree[mod_name] = {}

        # Do we have module requirements?
        if len(mod_deps) > 0:
            module_tree[mod_name] = get_module_dependency_tree(mod_deps)
    return module_tree


def resolve_module_dependency_tree(tree: OrderedDict[str, Any]) -> List[str]:
    """Returns sorted list of resolved dependencies."""
    resolved = []
    for key, _ in tree.items():
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


def print_modules(modules: List[Dict[str, Any]]) -> None:
    """Print directory modules."""
    for module in modules:
        print(module["dir"] + "/")
        print("   name:", module["name"])
        print("   deps:", end=" ")
        for dep in module["deps"]:
            print(dep["name"], end=", ")
        print()


def print_dependency_tree(tree: Dict[str, Any], lvl: int = 0) -> None:
    """Print dependency tree of modules."""
    for key, value in tree.items():
        print(" " * lvl, "-", key)
        if value:
            print_dependency_tree(tree[key], lvl + 2)


# --------------------------------------------------------------------------------------------------
# WRITE ANSIBLE GROUP_VARS FUNCTIONS
# --------------------------------------------------------------------------------------------------


def write_group_vars(module_names: List[str]) -> None:
    """Write mods.yml group_vars for ansible."""
    group_vars = os.path.join(GROUP_VARS_PATH, "mods.yml")
    with open(group_vars, "w", encoding="utf8") as fp:
        fp.write("---\n\n")
        fp.write("# Do not alter this file, it is autogenerated\n\n")
        fp.write("modules:\n")
        for name in module_names:
            fp.write("  - " + name + "\n")


# --------------------------------------------------------------------------------------------------
# MAIN FUNCTION
# --------------------------------------------------------------------------------------------------


def main() -> None:
    """Main entrypoint."""
    # Get modules in order of dependencies
    modules = get_modules()
    module_tree = get_module_dependency_tree(modules)
    names = resolve_module_dependency_tree(module_tree)

    print("#", "-" * 78)
    print("# Paths")
    print("#", "-" * 78)
    print("Repository: ", REPOSITORY_PATH)
    print("PHP Module: ", PHP_MODULE_PATH)
    print("Group Vars: ", GROUP_VARS_PATH)
    print()

    print("#", "-" * 78)
    print("# Module directories")
    print("#", "-" * 78)
    print_modules(modules)
    print()

    print("#", "-" * 78)
    print("# Build Dependency Tree")
    print("#", "-" * 78)
    print_dependency_tree(module_tree)
    print()

    print("#", "-" * 78)
    print("# Build order")
    print("#", "-" * 78)
    print(names)

    # Create group_vars file mods.yml
    write_group_vars(names)


if __name__ == "__main__":
    main()
