*** Settings ***
Documentation    Validates the complete functionality and behavior of the Register Account feature
Library          SeleniumLibrary
Library          BuiltIn
Resource         ../../test_cases/base.robot

Suite Setup      Run Keywords   Initialize Configuration Parameters For Register
...              AND            Open Registration Page
Suite Teardown   Close All The Browsers


*** Variables ***
${excel_path}    ../../utils/register_users.xlsx


*** Test Cases ***
Validate Account Registration And Confirmation Email
    [Documentation]    Validate account registration with only mandatory fields and confirm a registration email is sent successfully.
    ...                @Author: VIMALKUMAR M
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_001, TC_RF_002, and TC_RF_003
    [Tags]    Regression
    @{register_input_data}    Validate Account Registration Using Only Mandatory Fields
    Validate Newsletter Section Elements
    Validate Newsletter Section Elements Label Text
    Validate Continue Button Functionality
    Validate Registration Success Page

    Save User Credential In Excel File    ${register_input_data}[0]    ${register_input_data}[1]    ${register_input_data}[2]
    ...    ${register_input_data}[3]      ${register_input_data}[4]    ${register_input_data}[5]    ${excel_path}
    Save User Credential In DB    ${register_input_data}[0]    ${register_input_data}[1]    ${register_input_data}[2]
    ...    ${register_input_data}[3]      ${register_input_data}[4]    ${register_input_data}[5]

    Validate Registration Confirmation Email Sent    ${register_input_data}[2]

Validate Mandatory Field Warnings on Empty Submission
    [Documentation]    Ensure appropriate error messages are displayed when submitting the form with no fields filled.
    ...                @Author: VIMALKUMAR M
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_004
    [Tags]    Regression
    Logout The Application
    Open Registration Page
    Validate Empty Form Submission Warnings

Register Account with Newsletter Subscription Enabled
    [Documentation]    Test the registration flow when the user subscribes to the newsletter during registration.
    ...                @Author: VIMALKUMAR M
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_005
    [Tags]    Regression
    Logout The Application
    Open Registration Page
    @{register_input_data}    Validate Account Registration Using Only Mandatory Fields
    Verify User Can Enable Newsletter Subscription
    Validate Continue Button Functionality
    Save User Credential In Excel File    ${register_input_data}[0]    ${register_input_data}[1]    ${register_input_data}[2]
    ...    ${register_input_data}[3]      ${register_input_data}[4]    ${register_input_data}[5]    ${excel_path}
    Save User Credential In DB    ${register_input_data}[0]    ${register_input_data}[1]    ${register_input_data}[2]
    ...    ${register_input_data}[3]      ${register_input_data}[4]    ${register_input_data}[5]

Register With Newsletter Option Disabled
    [Documentation]    Validate Registration Flow When Newsletter Subscription Is Disabled
    ...                @Author: VIMALKUMAR M
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_006
    [Tags]    Regression
    Logout The Application
    Open Registration Page
    @{register_input_data}    Validate Account Registration Using Only Mandatory Fields
    Validate Registration With Newsletter Option As No
    Validate Continue Button Functionality
    Save User Credential In Excel File    ${register_input_data}[0]    ${register_input_data}[1]    ${register_input_data}[2]
    ...    ${register_input_data}[3]      ${register_input_data}[4]    ${register_input_data}[5]    ${excel_path}
    Save User Credential In DB    ${register_input_data}[0]    ${register_input_data}[1]    ${register_input_data}[2]
    ...    ${register_input_data}[3]      ${register_input_data}[4]    ${register_input_data}[5]


############################################################################
Register Account With All Fields
    [Documentation]    Validate successful account registration when all form fields are filled.
    ...                @Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_002

    Fill All Fields And Submit Form
    Validate Successful Form Submission

Full Form Submission
    [Documentation]    Test successful account registration by completing all fields with valid data and submitting the form
    ...                @Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_004 and TC_RF_005
    Ensure Appropriate Error Messages Are Shown When Fields Are Blank
    Check Mandatory Fields Have Red Asterisk And Reject Spaces

Email Confirmation
    [Documentation]    Confirm that a registration success email is sent with the correct subject, sender, and body content
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_006 and TC_RF_007
    Verify Registration Email Sent
    Validate Email Subject Sender And Body

Newsletter Option
    [Documentation]    Validate form behavior and submission with both Yes and No selections for the newsletter subscription option
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_008 and TC_RF_009
    Select Newsletter Option Yes
    Select Newsletter Option No

Invalid and Duplicate Data
    [Documentation]    Test error handling for existing email addresses and invalid inputs for email and phone number fields
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_010 and TC_RF_011
    Use Existing Email For Registration
    Enter Invalid Email And Phone Number

Password Validation
    [Documentation]    Validate password mismatch, complexity rules, input masking, and behavior when 'Confirm Password' is left empty
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_012, TC_RF_013 and TC_RF_014
    Enter Mismatched Passwords
    Validate Password Complexity And Masking
    Leave Confirm Password Blank

UI and UX Behavior
    [Documentation]    Verify placeholders, input trimming, field alignment, and adherence to layout and input constraints
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_015 and TC_RF_016
    Verify Field Placeholders And Visual Elements
    Validate Field Layout And Input Limits

Navigation and Accessibility
    [Documentation]    Ensure registration page is accessible via menu, link, or button and supports keyboard-only navigation
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_017, TC_RF_018 and TC_RF_019
    Access Register Page Via Menu Link Or Button
    Test Keyboard Navigation For Accessibility
    Verify Navigation Links From Registration Page

Privacy Policy Handling
    [Documentation]    Confirm Privacy Policy checkbox is unchecked by default and prevents submission if not selected
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_020 and TC_RF_021
    Privacy Checkbox Unchecked By Default
    Block Submission Without Privacy Acceptance

Page and Environment Testing
    [Documentation]    Validate breadcrumb, page title, heading, URL structure, cross-browser rendering, and data persistence in the database
    ...                Test Scenario ID: TS_001
    ...                Test Case ID: TC_RF_022, TC_RF_023 and TC_RF_024
    Check Page Title Heading Breadcrumb And URL
    Cross Browser And Environment Testing
    Validate Database Storage After Registration