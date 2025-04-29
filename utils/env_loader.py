# utils/env_loader.py
import os
from dotenv import load_dotenv

class EnvConfigLoader:
    def __init__(self):
        # Load .env file from one directory above this file
        env_path = os.path.join(os.path.dirname(__file__), '..', '.env')
        load_dotenv(dotenv_path=env_path)

    @staticmethod
    def get_email_config():
        """Returns email and password as a dictionary"""
        return {
            "email": os.getenv("REGISTER_EMAIL"),
            "email_app_password": os.getenv("REGISTER_EMAIL_APP_PASSWORD")
        }

    @staticmethod
    def get_value_from_env(key: str, default=None):
        """Generic getter for any env variable"""
        return os.getenv(key, default)

    @property
    def email(self):
        return os.getenv("email")

    @property
    def email_password(self):
        return os.getenv("REGISTER_EMAIL_APP_PASSWORD")


if __name__ == "__main__":
    env_config_loader = EnvConfigLoader()
    # env_config_loader.get_email_config()

""" 
##  Example Usage in Python

from utils.env_loader import EnvConfigLoader

config_loader = EnvConfigLoader()

# Option 1: Access dictionary
email_config = config_loader.get_email_config()
print(email_config['email'])
print(email_config['email_password'])

# Option 2: Use properties
print(config_loader.email)
print(config_loader.email_password)

# Option 3: Generic
print(config_loader.get_value("MONGODB_URL"))

"""
