#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Generate Ansible group_vars from tools (installed software) definition."""
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
PHP_TOOL_PATH = str(os.path.join(REPOSITORY_PATH, "php_tools"))
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
# TOOL FUNCTIONS
# --------------------------------------------------------------------------------------------------


def get_tool_options(tool_dirname: str) -> Dict[str, Any]:
    """Returns yaml dict options of a PHP tool given by its absolute file path."""
    return load_yaml(os.path.join(PHP_TOOL_PATH, tool_dirname, "options.yml"))


def get_tool_install(tool_dirname: str) -> Dict[str, Any]:
    """Returns yaml dict install configuration of a PHP tool given by its absolute file path."""
    return load_yaml(os.path.join(PHP_TOOL_PATH, tool_dirname, "install.yml"))


def get_tools(selected_tools: List[str], ignore_dependencies: bool) -> List[Dict[str, Any]]:
    """Returns a list of PHP tool directory names.

    Args:
        selected_tools: If not empty, only gather specified tools (and its dependencies).
        ignore_dependencies: If true, all dependent tools will be ignored.
    """
    tools = []
    with os.scandir(PHP_TOOL_PATH) as it:
        for item in it:
            if not item.name.startswith(".") and item.is_dir():
                data = get_tool_options(item.name)
                tools.append(
                    {
                        "dir": item.name,
                        "name": data["name"],
                        "deps": data["depends"],
                        "exclude": data["exclude"],
                    }
                )
    # Convert list of deps into dict(dir, name, deps)
    items = []
    for tool in tools:
        if tool["deps"] and not ignore_dependencies:
            deps = []
            for dep in tool["deps"]:
                deps.append(get_el_by_name(tools, dep))
            tool["deps"] = deps
            items.append(tool)
        else:
            tool["deps"] = []
            items.append(tool)
    # Check if we only want to read a single tool
    if selected_tools:
        return [get_el_by_name(items, tool_name) for tool_name in selected_tools]
    return sorted(items, key=lambda item: item["dir"])


def get_tool_dependency_tree(tools: List[Dict[str, Any]]) -> OrderedDict[str, Any]:
    """Returns dictionary of tool dependency tree."""
    tool_tree = OrderedDict()  # type: OrderedDict[str, Any]

    for tool in tools:
        tool_name = tool["name"]
        tool_deps = tool["deps"]

        tool_tree[tool_name] = {}

        # Do we have tool requirements?
        if len(tool_deps) > 0:
            tool_tree[tool_name] = get_tool_dependency_tree(tool_deps)
    return tool_tree


def resolve_tool_dependency_tree(tree: OrderedDict[str, Any]) -> List[str]:
    """Returns sorted list of resolved dependencies."""
    resolved = []
    for key, _ in tree.items():
        # Has dependenies
        if tree[key]:
            childs = resolve_tool_dependency_tree(tree[key])
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


def print_tools(tools: List[Dict[str, Any]]) -> None:
    """Print directory tools."""
    for tool in tools:
        print(tool["dir"] + "/")
        print("   name:", tool["name"])
        print("   deps:", end=" ")
        for dep in tool["deps"]:
            print(dep["name"], end=", ")
        print()
        print("   excl:", tool["exclude"])


def print_dependency_tree(tree: Dict[str, Any], lvl: int = 0) -> None:
    """Print dependency tree of tools."""
    for key, value in tree.items():
        print(" " * lvl, "-", key)
        if value:
            print_dependency_tree(tree[key], lvl + 2)


# --------------------------------------------------------------------------------------------------
# WRITE ANSIBLE GROUP_VARS FUNCTIONS
# --------------------------------------------------------------------------------------------------


def write_group_vars(tools: List[str]) -> None:
    """Write work.yml group_vars for ansible."""
    group_vars = os.path.join(GROUP_VARS_PATH, "work.yml")

    with open(group_vars, "w", encoding="utf8") as fp:
        fp.write("---\n\n")
        fp.write("# DO NOT ALTER THIS FILE - IT IS AUTOGENERATED.\n\n")

        # Enabled tools
        fp.write("# The following specifies the order in which tools are being installed.\n")
        fp.write("tools_enabled:\n")
        for tool in tools:
            fp.write("  - " + tool + "\n")
        fp.write("\n\n")

        # Build defines tools
        fp.write("# The following specifies how tools are being installed.\n")
        fp.write("tools_available:\n")
        for tool in tools:
            opts = get_tool_options(tool)
            fp.write("  " + tool + ":\n")
            fp.write("    disabled: [" + ", ".join(str(x) for x in opts["exclude"]) + "]\n")
            fp.write(load_yaml_raw(os.path.join(PHP_TOOL_PATH, tool, "install.yml"), 4))


# --------------------------------------------------------------------------------------------------
# MAIN FUNCTION
# --------------------------------------------------------------------------------------------------
def print_help() -> None:
    """Show help screen."""
    print("Usage:", os.path.basename(__file__), "[options] [PHP-TOOL]...")
    print("      ", os.path.basename(__file__), "-h, --help")
    print()
    print("This script will generate the Ansible group_vars file: .ansible/group_vars/all/work.yml")
    print("based on all the tools found in php_tools/ directory.")
    print()
    print("Positional arguments:")
    print("    [PHP-TOOL]  Specify None, one or more PHP tools to generate group_vars for.")
    print("                When no PHP tool is specified (argument is omitted), group_vars")
    print("                for all tools will be genrated.")
    print("                When one or more PHP tool are specified, only group_vars for")
    print("                these tools will be created.")
    print("                    only be generated for this single tool (and its dependencies).")
    print("                    This is useful if you want to test new tools and not build all")
    print("                    previous tools in the Dockerfile.")
    print()
    print("                    Note: You still need to generate the Dockerfiles via Ansible for")
    print("                          the changes to take effect, before building the image.")
    print("Optional arguments:")
    print("    -i          Ignore dependent tools.")
    print("                By default each tool is checked for dependencies of other")
    print("                tools.")
    print("                By specifying -i, those dependent tools are not beeing added to")
    print("                ansible group_vars. Use at your own risk.")


def main(argv: List[str]) -> None:
    """Main entrypoint."""
    ignore_dependencies = False
    selected_tools = []
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
                selected_tools.append(arg)

    # Get tools in order of dependencies
    tools = get_tools(selected_tools, ignore_dependencies)
    tool_tree = get_tool_dependency_tree(tools)
    names = resolve_tool_dependency_tree(tool_tree)

    print("#", "-" * 78)
    print("# Paths")
    print("#", "-" * 78)
    print("Repository: ", REPOSITORY_PATH)
    print("PHP Tools:  ", PHP_TOOL_PATH)
    print("Group Vars: ", GROUP_VARS_PATH)
    print()

    print("#", "-" * 78)
    print("# Tool directories")
    print("#", "-" * 78)
    print_tools(tools)
    print()

    print("#", "-" * 78)
    print("# Build Dependency Tree")
    print("#", "-" * 78)
    print_dependency_tree(tool_tree)
    print()

    print("#", "-" * 78)
    print("# Build order")
    print("#", "-" * 78)
    print("\n".join(names))

    # Create group_vars file work.yml
    write_group_vars(names)


if __name__ == "__main__":
    main(sys.argv[1:])
