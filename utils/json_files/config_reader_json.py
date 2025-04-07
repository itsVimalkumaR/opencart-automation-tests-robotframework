import os
import json

# Construct the absolute path to config.json
CONFIG_FILE_PATH = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'configs', 'json_files',
                                'config.json')

# Load JSON configuration safely
try:
    with open(CONFIG_FILE_PATH, 'r', encoding='utf-8') as file:
        config = json.load(file)
except FileNotFoundError:
    print(f"[ERROR] config.json not found at: {CONFIG_FILE_PATH}")
    config = {}
except json.JSONDecodeError as e:
    print(f"[ERROR] Failed to parse JSON: {e}")
    config = {}


class ConfigReader:
    """Class to access configuration values from config.json"""

    # Environment
    @staticmethod
    def environment():
        return config.get('environment', {}).get('environment', 'Web')

    @staticmethod
    def browser():
        return config.get('environment', {}).get('browser', 'chrome')

    # Application
    @staticmethod
    def app_name():
        return config.get('application', {}).get('appName', 'OpenCart')

    # MySQL
    @staticmethod
    def mysql_config():
        return config.get('mysql', {})

    # MongoDB
    @staticmethod
    def mongodb_config():
        return config.get('mongodb', {})

    # REST API
    @staticmethod
    def base_url():
        return config.get('restApi', {}).get('baseUrl')

    @staticmethod
    def grant_type():
        return config.get('restApi', {}).get('grantType')

    # Users
    @staticmethod
    def register_url():
        return config.get('users', {}).get('signupUrl')

    @staticmethod
    def login_url():
        return config.get('users', {}).get('loginUrl')

    @staticmethod
    def login_email():
        return config.get('users', {}).get('emailAddress')

    @staticmethod
    def login_password():
        return config.get('users', {}).get('password')

    # Register Users
    @staticmethod
    def register_user_info():
        return config.get('registerUsers', {})

    # Content-Type
    @staticmethod
    def content_types():
        return config.get('contentType', {})


config_reader = ConfigReader()
