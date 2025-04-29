import json
import os

import urllib3

# Custom library (ensure it's accessible)
from utils.ini_files.custom_library import TestRunManager

before_run = TestRunManager()
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


class PosAPI:
    def __init__(self):
        self.base_url = None
        self.mongodb_uri = None
        self.database_name = None
        self.collection_name = None
        self.set_password_url = None
        self.grant_type = None
        self.content_type = None
        self.form_data_content_type = None

        self.reg_user = {}
        self.user_data = {}
        self.laundry_credentials = {}
        self.restaurant_credentials = {}
        self.api_endpoints = {}

        self.load_config_json()
        self.load_endpoints_json()

    def load_config_json(self):
        try:
            config_path = os.path.abspath(
                os.path.join(os.path.dirname(__file__), '..', 'configs', 'json_files', 'config.json'))
            with open(config_path, 'r', encoding='utf-8') as f:
                config = json.load(f)

            # Set base URL
            self.base_url = config["restApi"].get("baseUrl")

            # MongoDB
            self.mongodb_uri = config["mongodb"].get("uri")
            self.database_name = config["mongodb"].get("databaseName")
            self.collection_name = config["mongodb"].get("collectionName")

            # Content Types
            self.grant_type = config["restApi"].get("grantType")
            self.content_type = config["contentType"].get("json")
            self.form_data_content_type = config["contentType"].get("formData")

            # Registered user data
            self.reg_user = config["registerUsers"]

            # Setup user_data (extended info if needed)
            self.user_data = {
                "user_name": self.reg_user["firstName"],
                "name": f"{self.reg_user['firstName']} {self.reg_user['lastName']}",
                "organization_name": "TestOrg",
                "organization_arabic_name": "اختبار",
                "email_id": self.reg_user["email"],
                "date_of_birth": "1990-01-01",
                "phone_number": self.reg_user["telephone"],
                "address_line_1": "123 Test Lane",
                "organization_location": "City Center",
                "state": "TestState",
                "country": "TestCountry",
                "pincode": "123456",
                "business_type": "Retail",
                "role": "Admin",
                "filename": ""
            }

            # Credentials for QA testing
            self.laundry_credentials = {
                "username": config["users"]["emailAddress"],
                "password": config["users"]["password"]
            }
            self.restaurant_credentials = self.laundry_credentials.copy()

            print("Config JSON loaded successfully.")

        except Exception as e:
            print(f"Error loading config.json: {e}")

    def load_endpoints_json(self):
        try:
            endpoints_path = os.path.abspath(
                os.path.join(os.path.dirname(__file__), '..', 'configs', 'json_files', 'config_end_url.json'))
            with open(endpoints_path, 'r', encoding='utf-8') as f:
                endpoints = json.load(f)

            self.api_endpoints = {
                "POST": endpoints["apiPost"],
                "GET": endpoints["apiGet"],
                "PUT": endpoints["apiPut"],
                "DELETE": endpoints["apiDelete"]
            }

            print("Endpoint JSON loaded successfully.")

        except Exception as e:
            print(f"Error loading config_end_url.json: {e}")
