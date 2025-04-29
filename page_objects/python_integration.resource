*** Settings ***
Documentation        API-related reusable keywords

Library              RequestsLibrary
Library              SeleniumLibrary
Library              Collections
Library              OperatingSystem
Library              DateTime
Library              BuiltIn
Library              String
Library              JSONLibrary

Variables            ../utils/config_parser.py
Variables            ../utils/config_reader.py
Variables            ../utils/custom_library.py
Variables            ../utils/api_handler.py
Variables            ../utils/env_loader.py

Resource             ../test_cases/base.robot
Resource             ../page_objects/common_keywords.resource
Resource             ../page_objects/config_parser_keywords.resource
Resource             ../page_objects/landing_page.resource


*** Keywords ***

Execution Start Time
    [Documentation]      Logs the start time of the test execution in the database
    ${start_time}       Call Method                      ${test_manager}        insert_start_time
    Log                 Execution started at:            ${start_time}

Execution End Time
    [Documentation]      Logs the end time of the test execution in the database
    ${end_time}         Call Method                      ${test_manager}        update_end_time
    Log                 Execution ended at:              ${end_time}

Call Config Reader API
    [Documentation]      Loads general configuration values such as credentials or environment settings
    ${response}         Call Method                      ${open_cart_api}       load_config
    Log                 Config Reader Response:          ${response}

Call Endpoint Config API
    [Documentation]      Loads endpoint URL configurations from the defined config file
    ${response}         Call Method                      ${open_cart_api}       load_endpoints
    Log                 API End URL Response:            ${response}

Call User Login API
    [Documentation]      Sends a POST request to authenticate user and validates successful login
    ${response}         Call Method                      ${open_cart_api}       login_api
    Log                 User Login POST API Response:    ${response}

    ${status_code}      Convert To String                ${response}[status_code]
    Should Be Equal     ${status_code}                   200

    ${username}         Set Variable                     ${response}[user_name]
    RETURN              ${username}

Use Email Config Dictionary
    [Documentation]      Fetches email and app password from the environment file using utility function
    ${creds}            Call Method                      ${env_config_loader}    get_email_config
    Log                 ${creds['email']}
    Log                 ${creds['email_app_password']}
    RETURN              ${creds['email']}                ${creds['email_app_password']}

Get Env File Value
    [Documentation]      Returns the value of a specific environment variable by key
    [Arguments]         ${key_name}
    ${value}            Call Method                      ${env_config_loader}    get_value_from_env    ${key_name}
    Log                 ${value}
    RETURN              ${value}

Save User Credential In Excel File
    [Documentation]      Saves the newly registered user credentials to an Excel file
    [Arguments]         ${firstname}    ${lastname}    ${email}    ${telephone}    ${password}    ${confirm_password}    ${excel_path}
    ${response}         Call Method                      ${test_manager}    save_user_data_to_excel
    ...                 ${firstname}    ${lastname}    ${email}    ${telephone}    ${password}    ${confirm_password}    ${excel_path}
    Log                 User Credential Save Response: ${response}    INFO

Save User Credential In DB
    [Documentation]      Saves user credentials to MySQL DB. Logs error and fails if DB insertion fails.
    [Arguments]         ${firstname}    ${lastname}    ${email}    ${telephone}    ${password}    ${confirm_password}
    ${result}=          Call Method                      ${test_manager}    save_user_data_to_db
    ...                 ${firstname}    ${lastname}    ${email}    ${telephone}    ${password}    ${confirm_password}
    Log                 ${result['message']}
    Run Keyword If      '${result["success"]}' == 'False'    Fail    ${result['message']}

Zoom In Page
    [Documentation]      Zooms in the browser window using browser-based commands
    ${response}         Call Method                      ${test_manager}        zoom_in
    Log                 Zoom In Response:                ${response}

Zoom Out Page
    [Documentation]      Zooms out the browser window using browser-based commands
    ${response}         Call Method                      ${test_manager}        zoom_out
    Log                 Zoom Out Response:               ${response}

Generate Random Email
    [Documentation]      Generates a unique random email address for test users
    ${email}            Call Method                      ${test_manager}        generate_random_email
    Log                 Generated Email:                 ${email}
    RETURN              ${email}

Generate Random String Without Special Characters
    [Documentation]      Generates a random string using only alphanumeric characters
    ${response}         Call Method                      ${test_manager}        generate_random_string_without_special_chars
    Log                 Generated Random String:         ${response}
    RETURN              ${response}

Generate Random String With Special Characters
    [Documentation]      Generates a random string including special characters
    ${response}         Call Method                      ${test_manager}        generate_random_string_with_special_chars
    Log                 Generated Random String:         ${response}
    RETURN              ${response}