#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Generate Ansible group_vars from tools (installed software) definition."""
import os
import re
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
DOC_FILE = str(os.path.join(REPOSITORY_PATH, "doc", "available-tools.md"))


PHP_VERSIONS = ["5.2", "5.3", "5.4", "5.5", "5.6", "7.0", "7.1", "7.2", "7.3", "7.4", "8.0", "8.1", "8.2"]

DEFAULT_TOOLS = [
    {
        "name": "**composer**",
        "dir": "../.ansible/group_vars/all/work-help.yml",
        "exclude": []
    },
    {
        "name": "**corepack**",
        "dir": "../.ansible/group_vars/all/work-help.yml",
        "exclude": []
    },
    {
        "name": "**nvm**",
        "dir": "../.ansible/group_vars/all/work-help.yml",
        "exclude": []
    },
    {
        "name": "**npm**",
        "dir": "../.ansible/group_vars/all/work-help.yml",
        "exclude": []
    },
    {
        "name": "**node**",
        "dir": "../.ansible/group_vars/all/work-help.yml",
        "exclude": []
    },
    {
        "name": "**yarn**",
        "dir": "../.ansible/group_vars/all/work-help.yml",
        "exclude": []
    },
    {
        "name": "**pip**",
        "dir": "../.ansible/group_vars/all/work-help.yml",
        "exclude": []
    }
]


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


def get_tools() -> List[Dict[str, Any]]:
    """Returns a list of PHP tools."""
    tools = []
    with os.scandir(PHP_TOOL_PATH) as it:
        for item in it:
            if not item.name.startswith(".") and item.is_dir():
                data = get_tool_options(item.name)
                tools.append(
                    {
                        "dir": "../php_tools/"+item.name,
                        "name": data["name"],
                        "exclude": [str(x) for x in data["exclude"]]
                    }
                )
    #return tools
    return sorted(DEFAULT_TOOLS + tools, key=lambda tool: tool["name"].replace("*", ""))


# --------------------------------------------------------------------------------------------------
# PRINT FUNCTIONS
# --------------------------------------------------------------------------------------------------


def print_terminal(tools: List[Dict[str, Any]]) -> None:
    """Print directory tools."""
    padding=15
    # First Row
    print('| {name: <{padding}}| '.format(name="Tool", padding=padding), end="")
    print(" | ".join(PHP_VERSIONS), end="")
    print(" |")
    # Second Row
    print('|{name:-<{padding}}-|'.format(name="", padding=padding), end="")
    for php in PHP_VERSIONS:
        print("-----|", end="")
    print()
    for tool in tools:
        print('| {name: <{padding}}|'.format(name=tool["name"], padding=padding), end="")
        for php in PHP_VERSIONS:
            if str(php) in tool["exclude"]:
                print("     |", end="")
            else:
                print("  ✓  |", end="")
        print()


def get_markdown(tools: List[Dict[str, Any]]) -> None:
    """Print directory tools."""
    padding = 35

    # First Row
    markdown = '| {name: <{padding}}| '.format(name="Tool", padding=padding)
    markdown += " | ".join(PHP_VERSIONS)
    markdown += " |\n"
    # Second Row
    markdown += '|{name:-<{padding}}-|'.format(name="", padding=padding)
    for php in PHP_VERSIONS:
        markdown += "-----|"
    markdown += "\n"
    for tool in tools:
        markdown += '| {name: <{padding}}|'.format(name="["+tool["name"]+"][lnk_"+tool["name"]+"]", padding=padding)
        for php in PHP_VERSIONS:
            if str(php) in tool["exclude"]:
                markdown += "     |"
            else:
                markdown += "  ✓  |"
        markdown += "\n"

    markdown += "\n"
    for tool in tools:
        markdown += "[lnk_"+tool["name"]+"]: "+tool["dir"]+"\n"

    return markdown



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
    tools = get_tools()

    print("#", "-" * 78)
    print("# Paths")
    print("#", "-" * 78)
    print("Repository: ", REPOSITORY_PATH)
    print("PHP Tools:  ", PHP_TOOL_PATH)
    print()

    print_terminal(tools)
    print()
    markdown = get_markdown(tools)
    print()

    with open(DOC_FILE, "r") as f:
        content = f.read()
    content_new = re.sub(r'(\<\!\-\- TOOLS_WORK_START \-\-\>)(.*)(\<\!\-\- TOOLS_WORK_END \-\-\>)', r"\1\n\n"+markdown+r"\n\3", content, flags = re.DOTALL)

    with open(DOC_FILE, "w") as f:
        f.write(content_new)

if __name__ == "__main__":
    main(sys.argv[1:])
