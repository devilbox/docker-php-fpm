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
REPOSITORY_PATH = str(os.path.dirname(SCRIPT_PATH))
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
    with open(path, "r", encoding="utf8") as fp:
        data = yaml.safe_load(fp)
        return data


def load_yaml_raw(path: str, indent: int = 0) -> str:
    """Load and returns yaml file as str."""
    lines = []
    with open(path, "r", encoding="utf8") as fp:
        for line in fp:
            # Remove: empty lines and ---
            if line in ("---\n", "---\r\n", "\n", "\r\n"):
                continue
            # Remove: comments
            if line.startswith("#"):
                continue
            lines.append(" " * indent + line)
    return "".join(lines)


# --------------------------------------------------------------------------------------------------
# MODULE FUNCTIONS
# --------------------------------------------------------------------------------------------------


def get_module_options(module_dirname: str) -> Dict[str, Any]:
    """Returns yaml dict options of a PHP module given by its absolute file path."""
    return load_yaml(os.path.join(PHP_MODULE_PATH, module_dirname, "options.yml"))


def get_module_install(module_dirname: str) -> Dict[str, Any]:
    """Returns yaml dict install configuration of a PHP module given by its absolute file path."""
    return load_yaml(os.path.join(PHP_MODULE_PATH, module_dirname, "install.yml"))


def get_module_test(module_dirname: str) -> Dict[str, Any]:
    """Returns yaml dict test configuration of a PHP module given by its absolute file path."""
    return load_yaml(os.path.join(PHP_MODULE_PATH, module_dirname, "test.yml"))


def get_modules(selected_modules: List[str], ignore_dependencies: bool) -> List[Dict[str, Any]]:
    """Returns a list of PHP module directory names.

    Args:
        selected_modules: If not empty, only gather specified modules (and its dependencies).
        ignore_dependencies: If true, all dependent extensions will be ignored.
    """
    modules = []
    with os.scandir(PHP_MODULE_PATH) as it:
        for item in it:
            if not item.name.startswith(".") and item.is_dir():
                data = get_module_options(item.name)
                modules.append(
                    {
                        "dir": item.name,
                        "name": data["name"],
                        "deps": data["depends_build"],
                        "exclude": data["exclude"],
                    }
                )
    # Convert list of deps into dict(dir, name, deps)
    items = []
    for module in modules:
        if module["deps"] and not ignore_dependencies:
            deps = []
            for dep in module["deps"]:
                deps.append(get_el_by_name(modules, dep))
            module["deps"] = deps
            items.append(module)
        else:
            module["deps"] = []
            items.append(module)
    # Check if we only want to read a single module
    if selected_modules:
        return [get_el_by_name(items, mod_name) for mod_name in selected_modules]
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
        print("   excl:", module["exclude"])


def print_dependency_tree(tree: Dict[str, Any], lvl: int = 0) -> None:
    """Print dependency tree of modules."""
    for key, value in tree.items():
        print(" " * lvl, "-", key)
        if value:
            print_dependency_tree(tree[key], lvl + 2)


# --------------------------------------------------------------------------------------------------
# WRITE ANSIBLE GROUP_VARS FUNCTIONS
# --------------------------------------------------------------------------------------------------


def write_group_vars(modules: List[str]) -> None:
    """Write mods.yml group_vars for ansible."""
    group_vars = os.path.join(GROUP_VARS_PATH, "mods.yml")

    with open(group_vars, "w", encoding="utf8") as fp:
        fp.write("---\n\n")
        fp.write("# DO NOT ALTER THIS FILE - IT IS AUTOGENERATED.\n\n")

        # Enabled modules
        fp.write("# The following specifies the order in which modules are being built.\n")
        fp.write("extensions_enabled:\n")
        for module in modules:
            fp.write("  - " + module + "\n")
        fp.write("\n\n")

        # Build defines modules
        fp.write("# The following specifies how modules are being built.\n")
        fp.write("extensions_available:\n")
        for module in modules:
            opts = get_module_options(module)
            fp.write("  " + module + ":\n")
            fp.write("    disabled: [" + ", ".join(str(x) for x in opts["exclude"]) + "]\n")
            fp.write(load_yaml_raw(os.path.join(PHP_MODULE_PATH, module, "install.yml"), 4))


# --------------------------------------------------------------------------------------------------
# MAIN FUNCTION
# --------------------------------------------------------------------------------------------------
def print_help() -> None:
    """Show help screen."""
    print("Usage:", os.path.basename(__file__), "[options] [PHP-EXT]...")
    print("      ", os.path.basename(__file__), "-h, --help")
    print()
    print("This script will generate the Ansible group_vars file: .ansible/group_vars/all/mods.yml")
    print("based on all the modules found in php_modules/ directory.")
    print()
    print("Positional arguments:")
    print("    [PHP-EXT]   Specify None, one or more PHP extensions to generate group_vars for.")
    print("                When no PHP extension is specified (argument is omitted), group_vars")
    print("                for all extensions will be genrated.")
    print("                When one or more PHP extension are specified, only group_vars for")
    print("                these extensions will be created.")
    print("                    only be generated for this single module (and its dependencies).")
    print("                    This is useful if you want to test new modules and not build all")
    print("                    previous modules in the Dockerfile.")
    print()
    print("                    Note: You still need to generate the Dockerfiles via Ansible for")
    print("                          the changes to take effect, before building the image.")
    print("Optional arguments:")
    print("    -i          Ignore dependent modules.")
    print("                By default each exentions is checked for build dependencies of other")
    print("                extensions. For example many extensions build against libxml ext.")
    print("                By specifying -i, those dependencies are not beeing added to")
    print("                ansible group_vars. Use at your own risk.")


def main(argv: List[str]) -> None:
    """Main entrypoint."""
    ignore_dependencies = False
    selected_modules = []
    if len(argv):
        for arg in argv:
            if arg in ("-h", "--help"):
                print_help()
                sys.exit(0)
        for arg in argv:
            if arg.startswith("-") and arg != "-i":
                print("Invalid argument:", arg)
                print("Use -h or --help for help")
                sys.exit(1)
            if arg == "-i":
                ignore_dependencies = True
            else:
                selected_modules.append(arg)

    # Get modules in order of dependencies
    modules = get_modules(selected_modules, ignore_dependencies)
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
    print("\n".join(names))

    # Create group_vars file mods.yml
    write_group_vars(names)


if __name__ == "__main__":
    main(sys.argv[1:])
