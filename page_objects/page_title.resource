*** Settings ***
Library         SeleniumLibrary
Library         OperatingSystem
Library         DateTime
Library         String
Library         Collections
Library         RequestsLibrary
Resource        ../test_cases/base.robot

*** Keywords ***
Verify Home Page Title
    [Documentation]    Verify that the current page title matches the expected title for the Home page.
    Title Should Be    ${test_data['page_titles']}[home]

Verify Register Page Title
    [Documentation]    Verify that the current page title matches the expected title for the Register page.
    Title Should Be    ${test_data['page_titles']}[register]

Verify Login Page Title
    [Documentation]    Verify that the current page title matches the expected title for the Login page.
    Title Should Be    ${test_data['page_titles']}[login]

Verify Forgotten Password Page Title
    [Documentation]    Verify that the current page title matches the expected title for the Forgotten Password page.
    Title Should Be    ${test_data['page_titles']}[forgotten_password]

Verify Account Success Page Title
    [Documentation]    Verify that the current page title matches the expected title for the Account Success page.
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_001
    Title Should Be    ${test_data['page_titles']}[account_success]

Verify Logout Page Title
    [Documentation]    Verify that the current page title matches the expected title for the Logoff page.
    Title Should Be    ${test_data['page_titles']}[logout]