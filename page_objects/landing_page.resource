*** Settings ***
Documentation       Keywords for POS Application Login and Navigation
Library             SeleniumLibrary
Library             OperatingSystem
Library             DateTime
Library             String
Library             Collections
Library             RequestsLibrary
Library             BuiltIn
Library             ../utils/api_handler.py

Variables           ../utils/config_reader.py
Variables           ../utils/custom_library.py

Resource            ../page_objects/python_integration.resource
Resource            ../page_objects/common_keywords.resource
Resource            ../page_objects/config_parser_keywords.resource
Resource            ../page_objects/landing_page.resource
Resource            ../test_cases/base.robot


*** Keywords ***
Setup Test Environment
    [Documentation]     Initializes the test environment
    ...                 @Author = VIMALKUMAR M
    Set Global Variable    ${env_config_loader}    ${EnvConfigLoader()}
    Set Global Variable    ${test_manager}         ${TestRunManager()}
    Set Global Variable    ${open_cart_api}        ${OpenCartAPI()}

Login To User Application
    [Documentation]     Launches browser in incognito/private mode and logs in to the application
    ...                 @Author = VIMALKUMAR M
    ${browser}          Call Method              ${config_reader}    browser
    ${incognito_mode}          Call Method              ${config_reader}    incognito_mode
    Run Keyword If    ${incognito_mode} == True    Launch Browser In Incognito Mode            ${browser}
    ...    ELSE       Launch Browser In Normal Mode
    Login To Application


Launch Browser In Incognito Mode
    [Documentation]     Launches the specified browser in incognito or private mode based on its type using the appropriate command-line arguments.
    ...                 @Author = VIMALKUMAR M
    [Arguments]         ${browser}
    Run Keyword If     '${browser}' == 'Chrome'    Launch Chrome Incognito Browser
    Run Keyword If     '${browser}' == 'Edge'    Launch Edge Incognito Browser
    Run Keyword If     '${browser}' == 'Firefox'    Launch Firefox Incognito Browser
    Maximize Browser Window


Launch Chrome Incognito Browser
    [Documentation]     Opens and maximizes browser window in Incognito mode for Chrome
    ...                 @Author = VIMALKUMAR M
    ${browser}          Call Method            ${config_reader}    browser
    ${chrome_options}   Create Dictionary      incognito='--incognito'
    Open Browser        about:blank            ${browser}    arguments=${chrome_options}

#    ${options}=         Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
#    Call Method         ${options}    add_argument    --incognito
#    Create WebDriver    Chrome    options=${options}
#    Go To               about:blank

    Maximize Browser Window

Launch Firefox Incognito Browser
    [Documentation]     Opens and maximizes browser window in Private mode for Firefox
    ...                 @Author = VIMALKUMAR M
    ${browser}          Call Method            ${config_reader}    browser
    ${firefox_options}  Create Dictionary      private='-private'
    Open Browser        about:blank            ${browser}    arguments=${firefox_options}

#    ${options}=         Evaluate    sys.modules['selenium.webdriver'].FirefoxOptions()    sys
#    Call Method         ${options}    add_argument    -private
#    Create WebDriver    Firefox    options=${options}
#    Go To               about:blank

    Maximize Browser Window

Launch Edge Incognito Browser
    [Documentation]     Opens and maximizes browser window in InPrivate mode for Edge
    ...                 @Author = VIMALKUMAR M
    ${browser}         Call Method            ${config_reader}    browser
    ${edge_options}    Create Dictionary      inprivate='--inprivate'
    Open Browser        about:blank            ${browser}    arguments=${edge_options}

#    ${options}=         Evaluate    sys.modules['selenium.webdriver'].EdgeOptions()    sys
#    Call Method         ${options}    add_argument    --inprivate
#    Create WebDriver    Edge    options=${options}
#    Go To               about:blank

    Maximize Browser Window

Launch Browser In Normal Mode
    [Documentation]     Launches the specified browser in incognito or private mode based on its type using the appropriate command-line arguments.
    ...                 @Author = VIMALKUMAR M
    [Arguments]         ${browser}
    Run Keyword If     '${browser}' == 'Chrome'    Launch Chrome Browser
    Run Keyword If     '${browser}' == 'Edge'      Launch Edge Browser
    Run Keyword If     '${browser}' == 'Firefox'   Launch Firefox Browser
    Maximize Browser Window

Launch Chrome Browser
    [Documentation]     Opens and maximizes Chrome browser window (normal mode)
    ...                 @Author = VIMALKUMAR M
    ${browser}          Call Method            ${config_reader}    browser
    Open Browser        about:blank            ${browser}

#    Create Webdriver    ${browser}    options=${options}
#    Go To    about:blank

    Maximize Browser Window

Launch Firefox Browser
    [Documentation]     Opens and maximizes Firefox browser window (normal mode)
    ...                 @Author = VIMALKUMAR M
    ${browser}          Call Method            ${config_reader}    browser
    Open Browser        about:blank            ${browser}

#    Create Webdriver    ${browser}    options=${options}
#    Go To    about:blank

    Maximize Browser Window

Launch Edge Browser
    [Documentation]     Opens and maximizes Edge browser window (normal mode)
    ...                 @Author = VIMALKUMAR M
    ${browser}          Call Method            ${config_reader}    browser
    Open Browser        about:blank            ${browser}

#    Create Webdriver    ${browser}    options=${options}
#    Go To    about:blank

    Maximize Browser Window

Open Registration Page
    [Documentation]
    Navigate To Landing Page
    Click Element Until Visible     ${locators_params['home']['menu']['my_account']}[dropdown]
    Click Element Until Visible     ${locators_params['home']['menu']['my_account']}[register_option]
    ${signup_url}      Call Method            ${config_reader}    register_url
    ${register_page_status}         Run Keyword And Return Status    Verify Register Page Title
    Sleep    5s
    Run Keyword If    '${register_page_status}' == 'False'   Run Keywords    Go To    ${signup_url}
    ...    AND    Sleep    5s
    ...    AND    Verify Register Page Title
    Capture The Screen              Register_page

Navigate To Landing Page
    [Documentation]     Navigates to the Landing page of the OpenCart application
    ...                 @Author = VIMALKUMAR M
    Set Selenium Timeout            20 seconds
    Set Selenium Implicit Wait     20 seconds
    Log To Console                 Running POS Laundry...

    ${browser}          Call Method              ${config_reader}    browser
    ${incognito_mode}          Call Method              ${config_reader}    incognito_mode
    Run Keyword If    ${incognito_mode} == True    Launch Browser In Incognito Mode            ${browser}
    ...    ELSE       Launch Browser In Normal Mode

#    ${landing_url}        Call Method            ${config_reader}    url
#    Go To               ${landing_url}

    ${signup_url}      Call Method            ${config_reader}    register_url
    Go To    ${signup_url}

    Sleep               5s
    Capture The Screen  Landing_Page

Close Toast Message
    [Documentation]     Closes any visible toast message
    ...                 @Author = VIMALKUMAR M
    Click Element       xpath=//button[contains(@class,'p-toast-icon-close')]


Close All The Browsers
    [Documentation]     Closes all open browser windows
    ...                 @Author = VIMALKUMAR M
    Close All Browsers


Open New Browser Tab
    [Documentation]     Opens a new tab and navigates to the given URL
    ...                 @Author = VIMALKUMAR M
    [Arguments]         ${url}
    Execute Javascript  window.open('${url}');
    Sleep               5s

    @{handles}         Get Window Handles
    Switch Window       ${handles}[1]
    Capture The Screen  New_Tab


Logout The Application
    [Documentation]     Logs out the user from the application
    ...                 @Author = VIMALKUMAR M
    Wait Until Element Is Visible    ${locators_params['home']['menu']['my_account']}[dropdown]
    Click Element Until Visible      ${locators_params['home']['menu']['my_account']}[dropdown]
    Capture The Screen               Logout_Button

    Wait Until Element Is Visible    ${locators_params['home']['menu']['my_account']}[logout_option]
    Click Element Until Visible      ${locators_params['home']['menu']['my_account']}[logout_option]
    Sleep                            3s
    Reload Current Page

    Verify Logout Page Title

    Wait Until Element Visible       ${locators_params['logout']}[logged_off_description]

    ${logged_off_description_text}   Get Text    ${locators_params['logout']}[logged_off_description]
    Should Be Equal    ${logged_off_description_text}    ${test_data['logout']}[logged_off_description]

    Wait Until Element Is Enabled    ${locators_params['logout']}[continue_button]
    Click Element Until Enabled      ${locators_params['logout']}[continue_button]
    Capture The Screen               LogoutSuccessfully

    Verify Home Page Title