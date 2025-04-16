import os
from configparser import ConfigParser

# Construct path to the config.ini file
base_dir = os.path.dirname(os.path.abspath(__file__))
CONFIG_FILE_PATH = os.path.join(base_dir, '..', '..', 'configs', 'ini_files', 'config.ini')
CONFIG_FILE_PATH = os.path.normpath(CONFIG_FILE_PATH)

print("CONFIG_FILE_PATH:", CONFIG_FILE_PATH)
print("File exists:", os.path.exists(CONFIG_FILE_PATH))

# Initialize ConfigParser
config = ConfigParser()

# Read the configuration file with fallback encoding
try:
    with open(CONFIG_FILE_PATH, 'r', encoding='utf-8') as file:
        config.read_file(file)
except UnicodeDecodeError:
    with open(CONFIG_FILE_PATH, 'r', encoding='latin1') as file:
        config.read_file(file)


class ConfigReader:
    """ Class to access configuration values from config.ini"""

    # Environment
    @staticmethod
    def environment():
        return config.get('environment', 'environment')

    @staticmethod
    def browser():
        return config.get('environment', 'browser')

    # REST API URL
    @staticmethod
    def base_url():
        return config.get('rest_api', 'base_url')

    # User URLs
    @staticmethod
    def url():
        return config.get('users', 'url')

    @staticmethod
    def register_url():
        return config.get('users', 'signup_url')

    @staticmethod
    def login_url():
        return config.get('users', 'login_url')

    # Credentials
    @staticmethod
    def login_email():
        return config.get('users', 'email_address')

    @staticmethod
    def login_password():
        return config.get('users', 'password')


config_reader = ConfigReader()
