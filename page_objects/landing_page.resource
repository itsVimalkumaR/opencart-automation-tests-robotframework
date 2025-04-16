*** Settings ***
Documentation       Keywords for POS Application Login and Navigation
Library             SeleniumLibrary
Library             OperatingSystem
Library             DateTime
Library             String
Library             Collections
Library             RequestsLibrary
Library             BuiltIn
Resource            ../page_objects/common_keywords.resource
Resource            ../page_objects/api_integration.resource
Variables           ../utils/ini_files/config_reader.py
Variables           ../utils/ini_files/custom_library.py


*** Keywords ***
Setup Test Environment
    [Documentation]     Initializes the test environment
    ...                 @Author = VIMALKUMAR M
    Set Global Variable    ${test_manager}    ${TestRunManager()}


Login To User Application
    [Documentation]     Launches browser and logs in to the application
    ...                 @Author = VIMALKUMAR M
    Launch Browser
    Login To Application


Launch Browser
    [Documentation]     Opens and maximizes browser window
    ...                 @Author = VIMALKUMAR M
    ${browser}=         Call Method            ${config_reader}    browser
    Open Browser        about:blank            ${browser}
    Maximize Browser Window
#    Set Window Size     1440                   900


Open Registration Page
    [Documentation]
    Navigate To Landing Page
    Click Element Until Visible     ${locators_params.main_page.menu.my_account.dropdown}
    Click Element Until Visible     ${locators_params['main_page']['header']}[register_link]
#    Click Element Until Visible     ${locators_params['main_page']['header']}[my_account_menu]
    Title Should Be     ${TEST_DATA['page_titles']}[register]


Navigate To Lan    ding Page
    [Documentation]     Navigates to the Landing page of the OpenCart application
    ...                 @Author = VIMALKUMAR M
    Launch Browser
    Set Selenium Timeout            20 seconds
    Set Selenium Implicit Wait     20 seconds
    Log To Console                 Running POS Laundry...

    ${environment}=     Call Method            ${config_reader}    environment
    ${landing_url}=        Call Method            ${config_reader}    url

    Go To               ${landing_url}
    Sleep               5s
    Capture The Screen  Landing_Page

Close Toast Message
    [Documentation]     Closes any visible toast message
    ...                 @Author = VIMALKUMAR M
    Click Element       xpath=//button[contains(@class,'p-toast-icon-close')]


Close All Browsers
    [Documentation]     Closes all open browser windows
    ...                 @Author = VIMALKUMAR M
    Close All Browsers


Open New Browser Tab
    [Documentation]     Opens a new tab and navigates to the given URL
    ...                 @Author = VIMALKUMAR M
    [Arguments]         ${url}
    Execute Javascript  window.open('${url}');
    Sleep               5s

    @{handles}=         Get Window Handles
    Switch Window       ${handles}[1]
    Capture The Screen  New_Tab



 ###################
Login To Application
    [Documentation]     Logs in using provided credentials
    ...                 @Author = VIMALKUMAR M
    Set Selenium Timeout            20 seconds
    Set Selenium Implicit Wait     20 seconds
    Log To Console                 Running POS Laundry...

    ${base_url}=        Call Method            ${config_reader}    qa_base_url
    ${login_url}=       Call Method            ${config_reader}    login_url

    Go To               ${login_url}
    Sleep               5s
    Verify Title Of Login Page

    ${username}=        Call Method            ${config_reader}    qa_laundry_username
    Click And Input Value    ${locators_params_params['Login']}[Username_Txtbox]    ${username}

    ${password}=        Call Method            ${config_reader}    qa_laundry_password
    Click And Input Value    ${locators_params_params['Login']}[Password_Txtbox]    ${password}

    Wait Until Page Contains      Login
    Sleep                         1s
    Click Element Until Enabled   ${locators_params_params['Login']}[Login_Btn]
    Sleep                         15s

    Capture The Screen            SignIn_Page
    Verify Title Of Home Page
    Wait Until Element Is Visible    ${locators_params_params['Home']}[HomePage_Header]


Navigate To Signup Page
    [Documentation]     Navigates to the signup page of the POS Laundry application
    ...                 @Author = VIMALKUMAR M
    Launch Browser
    Set Selenium Timeout            20 seconds
    Set Selenium Implicit Wait     20 seconds
    Log To Console                 Running POS Laundry...

    ${base_url}=        Call Method            ${config_reader}    base_url
    ${signup_url}=      Call Method            ${config_reader}    sign_url

    Go To               ${signup_url}
    Sleep               5s
    Capture The Screen  Signup_Page
    Verify Title Of Signup Page


Logout From Application
    [Documentation]     Logs out the user from the application
    ...                 @Author = VIMALKUMAR M
    Wait Until Element Is Visible    ${locators_params_params['Home']['Profile']}[Dropdown_Btn]
    Click Element Until Visible      ${locators_params_params['Home']['Profile']}[Dropdown_Btn]
    Capture The Screen               Logout_Button

    Wait Until Element Is Visible    ${locators_params_params['Home']['Profile']}[Logout_Btn]
    Click Element Until Visible      ${locators_params_params['Home']['Profile']}[Logout_Btn]
    Sleep                            3s

    Wait Until Element Is Visible    ${locators_params_params['Login']}[Login_Btn]
    Element Should Be Disabled       ${locators_params_params['Login']}[Login_Btn]
    Capture The Screen               LogoutSuccessfully