import os
import yaml
from typing import Dict, Any


def parse_yaml(file_path: str) -> dict[Any, Any] | None:
    """
    Safely parses a YAML file and returns its content as a dictionary.

    Args:
        file_path (str): Absolute or relative path to the YAMl file.

    Returns:
        Dict[str, Any]: Parsed YAMl content or an empty dictionary on failure.
    """
    if not os.path.isfile(file_path):
        print(f"[ERROR] YAML file not found: {file_path}")
        return {}

    try:
        print(f"[INFO] Current working directory: {os.getcwd()}")
        print(f"[INFO] Reading YAML file: {file_path}")

        with open(file_path, 'r', encoding='utf-8') as file:
            content = yaml.safe_load(file) or {}

        print(f"[SUCCESS] YAML file content parsed successfully.")
        return content

    except yaml.YAMLError as yaml_error:
        print(f"[ERROR] Failed to parse YAML file content: {yaml_error}")

    except Exception as error:
        print(f"[ERROR] Unexpected error occurred: {error}")

    return {}