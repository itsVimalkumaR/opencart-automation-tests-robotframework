*** Settings ***
Library     SeleniumLibrary
Library     RequestsLibrary
Library     JSONLibrary
Library     ImapLibrary

Resource    ../../test_cases/base.robot

*** Variables ***
${sleep_interval}    5s

*** Keywords ***

Validate Account Registration Using Only Mandatory Fields
    [Documentation]    Check that only required fields are validated during registration
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_001
    @{register_elements}    Create List
    ...    ${locators_params['register']['your_personal_details']}[first_name_input_field]
    ...    ${locators_params['register']['your_personal_details']}[last_name_input_field]
    ...    ${locators_params['register']['your_personal_details']}[email_input_field]
    ...    ${locators_params['register']['your_personal_details']}[telephone_input_field]
    ...    ${locators_params['register']['your_password']}[password_input_field]
    ...    ${locators_params['register']['your_password']}[confirm_password_input_field]

    @{register_input_data}    Get Register Input Data

    Enter Multiple Values In Input Fields   ${register_elements}    ${register_input_data}
    Scroll Element Into View          ${locators_params['register']['agreement']}[policy_agreement_checkbox]
    Click Element Until Enabled       ${locators_params['register']['agreement']}[policy_agreement_checkbox]
    Capture The Screen    TC_RF_001

    RETURN    @{register_input_data}

Validate Continue Button Functionality
    [Documentation]    Validates that the 'Continue' button on the agreement section of the registration page is visible
    ...                and clickable. Captures a screenshot after clicking for verification.
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_001, TC_RF_002, and TC_RF_003
    Wait Until Element Visible    ${locators_params['register']['agreement']}[continue_button]
    Click Element Until Enabled   ${locators_params['register']['agreement']}[continue_button]
    Sleep    5s
    Capture The Screen    ContinueButtonFunction

Get Register Input Data
    [Documentation]    Collects user registration input data from environment and email config.
    ...                Returns a list with values for: first name, last name, email ID, phone, password, and confirm password.
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_001
    ${first_name}          Get Env File Value       REGISTER_FIRST_NAME
    ${last_name}           Get Env File Value       REGISTER_LAST_NAME
    ${email}               ${email_app_password}    Use Email Config Dictionary
    ${email_id}            Split Email Components   ${email}
    ${telephone}           Get Env File Value       REGISTER_TELEPHONE
    ${password}            Get Env File Value       REGISTER_PASSWORD
    ${confirm_password}    Get Env File Value       REGISTER_PASSWORD_CONFIRM

    @{register_input_data}    Create List
    ...    ${first_name}
    ...    ${last_name}
    ...    ${email_id}
    ...    ${telephone}
    ...    ${password}
    ...    ${confirm_password}

    RETURN    @{register_input_data}

Validate Registration Success Page
    [Documentation]    Upon successful registration, the user should be automatically logged in,
    ...                redirected to the 'Account Success' page, and
    ...                the page should display the appropriate user details confirming the successful account creation."
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_001
    Verify Account Success Page Title
    @{account_success_page_elements}    Create List
    ...                ${locators_params['register_success']}[account_labeltext]
    ...                ${locators_params['register_success']}[success_message]
    ...                ${locators_params['register_success']}[member_privileges_description]
    ...                ${locators_params['register_success']}[description_message]
    ...                ${locators_params['register_success']}[email_confirmation_description]
    ...                ${locators_params['register_success']}[contact_us_link_text]
    ...                ${locators_params['register_success']}[continue_button]
    Wait Until Elements Are Visible    @{account_success_page_elements}

    @{account_success_page_text}    Create List
    ...                ${test_data['register_success']}[account_labeltext]
    ...                ${test_data['register_success']}[success_message]
    ...                ${test_data['register_success']}[member_privileges_description]
    ...                ${test_data['register_success']}[description_message]
    ...                ${test_data['register_success']}[email_confirmation_description]
    ...                ${test_data['register_success']}[contact_us_link_text]
    ...                ${test_data['register_success']}[continue_button]

    Validate Elements Text Equal To List    ${account_success_page_elements}    ${account_success_page_text}

    Click Element Until Enabled       ${locators_params['register_success']}[continue_button]

Validate Registration Confirmation Email Sent
    [Documentation]    Validate that a "Thank you for registering" confirmation email is successfully sent.
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_002
    [Arguments]        ${email_id}

    ${password}        Get Env File Value    REGISTER_EMAIL_APP_PASSWORD
    ${max_attempts}    Set Variable    6
    ${login_link}      Set Variable    None

    FOR    ${i}    IN RANGE    ${max_attempts}
        Log    Email ID is: ${email_id}
        Log    Password length is: ${password.__len__()}

        ${login_link}          Check Email Received    ${email_id}    ${password}
        Run Keyword If    '${login_link}' != 'None'    Exit For Loop
        Sleep    ${sleep_interval}
    END

    Run Keyword If    '${login_link}' == 'None'
    ...    Fail    No email confirming registration was received. Thus, we are unable to gain the login link.

    Log    Registration confirmation email received with login link: "${login_link}"
#    Validate Registration Success Email    ${email_id}    ${password}


Check Email Received
    [Documentation]    Fetches login link from registration email with subject in Spam folder.
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_002
    [Arguments]        ${email_id}    ${password}
    ${login_link}      Call Method    ${test_manager}    get_login_link_from_email    ${email_id}    ${password}
    Log                Login link is: ${login_link}
    ${login_link_url}=    Set Variable    ${login_link[0]}
    Should Not Be Empty    ${login_link_url}
    RETURN             ${login_link_url}

Validate Registration Success Email
    [Documentation]    Searches for the registration email across Inbox, Spam, Promotions, Updates, Social, and Forums.
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_002
    [Arguments]        ${email}    ${password}

    @{folders}      Create List    INBOX    [Gmail]/Spam    [Gmail]/Promotions    [Gmail]/Updates    [Gmail]/Social    [Gmail]/Forums
    ${subject}      Get Env File Value    SUBJECT
    ${imap_server}  Get Env File Value    IMAP_SERVER
    ${found}        Set Variable    False

    FOR    ${folder}    IN    @{folders}
        Log    Checking folder: ${folder}
        ${status}    Run Keyword And Return Status    
        ...    Open Mailbox    host=${imap_server}    user=${email}    password=${password}
        Run Keyword If    not ${status}    Continue For Loop

        ${folder_exists}    Run Keyword And Return Status    Select Folder    ${folder}
        Run Keyword If    not ${folder_exists}    Close Mailbox
        Run Keyword If    not ${folder_exists}    Continue For Loop

        ${emails}    Run Keyword If    ${status}    Search Mailbox    SUBJECT "${subject}"
        ${found}    Run Keyword If    ${status} and ${emails}    Set Variable    True
#        Run Keyword If    ${status}    Close Mailbox
        Close Mailbox
        Exit For Loop If    ${found}
        
#        Connect To Mailbox    ${imap_server}    ${email}    ${password}
#        Select Folder         ${folder}
#
#        ${is_found}=    Run Keyword And Return Status    Wait For Email With Subject    ${subject}    timeout=30s    interval=5s
#
#        Close Mailbox
#
#        Run Keyword If    ${is_found}    Set Variable    ${found}    True
#        Run Keyword If    ${found}      Exit For Loop
    END
    
    Should Be True    ${found}    Registration confirmation email not found in any folder
    Run Keyword If    not ${found}    Fail    Email with subject '${subject}' not found in any folder.
    Log    Email with subject '${subject}' found successfully.

Validate Newsletter Section Elements
    [Documentation]    Verify all newsletter section elements (labels and radio buttons) are visible on the registration page.
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_003
    @{newsletter_section_elements}=    Create List
    ...    ${locators_params['register']['newsletter']}[subscribe_labeltext]
    ...    ${locators_params['register']['newsletter']}[subscribe_yes_labeltext]
    ...    ${locators_params['register']['newsletter']}[subscribe_yes_radio_button]
    ...    ${locators_params['register']['newsletter']}[subscribe_no_labeltext]
    ...    ${locators_params['register']['newsletter']}[subscribe_no_radio_button]
    Wait Until Elements Are Visible    @{newsletter_section_elements}

Validate Newsletter Section Elements Label Text
    [Documentation]    Validate the text of newsletter section labels matches the expected values.
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_003
    @{newsletter_section_elements}=    Create List
    ...    ${locators_params['register']['newsletter']}[subscribe_labeltext]
    ...    ${locators_params['register']['newsletter']}[subscribe_yes_labeltext]
    ...    ${locators_params['register']['newsletter']}[subscribe_no_labeltext]
    
    @{newsletter_section_label_texts}=    Create List
    ...    ${test_data['register']['newsletter']}[subscribe_labeltext]
    ...    ${test_data['register']['newsletter']}[subscribe_yes_labeltext]
    ...    ${test_data['register']['newsletter']}[subscribe_no_labeltext]

    Validate Elements Text Equal To List    ${newsletter_section_elements}    ${newsletter_section_label_texts}
    Capture The Screen    newsletter

Validate Empty Form Submission Warnings
    [Documentation]    When submitting the registration form without completing any required fields,
    ...                make sure the proper error messages appear.
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_004
    ${signup_url}      Call Method            ${config_reader}    register_url
    Go To    ${signup_url}
    Sleep    5s
    Validate Continue Button Functionality
    @{register_warnings_elements}    Create List    
    ...    ${locators_params['warning_messages']['register']['your_personal_details']}[firstname]
    ...    ${locators_params['warning_messages']['register']['your_personal_details']}[lastname]
    ...    ${locators_params['warning_messages']['register']['your_personal_details']}[email]
    ...    ${locators_params['warning_messages']['register']['your_personal_details']}[telephone]
    ...    ${locators_params['warning_messages']['register']['your_password']}[password]
    ...    ${locators_params['warning_messages']['register']['agreement']}[policy_agreement]
    
    @{register_warnings_texts}    Create List    
    ...    ${test_data['warning_messages']['register']['your_personal_details']}[firstname]
    ...    ${test_data['warning_messages']['register']['your_personal_details']}[lastname]
    ...    ${test_data['warning_messages']['register']['your_personal_details']}[email]
    ...    ${test_data['warning_messages']['register']['your_personal_details']}[telephone]
    ...    ${test_data['warning_messages']['register']['your_password']}[password]
    ...    ${test_data['warning_messages']['register']['agreement']}[policy_agreement]
    
    Validate Elements Text Equal To List    ${register_warnings_elements}    ${register_warnings_texts}

Verify User Can Enable Newsletter Subscription
    [Documentation]    Validate registration when selecting “Yes” for the Newsletter option.
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_005
    Page Should Contain Radio Button    ${locators_params['register']['newsletter']}[subscribe_yes_radio_button]
    ${is_yes_selected}   Radio Button Should Not Be Selected    ${locators_params['register']['newsletter']}[subscribe_yes_radio_button]
    Should Not Be True   ${yes_selected}
    Capture The Screen    TC_RF_005_1
    ${newsletter_subscribed}    Select Radio Button    ${locators_params['register']['newsletter']}[subscribe_yes_radio_button]
    ${yes_selected}    Radio Button Should Be Selected    ${locators_params['register']['newsletter']}[subscribe_yes_radio_button]
    Should Be True     ${yes_selected}
    Capture The Screen    TC_RF_005_2

Validate Registration With Newsletter Option As No
    [Documentation]    Verify user can successfully register an account when the "No" option is selected for the newsletter subscription.
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_006
    Page Should Contain Radio Button    ${locators_params['register']['newsletter']}[subscribe_no_radio_button]
    ${no_selected}    Radio Button Should Be Selected    ${locators_params['register']['newsletter']}[subscribe_no_radio_button]
    Should Be True     ${no_selected}
    Capture The Screen    TC_RF_006

Ensure Appropriate Error Messages Are Shown When Fields Are Blank
    [Documentation]    Validate that empty required fields trigger error messages

Check Mandatory Fields Have Red Asterisk And Reject Spaces
    [Documentation]    Ensure required fields are marked and do not allow only whitespace

Fill All Fields And Submit Form
    [Documentation]    Input valid data into all fields and submit successfully

Validate Successful Form Submission
    [Documentation]    Confirm registration success on full form submission

Verify Registration Email Sent
    [Documentation]    Confirm email is triggered and validate content

Validate Email Subject Sender And Body
    [Documentation]    Check email has correct subject line, sender address, and body

Select Newsletter Option Yes
    [Documentation]    Test form behavior when opting into newsletter

Select Newsletter Option No
    [Documentation]    Test form behavior when opting out of newsletter

Use Existing Email For Registration
    [Documentation]    Validate form with duplicate email entry

Enter Invalid Email And Phone Number
    [Documentation]    Verify validation errors for badly formatted email/phone

Enter Mismatched Passwords
    [Documentation]    Ensure error appears when passwords do not match

Validate Password Complexity And Masking
    [Documentation]    Check that password meets complexity and is hidden by default

Leave Confirm Password Blank
    [Documentation]    Check behavior when Confirm Password is empty

Verify Field Placeholders And Visual Elements
    [Documentation]    Ensure placeholders exist and layout is user-friendly

Validate Field Layout And Input Limits
    [Documentation]    Confirm fields are aligned and within required specs

Access Register Page Via Menu Link Or Button
    [Documentation]    Validate different user paths to registration page

Test Keyboard Navigation For Accessibility
    [Documentation]    Ensure all elements can be accessed using keyboard only

Verify Navigation Links From Registration Page
    [Documentation]    Test if registration page links redirect correctly

Privacy Checkbox Unchecked By Default
    [Documentation]    Ensure the Privacy Policy checkbox is initially false

Block Submission Without Privacy Acceptance
    [Documentation]    Validate form fails to submit if policy isn't accepted

Check Page Title Heading Breadcrumb And URL
    [Documentation]    Validate correct page structure and metadata

Cross Browser And Environment Testing
    [Documentation]    Ensure page works across all supported platforms

Validate Database Storage After Registration
    [Documentation]    Confirm data is correctly saved to the backend
