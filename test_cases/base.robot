*** Settings ***
#Suite Setup    Set Project Root Directory

# Import Libraries
Library     SeleniumLibrary
Library     BuiltIn
Library     OperatingSystem

# Import Resource Files (Robot/Resource Files)
Resource    ../page_objects/api_integration.resource
Resource    ../page_objects/common_keywords.resource
Resource    ../page_objects/config_parser_keywords.resource
Resource    ../page_objects/landing_page.resource

# Import Variables (Python Files)