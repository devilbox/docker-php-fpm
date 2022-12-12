#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Generate Ansible group_vars from tools (installed software) definition."""
import os
import re
import sys
from typing import Dict, List, Any
import yaml


# --------------------------------------------------------------------------------------------------
# GLOBALS
# --------------------------------------------------------------------------------------------------

SCRIPT_PATH = str(os.path.dirname(os.path.realpath(__file__)))
REPOSITORY_PATH = str(os.path.dirname(SCRIPT_PATH))
PHP_TOOL_PATH = str(os.path.join(REPOSITORY_PATH, "php_tools"))
DOC_FILE = str(os.path.join(REPOSITORY_PATH, "doc", "available-tools.md"))


PHP_VERSIONS = [
    "5.2",
    "5.3",
    "5.4",
    "5.5",
    "5.6",
    "7.0",
    "7.1",
    "7.2",
    "7.3",
    "7.4",
    "8.0",
    "8.1",
    "8.2",
]

DEFAULT_TOOLS = [
    {"name": "**composer**", "dir": "https://getcomposer.org/", "exclude": []},
    {"name": "**corepack**", "dir": "https://nodejs.org/api/corepack.html", "exclude": []},
    {"name": "**nvm**", "dir": "https://github.com/nvm-sh/nvm", "exclude": []},
    {
        "name": "**npm**",
        "dir": "https://nodejs.org/en/knowledge/getting-started/npm/what-is-npm/",
        "exclude": [],
    },
    {"name": "**node**", "dir": "https://nodejs.org/en/", "exclude": []},
    {"name": "**yarn**", "dir": "https://yarnpkg.com/cli/install", "exclude": []},
    {"name": "**pip**", "dir": "https://pypi.org/", "exclude": []},
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
                        "dir": "../php_tools/" + item.name,
                        "name": data["name"],
                        "exclude": [str(x) for x in data["exclude"]],
                    }
                )
    return sorted(DEFAULT_TOOLS + tools, key=lambda tool: tool["name"].replace("*", ""))


# --------------------------------------------------------------------------------------------------
# PRINT FUNCTIONS
# --------------------------------------------------------------------------------------------------


def print_terminal(tools: List[Dict[str, Any]]) -> None:
    """Print directory tools."""
    padding = 18
    # First Row
    print("| {name: <{padding}}| ".format(name="Tool", padding=padding), end="")
    print(" | ".join(PHP_VERSIONS), end="")
    print(" |")
    # Second Row
    print("|{name:-<{padding}}-|".format(name="", padding=padding), end="")
    for php in PHP_VERSIONS:
        print("-----|", end="")
    print()
    for tool in tools:
        print("| {name: <{padding}}|".format(name=tool["name"], padding=padding), end="")
        for php in PHP_VERSIONS:
            if str(php) in tool["exclude"]:
                print("     |", end="")
            else:
                print("  ✓  |", end="")
        print()


def get_markdown(tools: List[Dict[str, Any]]) -> str:
    """Get markdown tools table."""
    padding = 43

    # First Row
    markdown = "| {name: <{padding}}| PHP ".format(name="Tool", padding=padding)
    markdown += " | PHP ".join(PHP_VERSIONS)
    markdown += " |\n"
    # Second Row
    markdown += "|{name:-<{padding}}-|".format(name="", padding=padding)
    for php in PHP_VERSIONS:
        markdown += "---------|"
    markdown += "\n"
    for tool in tools:
        markdown += "| {name: <{padding}}|".format(
            name="[" + tool["name"] + "][lnk_" + tool["name"] + "]", padding=padding
        )
        for php in PHP_VERSIONS:
            if str(php) in tool["exclude"]:
                markdown += "         |"
            else:
                markdown += "    ✓    |"
        markdown += "\n"

    markdown += "\n"
    for tool in tools:
        markdown += "[lnk_" + tool["name"] + "]: " + tool["dir"] + "\n"

    return markdown


# --------------------------------------------------------------------------------------------------
# MAIN FUNCTION
# --------------------------------------------------------------------------------------------------


def main() -> None:
    """Main entrypoint."""
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

    with open(DOC_FILE, "r", encoding="utf8") as f:
        content = f.read()
    content_new = re.sub(
        r"(\<\!\-\- TOOLS_WORK_START \-\-\>)(.*)(\<\!\-\- TOOLS_WORK_END \-\-\>)",
        r"\1\n\n" + markdown + r"\n\3",
        content,
        flags=re.DOTALL,
    )

    with open(DOC_FILE, "w", encoding="utf8") as f:
        f.write(content_new)


if __name__ == "__main__":
    main()
