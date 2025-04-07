import os
import json
import random
import string
from datetime import datetime
import mysql.connector
import pyautogui
import pandas as pd


class TestRunManager:
    def __init__(self):
        """Initialize configuration variables and read config.json."""
        self.config_file = os.path.join(os.path.dirname(os.path.realpath(__file__)), '..', 'configs', 'json_files', 'config.json')
        self.connection = None
        self.cursor = None
        self.database_config = {}
        self.read_config()

        # Assign database variables
        mysql_config = self.database_config
        self.database_username = mysql_config.get("username")
        self.database_password = mysql_config.get("password")
        self.database_host = mysql_config.get("host")
        self.database_port = mysql_config.get("port", 3306)
        self.database_name = mysql_config.get("database")
        self.execution_status_start = mysql_config.get("executionStatusStart", "STARTED")
        self.execution_status_end = mysql_config.get("executionStatusEnd", "COMPLETED")

    def read_config(self):
        """Reads configuration from config.json file."""
        if not os.path.exists(self.config_file):
            print(f"Config file not found: {self.config_file}")
            return

        try:
            with open(self.config_file, 'r', encoding='utf-8') as file:
                config_data = json.load(file)
                self.database_config = config_data.get("mysql", {})

                if not self.database_config:
                    print("Error: 'mysql' section not found in config.json")
                else:
                    print("Database Config Loaded:", self.database_config)

        except Exception as e:
            print(f"Error reading config file: {e}")

    def connect_db(self):
        """Establish a database connection."""
        if not all([self.database_username, self.database_password, self.database_host, self.database_name]):
            print("Database credentials are missing.")
            return False

        try:
            self.connection = mysql.connector.connect(
                user=self.database_username,
                password=self.database_password,
                host=self.database_host,
                port=int(self.database_port),
                database=self.database_name,
                auth_plugin="mysql_native_password"
            )
            self.cursor = self.connection.cursor()
            print("Database connection successful.")
            self.ensure_tables_exist()
            return True

        except mysql.connector.Error as err:
            print(f"Database connection failed: {err}")
            return False

    def ensure_tables_exist(self):
        """Check if required tables exist; create them if they don't."""

        tables = {
            "test_execution_reports": """
                CREATE TABLE IF NOT EXISTS test_execution_reports (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    name VARCHAR(255),
                    execution_start_time DATETIME,
                    execution_end_time DATETIME NULL,
                    execution_status VARCHAR(50)
                )
            """,
            "users": """
                CREATE TABLE IF NOT EXISTS user_data (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    business_name VARCHAR(255),
                    username VARCHAR(255),
                    password VARCHAR(255),
                    email VARCHAR(255)
                )
            """
        }

        try:
            for table_name, create_query in tables.items():
                self.cursor.execute(f"SHOW TABLES LIKE '{table_name}'")
                result = self.cursor.fetchone()

                if not result:
                    print(f"Table '{table_name}' not found. Creating...")
                    self.cursor.execute(create_query)
                    self.connection.commit()
                    print(f"Table '{table_name}' created successfully.")
                else:
                    print(f"Table '{table_name}' already exists.")

        except mysql.connector.Error as err:
            print(f"Error ensuring tables exist: {err}")

    def insert_start_time(self):
        """Insert test Execution Start Time into database."""

        if not self.connect_db():
            print("Skipping database insertion due to connection failure.")
            return

        current_timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        try:
            sql = "INSERT INTO test_execution_reports (Name, execution_start_time, execution_status) VALUES (%s, %s, %s)"
            self.cursor.execute(sql, ('POS', current_timestamp, self.execution_status_start))
            self.connection.commit()
            print("Start time inserted successfully.")

        except Exception as e:
            print(f"Error inserting start time: {e}")

    def update_end_time(self):
        """Update test Execution End Time in the database."""

        if not self.connect_db():
            print("Skipping database update due to connection failure.")
            return

        current_timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        try:
            self.cursor.execute("SELECT id FROM test_execution_reports ORDER BY id DESC LIMIT 1")
            last_id = self.cursor.fetchone()

            if not last_id:
                print("No previous test reports found to update.")
                return

            sql = "UPDATE test_execution_reports SET execution_end_time = %s, execution_status = %s WHERE id = %s"
            self.cursor.execute(sql, (current_timestamp, self.execution_status_end, last_id[0]))
            self.connection.commit()
            print("End time updated successfully.")

        except Exception as e:
            print(f"Error updating end time: {e}")

    @staticmethod
    def zoom_in():
        for _ in range(2):
            pyautogui.hotkey('ctrl', '+')

    @staticmethod
    def zoom_out():
        for _ in range(2):
            pyautogui.hotkey('ctrl', '-')

    @staticmethod
    def generate_random_email():
        """Generate a random email address."""

        return f"{''.join(random.choices(string.ascii_letters + string.digits, k=10))}@example.com"

    @staticmethod
    def generate_random_string_without_special_chars():
        """Generate a random string without special characters."""

        return "".join(random.choices(string.ascii_letters, k=10))

    @staticmethod
    def generate_random_string_with_special_chars():
        """Generate a secure random password with special characters."""

        characters = string.ascii_letters + string.digits + "!@#$&*?"
        return "".join(random.choices(characters, k=10))

    @staticmethod
    def save_user_data_to_excel(username="tester", password="&lackMan123!", business_name="Demo"):
        """Saves user data to an Excel file."""

        file_path = '../utils/user_data.xlsx'
        new_entry = {'Business Name': business_name, 'Username': username, 'Password': password}

        try:
            df = pd.read_excel(file_path, engine='openpyxl')
        except FileNotFoundError:
            df = pd.DataFrame(columns=['Business Name', 'Username', 'Password'])

        df = pd.concat([df, pd.DataFrame([new_entry])], ignore_index=True)
        df.to_excel(file_path, index=False, engine='openpyxl')
        print("User data saved successfully")

        return "User data saved successfully"

    @staticmethod
    def generate_random_string(length=10, special_chars=False):
        """Generate a random string with a specified length and optional special characters."""

        chars = string.ascii_letters + string.digits + ("!@#$&*?" if special_chars else "")

        while True:
            random_string = ''.join(random.choices(chars, k=length))

            if not special_chars or any(c in "!@#$&*?" for c in random_string):
                return random_string

    @staticmethod
    def generate_unique_username(base_name, length=6):
        """Generate a random username by appending a random string."""

        random_suffix = ''.join(random.choices(string.digits, k=length))
        return f"{base_name}_{random_suffix}"

    def store_user_data(self, username="tester", password="&lackMan123!", business_name="Demo", email="demo@gmail.com"):
        """Saves user data to the database."""

        if not self.connect_db():
            print("Skipping database insertion due to connection failure.")
            return

        try:
            # Hash the password before storing
            # hashed_password = bcrypt.hashpw(password.encode('utf-8'),bcrypt.gensalt()).decode('utf-8')

            sql = "INSERT INTO user_data (business_name, username, password, email) VALUES (%s, %s, %s, %s)"
            self.cursor.execute(sql, (business_name, username, password, email))
            self.connection.commit()
            print("User data saved successfully to database with encrypted password.")

        except Exception as e:
            print(f"Error inserting user data: {e}")


# Initialize and test the class
if __name__ == "__main__":
    test_manager = TestRunManager()
    # test_manager.insert_start_time()
    # test_manager.update_end_time()
    # test_manager.store_user_data()
    # test_manager.zoom_in()
    # test_manager.zoom_out()
    # test_manager.generate_random_string()
    # test_manager.generate_random_email()
    # test_manager.generate_random_string_with_special_chars()
    # test_manager.generate_random_string_without_special_chars()
    # test_manager.generate_unique_username()
    # test_manager.save_user_data_to_excel()
    # test_manager.store_user_data()