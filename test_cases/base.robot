*** Settings ***
Library    BuiltIn
Library    Collections
Library    DateTime
Library    ImapLibrary
Library    JSONLibrary
Library    OperatingSystem
Library    Process
Library    RequestsLibrary
Library    SeleniumLibrary
Library    String

Library    ../utils/api_handler.py
Library    ../utils/env_loader.py

Variables  ../utils/api_handler.py
Variables  ../utils/config_parser.py
Variables  ../utils/config_reader.py
Variables  ../utils/custom_library.py

Resource    ../page_objects/common_keywords.resource
Resource    ../page_objects/config_parser_keywords.resource
Resource    ../page_objects/landing_page.resource
Resource    ../page_objects/page_title.resource
Resource    ../page_objects/python_integration.resource

Resource    ../page_objects/auth/RegisterTestsPO.robot