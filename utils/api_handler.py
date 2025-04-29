# ================================
# Standard Library Imports
# ================================
import os
import time
import re
import email
import random
import urllib3
import datetime
import imaplib
import requests
import email.utils
import logging
from urllib.parse import urljoin
from configparser import ConfigParser
from collections import defaultdict

# ================================
# Third-Party Library Imports
# ================================
from pymongo import MongoClient
from robot.api.deco import keyword

# ================================
# Custom Libraries
# ================================
from custom_library import TestRunManager
from env_loader import EnvConfigLoader

# ================================
# Initialization
# ================================
# Disable SSL warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Set up a logger (you can configure this globally in your project)
logger = logging.getLogger(__name__)

# Initialize .env config and test manager
env_config_loader = EnvConfigLoader()
before_run = TestRunManager()


# ================================
# Factory Method
# ================================
def create_pos_api_instance():
    """Factory method to create and return a PosAPI instance"""
    return OpenCartAPI()


class OpenCartAPI:
    def __init__(self):
        """Initialize configuration variables."""
        self.base_url = None
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
        self.login_credentials = {}
        self.restaurant_credentials = {}
        self.api_endpoints = {}

        # Load configurations
        self.load_config()
        self.load_endpoints()

    def load_config(self):
        """Reads general configurations from 'config.ini'."""
        try:
            config_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'configs', 'config.ini')
            config_path = os.path.abspath(config_path)  # Ensure absolute path
            print("Config file path : ", config_path)
            if not os.path.exists(config_path):
                raise FileNotFoundError(f"Config file not found: {config_path}")

            config = ConfigParser()

            # Force UTF-8 encoding to prevent decoding issues
            with open(config_path, 'r', encoding='utf-8') as config_file:
                config.read_file(config_file)

            # Base URLs
            self.base_url = config.get('rest_api', 'base_url', fallback=None)

            # Database Configs
            self.mongodb_uri = config.get('mongodb', 'uri', fallback=None)
            self.database_name = config.get('mongodb', 'database_name', fallback=None)
            self.collection_name = config.get('mongodb', 'collection_name', fallback=None)

            # Auth & Content Type
            self.grant_type = config.get('rest_api', 'grant_type', fallback=None)
            self.content_type = config.get('content_type', 'json', fallback=None)
            self.form_data_content_type = config.get('content_type', 'form_data', fallback=None)

            # Registered User Info
            self.reg_user = {
                "first_name": config.get('register_users', 'first_name', fallback=None),
                "last_name": config.get('register_users', 'last_name', fallback=None),
                "email": config.get('register_users', 'email', fallback=None),
                "telephone": config.get('register_users', 'telephone', fallback=None),
                "password": config.get('register_users', 'password', fallback=None),
                "password_confirm": config.get('register_users', 'password_confirm', fallback=None),
            }

            # self.user_data = {
            #     "user_name": config.get('register_users', 'email_address', fallback=None),
            #     "name": config.get('register_users', 'name', fallback=None),
            #     "organization_name": config.get('register_users', 'organization_name', fallback=None),
            #     "organization_arabic_name": config.get('register_users', 'organization_arabic_name', fallback=None),
            #     "email_id": config.get('register_users', 'email_id', fallback=None),
            #     "date_of_birth": config.get('register_users', 'date_of_birth', fallback=None),
            #     "phone_number": config.get('register_users', 'phone_number', fallback=None),
            #     "address_line_1": config.get('register_users', 'address', fallback=None),
            #     "organization_location": config.get('register_users', 'organization_location', fallback=None),
            #     "state": config.get('register_users', 'state', fallback=None),
            #     "country": config.get('register_users', 'country', fallback=None),
            #     "pincode": config.get('register_users', 'pincode', fallback=None),
            #     "business_type": config.get('register_users', 'business_type', fallback=None),
            #     "role": config.get('register_users', 'role', fallback=None),
            #     "filename": ""
            # }
            # print(self.user_data)

            # Credentials
            self.login_credentials = {
                "email_address": config.get('users', 'email_address', fallback=None),
                "password": config.get('users', 'password', fallback=None),
            }

            if not self.base_url:
                print("Base URL : ", self.base_url)
                raise ValueError("Missing Base URL in config.")

            print("Config loaded successfully.")

            # Return something meaningful
            return {
                "status_code": 200,
                "message": "Config loaded"
            }

        except FileNotFoundError as fnf_err:
            print(f"Config File Error: {fnf_err}")
            return str(fnf_err)

        except UnicodeDecodeError as unicode_err:
            print(f"Encoding Error: {unicode_err} - Ensure config.ini is saved as UTF-8.")
            return str(unicode_err)

        except Exception as e:
            print(f"Unexpected Error loading config: {e}")
            return str(e)

    def load_endpoints(self):
        """Reads API endpoint URLs from 'config_end_url.ini'."""
        try:
            config_path = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'configs', 'config_end_url.ini')
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

            # Return something meaningful
            return {
                "status_code": 200,
                "message": "Config End URL loaded"
            }


        except FileNotFoundError as fnf_err:
            print(f"Config File Error: {fnf_err}")
            return str(fnf_err)

        except UnicodeDecodeError as unicode_err:
            print(f"Encoding Error: {unicode_err} - Ensure config.ini is saved as UTF-8.")
            return str(unicode_err)

        except Exception as e:
            print(f"Unexpected Error loading config: {e}")
            return str(e)

    def post(self, end_url, email_address, password):
        try:
            # url = self.base_url + end_url
            full_url = urljoin(self.base_url, end_url)
            print("POST Request URL:", full_url)

            payload = {
                'user_name': email_address,
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
            # url = self.base_url + end_url
            full_url = urljoin(self.base_url, end_url)
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
            # url = self.base_url + end_url
            full_url = urljoin(self.base_url, end_url)
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
            url = self.base_url + end_url
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

    def update_email_address_in_db(self, old_email_address, new_email_address):
        """Update the new email_address in the database"""
        try:
            # Example API call to update email_address in the database
            update_url = self.base_url + self.api_endpoints["POST"]["register"]
            payload = {"old_email_address": old_email_address, "new_email_address": new_email_address}
            headers = {"Content-Type": self.content_type}

            response = requests.post(update_url, json=payload, headers=headers, verify=False)

            if response.ok:
                print(f"email_address successfully updated in DB: {old_email_address} → {new_email_address}")
                return True

            error_details = response.json().get("error", "Unknown error")
            print(f"Database update failed! Status: {response.status_code}, Error: {error_details}")

            return False
        except requests.exceptions.RequestException as e:
            print(f"Error updating DB: {e}")
            return False

    def retrieve_user_from_db(self, email_address):
        """Retrieves user details from MongoDB."""
        try:
            client = MongoClient(self.mongodb_uri)
            db = client[self.database_name]
            collection = db[self.collection_name]
            user_data = collection.find_one({"user_name": email_address})
            return user_data.get("user_name") if user_data else None
        except Exception as e:
            print(f"Error retrieving user: {e}")
            return None

    def login_api_credentials_pass(self, email_address, password):
        try:
            payload = {"user_name": email_address, "password": password}
            response = requests.post(self.base_url + self.api_endpoints["POST"]["login"], json=payload, verify=False)
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

    @keyword("Get Set password Link From Email")
    def get_set_password_link(self, email_addr, password, imap_server="imap.gmail.com",
                              expected_subject="Set your new password"):
        mail = None
        try:
            mail = imaplib.IMAP4_SSL(imap_server)
            mail.login(email_addr, password)
            mail.select("inbox")

            result, data = mail.search(None, '(FROM "noreply@imetanic.co")')
            email_ids = data[0].split()
            if not email_ids:
                return None

            emails_with_dates = []
            for eid in email_ids:
                result, msg_data = mail.fetch(eid, '(BODY[HEADER.FIELDS (DATE)])')
                raw_date = msg_data[0][1].decode().strip().replace('Date: ', '')
                email_date = email.utils.parsedate_to_datetime(raw_date)
                emails_with_dates.append((eid, email_date))

            sorted_emails = sorted(emails_with_dates, key=lambda x: x[1], reverse=True)

            for email_id, _ in sorted_emails:
                result, data = mail.fetch(email_id, '(RFC822)')
                raw_email = data[0][1]
                msg = email.message_from_bytes(raw_email)

                subject = msg.get("Subject", "").strip()
                if subject != expected_subject:
                    continue

                body = ""
                if msg.is_multipart():
                    for part in msg.walk():
                        if part.get_content_type() == "text/html":
                            body = part.get_payload(decode=True).decode()
                            break
                else:
                    body = msg.get_payload(decode=True).decode()

                match = re.search(r'https://demo\.imetanic\.com/imetanic/setpassword/[^\s"]+', body)
                if match:
                    set_password_link = match.group(0)
                    print(f"Latest valid Set password Link: {set_password_link}")
                    is_link_active = self.is_link_active(set_password_link)
                    assert is_link_active == True
                    return set_password_link

            return None

        except Exception as e:
            print(f"Error fetching email: {e}")
            return None
        finally:
            if mail:
                mail.logout()


# Example Usage
if __name__ == "__main__":
    open_cart_api = OpenCartAPI()
