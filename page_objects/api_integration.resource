*** Settings ***
Documentation        API-related reusable keywords

# Import Libraries
Library              RequestsLibrary
Library              SeleniumLibrary
Library              Collections
Library              OperatingSystem
Library              DateTime
Library              BuiltIn
Library              String
Library              JSONLibrary

# Import Variables (Python Files)
Variables            ../utils/config_parser.py
Variables            ../utils/ini_files/config_reader.py
Variables            ../utils/ini_files/custom_library.py
Variables            ../utils/ini_files/api_handler.py

# Import Resource Files (Robot Files)
Resource             ../test_cases/base.robot
Resource             ../page_objects/config_parser_keywords.resource
Resource             ../page_objects/api_integration.resource
Resource             ../page_objects/landing_page.resource


*** Keywords ***

Execution Start Time
    [Documentation]     Logs the start time of the execution
    ${start_time}=       Call Method                      ${test_manager}       insert_start_time
    Log                  Execution started at:            ${start_time}

Execution End Time
    [Documentation]     Logs the end time of the execution
    ${end_time}=         Call Method                      ${test_manager}       update_end_time
    Log                  Execution ended at:              ${end_time}

Call Config Reader API
    [Documentation]     Reads configuration for login user
    ${response}=         Call Method                      ${pos_api}            load_config
    Log                  Config Reader Response:          ${response}

Call Endpoint Config API
    [Documentation]     Loads API endpoints configuration
    ${response}=         Call Method                      ${pos_api}            load_endpoints
    Log                  API End URL Response:            ${response}

Call User Login API
    [Documentation]     Calls the API to authenticate the user
    ${response}=         Call Method                      ${pos_api}            login_api
    Log                  User Login POST API Response:    ${response}

    ${status_code}=      Convert To String                ${response}[status_code]
    Should Be Equal      ${status_code}                   200

    ${username}=         Set Variable                     ${response}[user_name]
    RETURN               ${username}

Zoom In Page
    [Documentation]     Zooms into the webpage
    ${response}=         Call Method                      ${test_manager}       zoom_in
    Log                  Zoom In Response:                ${response}

Zoom Out Page
    [Documentation]     Zooms out of the webpage
    ${response}=         Call Method                      ${test_manager}       zoom_out
    Log                  Zoom Out Response:               ${response}

Generate Random Email
    [Documentation]     Generates a random email ID
    ${email}=            Call Method                      ${test_manager}       generate_random_email
    Log                  Generated Email:                 ${email}
    RETURN               ${email}

Save User Credentials To Excel
    [Documentation]     Saves new user credentials to an Excel file
    [Arguments]          ${username}    ${password}       ${business_name}
    ${response}=         Call Method                      ${test_manager}       save_user_data_to_excel
                         ...                              ${username}           ${password}            ${business_name}
    Log                  User Credential Save Response:   ${response}
    RETURN               ${response}

Generate Random String Without Special Characters
    [Documentation]     Generates a random string without special characters
    ${response}=         Call Method                      ${test_manager}       generate_random_string_without_special_chars
    Log                  Generated Random String:         ${response}
    RETURN               ${response}

Generate Random String With Special Characters
    [Documentation]     Generates a random string with special characters
    ${response}=         Call Method                      ${test_manager}       generate_random_string_with_special_chars
    Log                  Generated Random String:         ${response}
    RETURN               ${response}