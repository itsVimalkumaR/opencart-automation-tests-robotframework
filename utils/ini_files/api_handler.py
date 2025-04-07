import os
from urllib.parse import urljoin

import requests
import random
import urllib3
import time
import datetime
from configparser import ConfigParser

from pymongo import MongoClient

# Custom library (ensure it's accessible)
from custom_library import TestRunManager

before_run = TestRunManager()  # Initialize before running update

# Disable SSL warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


class OpenCartAPI:
    def __init__(self):
        """Initialize configuration variables."""
        self.qa_base_url = None
        self.prod_base_url = None
        self.localhost_base_url = None
        self.mongodb_uri = None
        self.database_name = None
        self.collection_name = None
        self.set_password_url = None
        self.grant_type = None
        self.content_type = None
        self.form_data_content_type = None
        self.user_data = None

        self.reg_user = {}
        self.laundry_credentials = {}
        self.restaurant_credentials = {}
        self.api_endpoints = {}

        # Load configurations
        self.load_config()
        self.load_endpoints()

    def load_config(self):
        """Reads general configurations from 'config.ini'."""
        try:
            config_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'configs', 'ini_files','config.ini')
            config_path = os.path.abspath(config_path)  # Ensure absolute path
            print("Config file path : ", config_path)
            if not os.path.exists(config_path):
                raise FileNotFoundError(f"Config file not found: {config_path}")

            config = ConfigParser()

            # Force UTF-8 encoding to prevent decoding issues
            with open(config_path, 'r', encoding='utf-8') as config_file:
                config.read_file(config_file)

            # Base URLs
            self.qa_base_url = config.get('REST_API', 'qa_base_url', fallback=None)
            self.prod_base_url = config.get('REST_API', 'prod_base_url', fallback=None)
            self.localhost_base_url = config.get('REST_API', 'lh_base_url', fallback=None)

            # Database Configs
            self.mongodb_uri = config.get('MONGODB', 'mongodb_uri', fallback=None)
            self.database_name = config.get('MONGODB', 'database_name', fallback=None)
            self.collection_name = config.get('MONGODB', 'collection_name', fallback=None)

            # Auth & Content Type
            self.set_password_url = config.get('REST_API', 'qa_base_url', fallback=None)
            self.grant_type = config.get('REST_API', 'grant_type', fallback=None)
            self.content_type = config.get('CONTENT_TYPE', 'json', fallback=None)
            self.form_data_content_type = config.get('CONTENT_TYPE', 'form_data', fallback=None)

            # Registered User Info
            self.reg_user = {
                "username": config.get('REGISTER_USERS', 'username', fallback=None),
                "name": config.get('REGISTER_USERS', 'name', fallback=None),
                "business_name": config.get('REGISTER_USERS', 'organization_name', fallback=None),
                "dob": config.get('REGISTER_USERS', 'date_of_birth', fallback=None),
                "phone_number": config.get('REGISTER_USERS', 'phone_number', fallback=None),
                "address": config.get('REGISTER_USERS', 'address', fallback=None),
                "password": config.get('REGISTER_USERS', 'password', fallback=None),
                "email_id": config.get('REGISTER_USERS', 'email_id', fallback=None),
                "state": config.get('REGISTER_USERS', 'state', fallback=None),
                "country": config.get('REGISTER_USERS', 'country', fallback=None),
                "pincode": config.get('REGISTER_USERS', 'pincode', fallback=None),
            }

            self.user_data = {
                "user_name": config.get('REGISTER_USERS', 'username', fallback=None),
                "name": config.get('REGISTER_USERS', 'name', fallback=None),
                "organization_name": config.get('REGISTER_USERS', 'organization_name', fallback=None),
                "organization_arabic_name": config.get('REGISTER_USERS', 'organization_arabic_name', fallback=None),
                "email_id": config.get('REGISTER_USERS', 'email_id', fallback=None),
                "date_of_birth": config.get('REGISTER_USERS', 'date_of_birth', fallback=None),
                "phone_number": config.get('REGISTER_USERS', 'phone_number', fallback=None),
                "address_line_1": config.get('REGISTER_USERS', 'address', fallback=None),
                "organization_location": config.get('REGISTER_USERS', 'organization_location', fallback=None),
                "state": config.get('REGISTER_USERS', 'state', fallback=None),
                "country": config.get('REGISTER_USERS', 'country', fallback=None),
                "pincode": config.get('REGISTER_USERS', 'pincode', fallback=None),
                "business_type": config.get('REGISTER_USERS', 'business_type', fallback=None),
                "role": config.get('REGISTER_USERS', 'role', fallback=None),
                "filename": ""
            }
            print(self.user_data)
            # Credentials
            self.laundry_credentials = {
                "username": config.get('USERS', 'qa_laundry_username', fallback=None),
                "password": config.get('USERS', 'qa_laundry_password', fallback=None),
            }

            self.restaurant_credentials = {
                "username": config.get('USERS', 'qa_restaurant_username', fallback=None),
                "password": config.get('USERS', 'qa_restaurant_password', fallback=None),
            }

            if not self.qa_base_url:
                print("Base URL : ", self.qa_base_url)
                raise ValueError("Missing QA Base URL in config.")

            print("Config loaded successfully.")

        except FileNotFoundError as fnf_err:
            print(f"Config File Error: {fnf_err}")

        except UnicodeDecodeError as unicode_err:
            print(f"Encoding Error: {unicode_err} - Ensure config.ini is saved as UTF-8.")

        except Exception as e:
            print(f"Unexpected Error loading config: {e}")

    def load_endpoints(self):
        """Reads API endpoint URLs from 'config_end_url.ini'."""
        try:
            config_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'configs', 'ini_files', 'config_end_url.ini')
            config_path = os.path.abspath(config_path)  # Ensure absolute path
            print("Config file path : ", config_path)
            if not os.path.exists(config_path):
                raise FileNotFoundError(f"Config file not found: {config_path}")

            config = ConfigParser()

            # Force UTF-8 encoding to prevent decoding issues
            with open(config_path, "r", encoding="utf-8") as file:
                config.read_file(file)

            self.api_endpoints = {
                "POST": {
                    "login": config.get('API_POST', 'login_url', fallback=None),
                    "register": config.get('API_POST', 'register_url', fallback=None),
                    "shopping_cart": config.get('API_POST', 'shopping_cart_url', fallback=None),
                    "add_user": config.get('API_POST', 'add_user_url', fallback=None),
                    "send_email": config.get('API_POST', 'send_email_url', fallback=None),
                },
                "GET": {
                    "profile": config.get('API_GET', 'profile_url', fallback=None),
                    "get_categories_url": config.get('API_GET', 'get_categories_url', fallback=None),
                    "deleted_categories_url": config.get('API_GET', 'deleted_categories_url', fallback=None),
                    "get_products_url": config.get('API_GET', 'get_products_url', fallback=None),
                    "deleted_products_url": config.get('API_GET', 'products_url', fallback=None),
                    "customer": config.get('API_GET', 'customers_url', fallback=None),
                    "order": config.get('API_GET', 'orders_url', fallback=None),
                    "get_branches_url": config.get('API_GET', 'get_branches_url', fallback=None),
                    "deleted_branches_url": config.get('API_GET', 'deleted_branches_url', fallback=None),
                    "get_user": config.get('API_GET', 'users_url', fallback=None),
                    "shopping_cart": config.get('API_GET', 'shopping_carts_url', fallback=None),
                    "ledger": config.get('API_GET', 'ledgers_url', fallback=None),
                },
                "PUT": {
                    "set_password": config.get('API_PUT', 'set_password_url', fallback=None),
                }
            }

            if not self.api_endpoints["POST"]["login"]:
                raise ValueError("Missing Login Endpoint in config.")

            print("Config loaded successfully.")

        except FileNotFoundError as fnf_err:
            print(f"Config File Error: {fnf_err}")

        except UnicodeDecodeError as unicode_err:
            print(f"Encoding Error: {unicode_err} - Ensure config.ini is saved as UTF-8.")

        except Exception as e:
            print(f"Unexpected Error loading config: {e}")

    def post(self, end_url, username, password):
        try:
            # url = self.qa_base_url + end_url
            full_url = urljoin(self.qa_base_url, end_url)
            print("POST Request URL:", full_url)

            payload = {
                'user_name': username,
                'password': password
            }
            response = requests.post(full_url, data=payload, verify=False)

            if response is None:
                print("Error: No response received from server.")
                return None

            print("Response Status Code:", response.status_code)
            print("Response Content:", response.text)
            return response

        except requests.exceptions.SSLError as ssl_err:
            print("SSL Error occurred:", ssl_err)
            return None
        except Exception as e:
            print("An error occurred:", e)
            return None

    def get(self, end_url, headers=None):
        try:
            # url = self.qa_base_url + end_url
            full_url = urljoin(self.qa_base_url, end_url)
            print("GET Request URL:", full_url)
            headers = headers or {'Content-Type': self.content_type}
            response = requests.get(full_url, headers=headers, verify=False)
            print("Response:", response)
            return response
        except requests.exceptions.RequestException as e:
            print("Request Error:", e)
            return None

    def put(self, end_url, password):
        try:
            payload = {'password': password}
            # url = self.qa_base_url + end_url
            full_url = urljoin(self.qa_base_url, end_url)
            print("PUT Request URL:", full_url)
            response = requests.put(full_url, json=payload, verify=False)
            response.raise_for_status()
            data = response.json()
            assert "data updated successfully" == data.get("message", "")
            return response
        except requests.exceptions.SSLError as ssl_err:
            print("SSL Error occurred:", ssl_err)
            return None
        except requests.exceptions.RequestException as req_err:
            print("Request Error occurred:", req_err)
            return None
        except Exception as e:
            print("An unexpected error occurred:", e)
            return None

    def post_with_auth(self, end_url, user, password, access_token):
        try:
            payload = {"user_name": user, "password": password}
            headers = {"Content-Type": self.content_type, "Authorization": access_token}
            response = requests.post(end_url, json=payload, headers=headers, verify=False)  # Pass headers explicitly
            return response
        except Exception as e:
            print("Error in post_with_auth:", e)
            return None

    def get_with_auth(self, end_url, access_token):
        """ Sends a GET request with authentication headers. """
        try:
            headers = {"Content-Type": self.content_type, "Authorization": access_token}
            return self.get(end_url, headers)
        except Exception as e:
            print("Error in get_with_auth:", e)
            return None

    def post_api(self, end_url, payload, headers=None, files=None):
        """Send a POST request to the given endpoint with error handling."""
        try:
            url = self.qa_base_url + end_url
            headers = headers or {"Content-Type": self.content_type}

            print(f"POST Request to {url} with Payload: {payload}")
            response = requests.post(url, json=payload, headers=headers, files=files, verify=False)

            if response.ok:
                print(f"Success [{response.status_code}]: {response.text}")
            else:
                print(f"Error [{response.status_code}]: {response.text}")

            return response

        except requests.exceptions.RequestException as e:
            print("Request Error:", e)
            return None

    def update_username_in_db(self, old_username, new_username):
        """Update the new username in the database"""
        try:
            # Example API call to update username in the database
            update_url = self.qa_base_url + self.api_endpoints["POST"]["register"]
            payload = {"old_username": old_username, "new_username": new_username}
            headers = {"Content-Type": self.content_type}

            response = requests.post(update_url, json=payload, headers=headers, verify=False)

            if response.ok:
                print(f"Username successfully updated in DB: {old_username} → {new_username}")
                return True

            error_details = response.json().get("error", "Unknown error")
            print(f"Database update failed! Status: {response.status_code}, Error: {error_details}")

            return False
        except requests.exceptions.RequestException as e:
            print(f"Error updating DB: {e}")
            return False

    def retrieve_user_from_db(self, username):
        """Retrieves user details from MongoDB."""
        try:
            client = MongoClient(self.mongodb_uri)
            db = client[self.database_name]
            collection = db[self.collection_name]
            user_data = collection.find_one({"user_name": username})
            return user_data.get("user_name") if user_data else None
        except Exception as e:
            print(f"Error retrieving user: {e}")
            return None

    def login_api_credentials_pass(self, username, password):
        try:
            payload = {"user_name": username, "password": password}
            response = requests.post(self.qa_base_url + self.api_endpoints["POST"]["login"], json=payload, verify=False)
            if response.status_code != 200:
                print("Login failed.")
                return response.status_code, None

            data = response.json()
            token = data.get('token')
            print("Access Token:", token)
            return response.status_code, token
        except Exception as e:
            print(f"Error: {e}")
            return None, None

# Example Usage
if __name__ == "__main__":
    open_cart_api = OpenCartAPI()