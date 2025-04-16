*** Settings ***
Documentation     Parses network topology and test configurations for execution
Library           String
Library           OperatingSystem
Library           ../utils/config_parser.py
Variables         ../utils/ini_files/config_reader.py
Resource          ../test_cases/base.robot

*** Keywords ***
Set Project Root Directory
    [Documentation]      Set the root directory path for project execution
    ...                  @Author = VIMALKUMAR M
    [Tags]               setup
    ${project_name}      Set Variable         opencart-automation-tests-robotframework
    ${base_dir}          Fetch From Left      ${CURDIR}    ${project_name}
    ${root_dir}          Set Variable         ${base_dir}${/}${project_name}
    Set Suite Variable   ${root_dir}          ${root_dir}
    Set Global Variable  ${root_dir}          ${root_dir}

Parse locators Config
    [Documentation]      Parse UI locators from YAML configuration file
    ...                  @Author = VIMALKUMAR M
    [Tags]               configuration
    Set Log Level        NONE
    ${locators_params}          Parse YAML           ${root_dir}${/}configs${/}locators.yaml
    Set Log Level        INFO
    Set Suite Variable   ${locators_params}          ${locators_params}
    Log                  ${locators_params}

Parse Test Data Config
    [Documentation]      Parse test data parameters from YAML configuration file
    ...                  @Author = VIMALKUMAR M
    [Tags]               configuration
    Set Log Level        NONE
    ${test_data}         Parse YAML           ${root_dir}${/}configs${/}test_data.yaml
    Set Log Level        INFO
    Set Suite Variable   ${test_data}         ${test_data}
    Log                  ${test_data}