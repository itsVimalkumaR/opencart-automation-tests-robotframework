*** Settings ***
Documentation       UI-related and reusable utility keywords for POS Application
Library             SeleniumLibrary
Library             OperatingSystem
Library             DateTime
Library             String
Library             Collections
Library             RequestsLibrary
Library             BuiltIn

Variables           ../utils/ini_files/api_handler.py
Variables           ../utils/config_parser.py
Variables           ../utils/ini_files/config_reader.py
Variables           ../utils/ini_files/custom_library.py

Resource            ../test_cases/base.robot
Resource            ../page_objects/config_parser_keywords.resource
Resource            ../page_objects/api_integration.resource
Resource            ../page_objects/landing_page.resource


*** Variables ***
${SHORT_TIMEOUT}    5 seconds
${TIMEOUT}          10 seconds
${LONG_TIMEOUT}     90 seconds


*** Keywords ***

Initialize Configuration Parameters
    [Documentation]    Sets up the config, API handlers, and initial environment data
    ...                @Author = VIMALKUMAR M
    Set Project Root Directory
    Parse Locators Config
    Parse Test Data Config
    Setup Test Environment
    ${ENVIRONMENT}=    Call Method    ${config_reader}    environment
    Run Keyword If    '${ENVIRONMENT}' in ['Web', 'QA', 'Localhost']
    ...    Run Keywords    API Call For Config Reader
    ...    AND             API Call for End URL
    ...    AND             API Call for User Login

Initialize Configuration Parameters For Register
    [Documentation]    Initializes configuration parameters specific to user Register
    ...                @Author = VIMALKUMAR M
    Set Project Root Directory
    Parse Locators Config
    Parse Test Data Config
    ${ENVIRONMENT}=    Call Method    ${config_reader}    environment
    Run Keyword If     '${ENVIRONMENT}' == 'Web'    API Call For Config Reader
    Run Keyword If     '${ENVIRONMENT}' == 'Web'    API Call for End URL

Log Report
    [Documentation]    Logs a message to console indicating test start
    ...                @Author = VIMALKUMAR M
    Log To Console     Running POS Application...

Click And Input Value
    [Documentation]    Click the element and input the provided value
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${locator}    ${input_value}
    Click Element Until Visible    ${locator}
    Sleep                          ${SHORT_TIMEOUT}
    Enter The Value Until Visible  ${locator}    ${input_value}

Capture The Screen
    [Documentation]    Takes a screenshot with the provided screen name
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${ScreenName}
    Sleep              1 s
    Capture Page Screenshot    ${ScreenName}.png

Click Element Until Enabled
    [Documentation]    Waits until element is enabled, then clicks
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${locator}
    Wait Until Element Is Enabled  ${locator}
    Click Element                  ${locator}

Click Element Until Visible
    [Documentation]    Waits until element is visible, then clicks
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=${TIMEOUT}
    Click Element                    ${locator}
    Sleep                            1 s

Enter The Value Until Visible
    [Documentation]    Waits for visibility, then inputs text into element
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${locator}    ${TextValue}
    Wait Until Element Is Visible    ${locator}    timeout=${TIMEOUT}
    Input Text                       ${locator}    ${TextValue}

Page Should Contain The Element
    [Documentation]      Verifies page contains the given text
    ...                  @Author = VIMALKUMAR M
    [Arguments]          ${item}
    Sleep                2 seconds
    Page Should Contain  ${item}

Scroll To Element Using Js
    [Documentation]    Scrolls to the specified element using JavaScript
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${locator}
    ${x}=              Get Horizontal Position    ${locator}
    ${y}=              Get Vertical Position      ${locator}
    Execute Javascript    window.scrollTo(${x}, ${y})

Wait Until Elements Are Visible
    [Documentation]    Waits for all elements in list to be visible
    ...                @Author = VIMALKUMAR M
    [Arguments]        @{multi_element}
    FOR    ${locator}    IN    @{multi_element}
        Wait Until Element Is Visible    ${locator}    timeout=${TIMEOUT}
    END

Elements Should Not Be Visible
    [Documentation]    Verifies all elements in list are not visible
    ...                @Author = VIMALKUMAR M
    [Arguments]        @{multi_elements}
    FOR    ${locator}    IN    @{multi_elements}
        Element Should Not Be Visible    ${locator}    timeout=${TIMEOUT}
    END

Wait Until Page Contain Elements
    [Documentation]    Waits until all specified elements are present on page
    ...                @Author = VIMALKUMAR M
    [Arguments]        @{multi_elements}
    FOR    ${element}    IN    @{multi_elements}
        Wait Until Page Contains Element    ${element}    timeout=${TIMEOUT}
    END

Page Should Contain Multiple Texts
    [Documentation]    Waits until all provided texts are visible on page
    ...                @Author = VIMALKUMAR M
    [Arguments]        @{multi_texts}
    FOR    ${text}    IN    @{multi_texts}
        Wait Until Page Contains    ${text}    timeout=${LONG_TIMEOUT}
    END


Table Header Should Contain Multiple Texts
    [Documentation]    Verifies that a table header contains multiple expected texts.
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${locator}    @{multi_texts}
    FOR    ${text}    IN    @{multi_texts}
        Table Header Should Contain    ${locator}    ${text}
    END

Page Should Contain Multiple Elements
    [Documentation]    Verifies the page contains all specified elements.
    ...                @Author = VIMALKUMAR M
    [Arguments]        @{multi_elements}
    FOR    ${element}    IN    @{multi_elements}
        Page Should Contain Element    ${element}
    END

Click And Clear Textfield
    [Documentation]    Clicks a text field and clears its value.
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${locator}
    Wait Until Page Contains Element    ${locator}    timeout=${TIMEOUT}
    Click Element Until Visible         ${locator}
    Press Keys                          ${locator}    CTRL+a+BACKSPACE
    Capture The Screen                  Cleared_Textfield

Clear Textfield Value
    [Documentation]    Clears the text from an input field after waiting for visibility.
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${locator}
    Wait Until Page Contains Element    ${locator}    timeout=${TIMEOUT}
    Clear Element Text                  ${locator}
    Capture The Screen                  Cleared_Textfield

Wait Until Page Contains Multiple Texts
    [Documentation]    Waits until all specified texts are present on the page.
    ...                @Author = VIMALKUMAR M
    [Arguments]        @{multi_texts}
    FOR    ${text}    IN    @{multi_texts}
        Wait Until Page Contains        ${text}    timeout=${TIMEOUT}
    END

Wait Until Element Visible
    [Documentation]    Waits until the specified element is visible.
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${locator}
    Set Library Search Order            SeleniumLibrary
    Wait Until Element Is Visible       ${locator}    timeout=${TIMEOUT}

Element Should Not Be Visible
    [Documentation]    Verifies that an element is not visible on the page.
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${locator}
    Sleep    ${SHORT_TIMEOUT}
    Element Should Not Be Visible       ${locator}    timeout=${TIMEOUT}

Should Be Equal To Text
    [Documentation]    Compares the element's text with the expected value.
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${locator}    ${value}
    ${text}=           Get Text                       ${locator}
    Should Be Equal    ${text}                        ${value}

Entered Value Should Be Equal
    [Documentation]    Compares entered input field value with the expected value.
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${locator}    ${value}
    ${text}=           Get Element Attribute          ${locator}    value
    Should Be Equal    ${text}                        ${value}

Page Should Not Contain Multiple Elements
    [Documentation]    Verifies multiple elements are not present on the page.
    ...                @Author = VIMALKUMAR M
    [Arguments]        @{multi_elements}
    FOR    ${element}    IN    @{multi_elements}
        Wait Until Page Does Not Contain Element    ${element}    timeout=60s
    END

Elements Should Be Disabled
    [Documentation]    Verifies all specified elements are disabled.
    ...                @Author = VIMALKUMAR M
    [Arguments]        @{multi_elements}
    FOR    ${element}    IN    @{multi_elements}
        Element Should Be Disabled    ${element}
    END

Page Should Not Contain Multiple Texts
    [Documentation]    Verifies the page does not contain any of the specified texts.
    ...                @Author = VIMALKUMAR M
    [Arguments]        @{multi_texts}
    FOR    ${text}    IN    @{multi_texts}
        Page Should Not Contain    ${text}
    END

Reload Current Page
    [Documentation]    Reloads the current browser page.
    ...                @Author = VIMALKUMAR M
    Reload Page
    Sleep    8

Wait Until Loader Spinner Disappears
    [Documentation]    Waits until loading spinner disappears based on the browser.
    ...                @Author = VIMALKUMAR M
    ${browser}=        Call Method    ${config_reader}    browser
    Run Keyword If     '${browser}' == 'chrome'    Wait For Chrome Loader
    ...                ELSE                            Wait For Firefox Loader

Wait For Chrome Loader
    [Documentation]    Waits until spinner disappears in Chrome browser.
    ...                @Author = VIMALKUMAR M
    Wait Until Page Does Not Contain Element    //div[@class='spinner-border text-primary']    timeout=3m

Wait For Firefox Loader
    [Documentation]    Waits until spinner disappears in Firefox browser.
    ...                @Author = VIMALKUMAR M
    Wait Until Page Does Not Contain Element    //div[@class='spinner-border text-primary']    timeout=5m

Validate Dropdown List
    [Documentation]    Validates dropdown list values by selecting each item.
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${dropdown_name}    @{dropdown_list}    ${dropdown_element}
    FOR    ${dropdown_value}    IN    @{dropdown_list}
        Select From List By Label    ${dropdown_element}    ${dropdown_value}
    END

JS Click Element Using XPath
    [Documentation]    Clicks a hidden element using its XPath via JavaScript.
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${element_xpath}
    ${element_xpath}=     Replace String    ${element_xpath}    \"    \\\"
    Execute JavaScript    document.evaluate("${element_xpath}", document, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null).snapshotItem(0).click();
    Assign ID To Element  ${element_xpath}    id=Checkbox_id
    Execute JavaScript    document.getElementById('Checkbox_id').click();
    Sleep    2s

JS Click Element With Selector
    [Documentation]    Clicks an element using CSS or XPath selector via JavaScript.
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${locator}
    ${locator_type}=    Run Keyword If    '${locator}'.startswith('css=')    Set Variable    css
    ...                 ELSE    Set Variable    xpath
    ${element_selector}=    Replace String    ${locator}    css=    ""
    Run Keyword If    '${locator_type}' == 'css'
    ...    Execute JavaScript    document.querySelector("${element_selector}").click();
    Run Keyword If    '${locator_type}' == 'xpath'
    ...    Execute JavaScript    document.evaluate("${element_selector}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.click();

Find Data From List
    [Documentation]    Find the data from table list
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${data}
    Sleep              5s
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Scroll To Element Using Js    ${locators_params_params['Settings']}[ShowEntries]
    ${pagination_status}=    Run Keyword And Return Status    Wait Until Element Is Enabled    ${locators_params_params['Settings']}[Pagination_NextBtn]
    Log                 ${pagination_status}
    Capture The Screen    ListOfTableData

    ${formatted_locator}=    Format String    ${locators_params_params['Settings']}[Category_ColumnValue]    value=${data}
    Show All Data From Table    All

    ${total_count}=      Get Text    ${locators_params_params['Settings']}[ShowEntries]
    ${last_char}=        Get Substring    ${total_count}    -1
    ${count}=            Convert To Integer    ${last_char}
    ${result}=           Set Variable    False

    FOR    ${index}    IN RANGE    1    ${count}
        ${formatted_locator}=    Format String    ${locators_params_params['Settings']}[Category_ColumnValue]    value=${data}
        ${result}=    Run Keyword And Return Status    Element Should Be Visible    ${formatted_locator}
        Run Keyword If    ${result} == True    Get Text    ${formatted_locator}
        ...    ELSE    Show All Data From Table    All
        Log    ${index}
    END

    RETURN    ${result}

Show All Data From Table
    [Documentation]    Changes pagination to show all rows in the table.
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${option}
    ${cancel_visible}=    Run Keyword And Return Status    Page Should Contain Element    ${locators_params_params['Settings']}[Cancel_Btn]
    Run Keyword If    ${cancel_visible} == True    Click Element Until Visible    ${locators_params_params['Settings']}[Cancel_Btn]

    Wait Until Element Is Visible    ${locators_params_params['Settings']}[RowsPerPage_DDOptions]
    @{options}=    Get WebElements    ${locators_params_params['Settings']}[RowsPerPage_DDOptions]
    ${option_count}=    Get Element Count    ${locators_params_params['Settings']}[RowsPerPage_DDOptions]

    FOR    ${i}    IN RANGE    1    ${option_count}
        Wait Until Element Is Visible    ${locators_params_params['Settings']}[RowsPerPage_DDArrow]
        Sleep    3s
        ${option_selector}=    Format String    ${locators_params_params['Settings']}[RowsPerPage_DDOption]    value=${option}
        Click Element Until Visible    ${locators_params_params['Settings']}[RowsPerPage_DDArrow]
        Click Element Until Visible    ${option_selector}
        Capture The Screen    AllData
        ${selected_text}=    Get Text    ${locators_params_params['Settings']}[AllOption_RowsPerPage_DDValue]
        Exit For Loop If    '${selected_text}' == '${option}'
    END

    Capture The Screen    ShowAll_Data

Navigate To Next Table Page
    [Documentation]    Navigate To the next table page or Click the pagination next button
    ...                @Author = VIMALKUMAR M
    ${next_disabled}=    Run Keyword And Return Status    Elements Should Be Disabled    ${locators_params_params['Settings']}[Pagination_NextBtn]
    Run Keyword If    ${next_disabled} == True
    ...    Log    We can't click the Next button
    ...    ELSE
    ...    Run Keywords
    ...    Element Should Be Enabled    ${locators_params_params['Settings']}[Pagination_NextBtn]
    ...    AND
    ...    Click Element Until Visible    ${locators_params_params['Settings']}[Pagination_NextBtn]

Validate Elements Text Equal To List
    [Documentation]    Verifies all element texts match the expected test data.
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${elements}    ${testdata}
    ${count}=          Get Length    ${elements}
    FOR    ${i}    IN RANGE    0    ${count}
        ${text}=      Get Text    ${elements}[${i}]
        Log           ${testdata}[${i}]
        Should Be Equal    ${text}    ${testdata}[${i}]
    END

Validate Elements Text Contains List
    [Documentation]    Verifies all element texts contain expected test data substrings.
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${elements}    ${testdata}
    ${count}=          Get Length    ${elements}
    FOR    ${i}    IN RANGE    0    ${count}
        ${text}=      Get Text    ${elements}[${i}]
        Log           ${testdata}[${i}]
        Should Contain    ${text}    ${testdata}[${i}]
    END

Edit Multiple Input Fields
    [Documentation]    Clears and updates multiple input fields.
    ...                @Author = VIMALKUMAR M
    [Arguments]        ${locators}    ${inputs}
    ${length}=         Get Length    ${locators}
    FOR    ${i}    IN RANGE    0    ${length}
        Press Keys    ${locators}[${i}]    CTRL+a+BACKSPACE
        Click And Input Value    ${locators}[${i}]    ${inputs}[${i}]
    END

Enter Multiple Values In Input Fields
    [Documentation]    Enter multiple values in the multiple input fields
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${locators}    ${inputs}
    ${count}=    Get Length    ${locators}
    FOR    ${i}    IN RANGE    0    ${count}
        Click And Input Value    ${locators}[${i}]    ${inputs}[${i}]
    END

Get Text And Ensure Headers Are Equal
    [Documentation]    Get header text from UI and match with expected text (Common locator for all headers)
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${locator}    @{expected_list}
    ${header_count}=    Get Element Count    ${locator}
    ${header_elements}=    Get WebElements    ${locator}
    FOR    ${i}    IN RANGE    0    ${header_count}
        ${ui_element}=    Get From List    ${header_elements}    ${i}
        ${ui_text}=    Get Text    ${ui_element}
        ${expected_text}=    Get From List    ${expected_list}    ${i}
        Should Be Equal    ${ui_text}    ${expected_text}
        Log    UI: ${ui_text}
        Log    Expected: ${expected_text}
    END

Clear All Textboxes
    [Documentation]    Click and clear all textboxes' values
    ...                @Author = VIMALKUMAR M
    [Arguments]    @{elements}
    FOR    ${element}    IN    @{elements}
        Click And Clear Textfield    ${element}
    END
    Capture The Screen    ClearAll

Select Dropdown By Label
    [Documentation]    Select dropdown options using 'Select From List By Label'
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${dropdown_elements}    ${dropdown_values}
    ${count}=    Get Length    ${dropdown_elements}
    FOR    ${i}    IN RANGE    0    ${count}
        Click Element Until Visible    ${dropdown_elements}[${i}]
        Log    ${dropdown_values}[${i}]
        Select From List By Label    ${dropdown_elements}[${i}]    ${dropdown_values}[${i}]
        Capture The Screen    Selected_DD_Option
    END

Select Dropdown Option By Text
    [Documentation]    Select dropdown option by navigating and matching with text
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${dropdown_options}    ${select_value}    ${dropdown_button}
    Click Element Until Visible    ${dropdown_button}
    ${options}=    Get WebElements    ${dropdown_options}
    ${count}=    Get Length    ${options}
    FOR    ${i}    IN RANGE    0    ${count}
        ${text}=    Get Text    ${options}[${i}]
        Press Key    ${options}[${i}]    ARROW_DOWN
        Run Keyword If    "${text}" == "${select_value}"    
        ...    Run Keywords    Click Element Until Visible    ${options}[${i]}
        ...    AND    Exit For Loop
    END
    Capture The Screen    ${select_value}_0

Verify Input Field Values
    [Documentation]    Verify the value in textboxes is equal to input
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${count}    ${elements}    ${expected_values}
    FOR    ${i}    IN RANGE    1    ${count}
        Entered Value Should Be Equal    ${elements}[${i}]    ${expected_values}[${i}]
    END

Element Should Be Disabled
    [Documentation]    Validate the element should be disabled
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${element_text}
    Element Should Be Visible    //*[@value='${element_text}' and contains(@class, 'disabled')]

Element Should Be Enabled
    [Documentation]    Validate the element should be enabled
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${element_text}
    Element Should Be Visible    //*[@value='${element_text}' and not(contains(@class, 'disabled'))]

Format XPath With Value List
    [Documentation]    Format locators using input data
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${locators}    ${input_data}
    ${count}=    Get Length    ${locators}
    @{formatted_elements}=    Create List
    FOR    ${i}    IN RANGE    0    ${count}
        ${formatted}=    Format String    ${locators}[${i}]    value=${input_data}[${i}]
        Append To List    ${formatted_elements}    ${formatted}
    END
    RETURN    ${formatted_elements}

List Should Contain All UI Items
    [Documentation]    List should contains multiple UI items
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${ui_list}    ${api_list}
    FOR    ${item}    IN    @{ui_list}
        Should Contain    ${api_list}    ${item}
    END

List Should Not Contain Any UI Items
    [Documentation]    List should not contains multiple UI items
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${ui_list}    ${api_list}
    FOR    ${item}    IN    @{ui_list}
        Should Not Contain    ${api_list}    ${item}
    END

Click Element Using JavaScript
    [Documentation]    Click element using JavaScript and XPath
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${element}
    ${locator}=    Get WebElement    ${element}
    Execute JavaScript    arguments[0].click();    ARGUMENTS    ${locator}

Click Element By Id Using JS
    [Documentation]    Click element using JavaScript with element by ID
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${element_id}
    Execute JavaScript    document.getElementById("${element_id}").click()

Click Element By Class Using DOM
    [Documentation]    Click element using DOM with class name
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${class_name}
    Click Element Until Visible    dom=document.getElementsByClassName("${class_name}")[0]

Click Element By Text Using DOM
    [Documentation]    Click element using DOM with text content
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${text}
    Click Element Until Visible    dom:document.data:"${text}"

Generate Random Email
    [Documentation]    Generate a random email address
    ...                @Author = VIMALKUMAR M
    ${domain}    Set Variable    example.com
    ${random_string}    Generate Random String    10
    ${email}    Set Variable    ${random_string}@${domain}
    Log    ${email}
    RETURN    ${email}

Double Click Web Element
    [Documentation]    Double click the specified web element
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${locator}    ${timeout}=10
    Wait Until Element Is Visible    ${locator}    timeout=${timeout}
    Double Click Element    ${locator}
    Sleep    1s

Page Should Contain Checkbox
    [Documentation]    Ensure the page contains the checkbox element
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${checkbox_locator}
    Sleep    3s
    Page Should Contain Checkbox    ${checkbox_locator}

Checkbox Should Not Be Selected
    [Documentation]    Ensure checkbox is present and not selected
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${checkbox_id}
    ${check_status}=    Execute JavaScript    return document.getElementById("${checkbox_id}").checked;
    Log    Check status: ${check_status}
    Should Not Be True    ${check_status}

Checkbox Should Be Selected
    [Documentation]    Ensure checkbox is present and selected
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${checkbox_id}
    ${check_status}=    Execute JavaScript    return document.getElementById("${checkbox_id}").checked;
    Log    Check status: ${check_status}
    Should Be True    ${check_status}

Select Checkbox If Not Selected
    [Documentation]    Select the checkbox only if it's not already selected
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${checkbox_id}
    ${check_status}=    Execute JavaScript    return document.getElementById("${checkbox_id}").checked;
    Log    Initial status: ${check_status}
    Run Keyword If    ${check_status} == False    Click Checkbox Using JS    ${checkbox_id}    ${check_status}
    ...    ELSE    Log    Checkbox already selected

Unselect Checkbox If Selected
    [Documentation]    Unselect the checkbox if it's selected
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${checkbox_id}
    ${check_status}=    Execute JavaScript    return document.getElementById("${checkbox_id}").checked;
    Log    Initial status: ${check_status}
    Run Keyword If    ${check_status} == True    Click Checkbox Using JS    ${checkbox_id}    ${check_status}

Click Checkbox Using JS
    [Documentation]    Click the checkbox using JavaScript and validate status change
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${checkbox_id}    ${old_status}
    Execute JavaScript    document.getElementById("${checkbox_id}").click()
    ${new_status}=    Execute JavaScript    return document.getElementById("${checkbox_id}").checked;
    Log    New check status: ${new_status}
    Should Not Be Equal    ${new_status}    ${old_status}
    Capture Page Screenshot

Validate Texts Match In Elements
    [Documentation]    Compare list of UI element texts with expected list
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${locator}    @{expected_list}
    ${count}=    Get Element Count    ${locator}
    ${elements}=    Get Webelements    ${locator}
    FOR    ${index}    IN RANGE    0    ${count}
        ${element}=    Get From List    ${elements}    ${index}
        ${text}=    Get Text    ${element}
        ${expected}=    Get From List    ${expected_list}    ${index}
        Should Contain    ${text}    ${expected}
        Log    Actual: ${text}
        Log    Expected: ${expected}
    END

Clean Price Value
    [Documentation]    Remove unwanted characters from price value
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${raw_text}
    ${cleaned}=    Replace String    ${raw_text}    :    ${SPACE}
    ${cleaned}=    Replace String    ${cleaned}    QAR    ${SPACE}
    ${cleaned}=    Strip String    ${cleaned}
    Log    Cleaned price: ${cleaned}
    RETURN    ${cleaned}

Read Csv File
    [Documentation]    Read CSV file with UTF-8 encoding
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${csv_file}
    ${csv_data}=    Evaluate    pandas.read_csv(r'${csv_file}', encoding='utf-8').to_dict(orient='records')    modules=pandas
    ${row_count}=    Get Length    ${csv_data}
    Log    CSV file read successfully with total rows: ${row_count}
    RETURN    @{csv_data}

Click The First Record From Filter
    [Documentation]    Click the first record from the table that matches the filter value
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${search_input}
    Execute Javascript    $('td:contains(${search_input})').first().click()

Broken Links Test
    [Documentation]    Check for broken links on the page
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${BASE_URL}
    ${element_list}=    Get Webelements    xpath=//a[@href]
    ${href_list}=    Evaluate    [item.get_attribute('href') for item in $element_list]
    Log    ${href_list}
    Create Session    testing    ${BASE_URL}
    FOR    ${element_href}    IN    @{href_list}
        ${uri}=    Remove String    ${element_href}    ${BASE_URL}
        ${contains_base_url}=    Evaluate    "${BASE_URL}" in "${element_href}"
        ${response}=    Run Keyword If    ${contains_base_url}    Get Request    testing    ${uri}
        Run Keyword If    ${contains_base_url}    Should Be Equal As Strings    ${response.status_code}    200
    END

Check All Images Broken Or Not
    [Documentation]    Validate if all the images on screen are not broken
    ...                @Author = VIMALKUMAR M
    ${img_count}=    Get Element Count    tag:img
    @{img_src}=    Create List
    FOR    ${img}    IN RANGE    1    ${img_count}+1
        ${index}=    Convert To Integer    ${img}
        ${src}=    Get Element Attribute    (//img)[${index}]    src
        Append To List    ${img_src}    ${src}
    END
    FOR    ${img}    IN    @{img_src}
        Create Session    broken_image    ${img}
        ${response}=    Get Request    broken_image    /
        Log    ${response}
        Should Be Equal As Strings    ${response.status_code}    200
    END

API Response Validation
    [Documentation]    Call API and validate response code is present in response
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${APIMethod}    ${Response_code}
    ${response}=    Call Method    ${pos_api}    ${APIMethod}
    Log To Console    ${response}
    Should Contain    '''${response}'''    ${Response_code}
    RETURN    ${response}

Get Element BG Colo rHex
    [Documentation]    Get the background color of an element and verify against expected hex color
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${element}    ${ExpectedColor}
    ${web_element}=    Get Webelement    ${element}
    ${color_rgba}=    Call Method    ${web_element}    value_of_css_property    background-color
    ${index}=    Evaluate    "${color_rgba}".find("(")
    ${color_tuple}=    Evaluate    eval("${color_rgba}"[${index}:])
    ${color_hex}=    Evaluate    '#{:02x}{:02x}{:02x}'.format(*${color_tuple})
    Should Be Equal    '${color_hex}'    ${ExpectedColor}
    RETURN    ${color_hex}

Get Element Color Hex
    [Documentation]    Get the text color of an element in hex format
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${element}
    ${web_element}=    Get Webelement    ${element}
    ${color_rgba}=    Call Method    ${web_element}    value_of_css_property    color
    ${index}=    Evaluate    "${color_rgba}".find("(")
    ${color_tuple}=    Evaluate    eval("${color_rgba}"[${index}:])
    ${color_hex}=    Evaluate    '#{:02x}{:02x}{:02x}'.format(*${color_tuple})
    RETURN    ${color_hex}

Get Text From Element
    [Documentation]    Wait for an element to be visible and return its text
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${TextID}
    Set Library Search Order    SeleniumLibrary
    Wait Until Element Is Visible    ${TextID}    timeout=${timeout}
    ${TEXTData}=    Get Text    ${TextID}
    RETURN    ${TEXTData}

Get Table Data Without API Call
    [Documentation]    Fetch table data from rows and columns without API call
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${Row_xpath}    ${column_xpath}
    @{Table_list}=    Create List
    ${columns}=    Get Element Count    ${Row_xpath}
    FOR    ${row}    IN RANGE    1    ${columns}
        ${data_table}=    HandleTableDataWithoutAPI    ${row}    ${column_xpath}
        Append To List    ${Table_list}    ${data_table}
    END
    RETURN    ${Table_list}

Handle Table Data Without API
    [Documentation]    Fetch individual table row data without API
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${test_row}    ${column_xpath}
    @{Table_list}=    Create List
    ${columns}=    Get Element Count    ${column_xpath}
    FOR    ${column}    IN RANGE    1    ${columns}
        ${data_table}=    Get Text    xpath=//tbody/tr[${test_row}]/td[${column}]
        Log To Console    ${data_table}
    END
    RETURN    ${Table_list}

Get Table Data With Last Column
    [Documentation]    Fetch table data including the last column
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${Row_xpath}    ${column_xpath}
    @{Table_list}=    Create List
    ${columns}=    Get Element Count    ${Row_xpath}
    FOR    ${row}    IN RANGE    1    ${columns}
        ${data_table}=    HandleTableDataWithLastColumn    ${row}    ${column_xpath}
        Append To List    ${Table_list}    ${data_table}
    END
    RETURN    ${Table_list}

Handle Table Data Without Last Column
    [Documentation]    Get table data row including the last column
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${test_row}    ${column_xpath}
    @{Table_list}=    Create List
    ${columns}=    Get Element Count    ${column_xpath}
    FOR    ${column}    IN RANGE    1    ${columns}+1
        ${data_table}=    Get Text    xpath=//tbody/tr[${test_row}]/td[${column}]
        Append To List    ${Table_list}    ${data_table}
        ${row_data1}=    Evaluate    ${test_row} - 1
        ${column_data1}=    Evaluate    ${column} - 1
        Log To Console    ${data_table}
    END
    RETURN    ${Table_list}

Get Full Table Data
    [Documentation]    Get the full table data using XPaths and response from API
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${Row_xpath}    ${Column_xpath}    ${CMCConnectionObj}    ${MethodName}
    @{Table_List}=    Create List
    ${Response}=    Call Method    ${CMCConnectionObj}    ${MethodName}
    ${Row_Count}=    Get Element Count    ${Row_xpath}
    FOR    ${Row}    IN RANGE    1    ${Row_Count}+1
        ${Data_Row}=    Handle Table Row Data    ${Row}    ${Column_xpath}    ${Response}
        Append To List    ${Table_List}    ${Data_Row}
    END
    RETURN    ${Table_List}

Handle Table Row Data
    [Documentation]    Extracts a single row of data from the UI table
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${Test_Row}    ${Column_xpath}    ${Response_Table_Data}
    @{Row_Data}=    Create List
    ${Column_Count}=    Get Element Count    ${Column_xpath}
    FOR    ${Column}    IN RANGE    1    ${Column_Count}
        ${Cell_Text}=    Get Text    xpath=//tbody/tr[${Test_Row}]/td[${Column}]
        Append To List    ${Row_Data}    ${Cell_Text}
        ${Row_Index}=    Evaluate    ${Test_Row} - 1
        ${Column_Index}=    Evaluate    ${Column} - 1
        # ${Expected}=    Convert To String    ${Response_Table_Data}[1][${Row_Index}][${Column_Index}]
        # Should Contain    ${Expected}    ${Cell_Text}
        Log To Console    ${Cell_Text}
    END
    RETURN    ${Row_Data}

Get Table Data Without Last Column
    [Documentation]    Get table data excluding the last column (usually action buttons or graphs)
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${Row_xpath}    ${Column_xpath}    ${MethodName}
    @{Table_List}=    Create List
    ${Row_Count}=    Get Element Count    ${Row_xpath}
    FOR    ${Row}    IN RANGE    1    ${Row_Count}+1
        ${Data_Row}=    Handle Table Row Data    ${Row}    ${Column_xpath}    ${MethodName}
        Append To List    ${Table_List}    ${Data_Row}
    END
    RETURN    ${Table_List}

Get Data From Bar Graph Widgets
    [Documentation]    Extracts tooltip values from bar graph widgets
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${DataXpath}    ${TooltipXpath}    ${MethodName}
    ${Default_Tooltip}=    Set Variable    0
    ${Response}=    Call Method    ${pos_api}    ${MethodName}
    @{Tooltip_List}=    Create List
    @{Graph_Bars}=    Get WebElements    ${DataXpath}
    ${Sum}=    Set Variable    0
    FOR    ${Bar}    IN    @{Graph_Bars}
        ${Height}=    Get Element Attribute    ${Bar}    height
        ${Height_Int}=    Convert To Integer    ${Height}
        Run Keyword If    ${Height_Int} == 0
        ...    Append To List    ${Tooltip_List}    ${Default_Tooltip}
        ...    ELSE
        ...    ${Value}=    Get Bar Graph Tooltip Value    ${Bar}    ${TooltipXpath}    ${Response}    ${Sum}
        ...    Append To List    ${Tooltip_List}    ${Value}
        ${Sum}=    Evaluate    ${Sum} + 1
    END
    RETURN    ${Tooltip_List}

Get Bar Graph Tooltip Value
    [Documentation]    Extract and validate tooltip value for a single bar in a graph
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${Bar_Element}    ${TooltipXpath}    ${Response}    ${Index}
    ${Expected}=    Convert To String    ${Response}[1][${Index}]
    Mouse Over    ${Bar_Element}
    ${Tooltip_Text}=    Get Text    ${TooltipXpath}
    Should Contain    ${Tooltip_Text}    ${Expected}
    Log To Console    ${Tooltip_Text}
    RETURN    ${Tooltip_Text}

Compare UI List With API List
    [Documentation]    Compares two lists - UI List vs API List
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${UI_List}    ${API_List}
    FOR    ${Item}    IN    @{UI_List}
        Should Contain    ${API_List}    ${Item}
    END

Get Data From Circle Widgets
    [Documentation]    Extracts tooltip data from circular chart widgets
    ...                @Author = VIMALKUMAR M
    [Arguments]    ${ElementXpath}    ${TooltipXpath}
    @{Tooltip_List}=    Create List
    @{Elements}=    Get WebElements    ${ElementXpath}
    FOR    ${Element}    IN    @{Elements}
        Mouse Over    ${Element}
        ${Tooltip}=    Get Text    ${TooltipXpath}
        Append To List    ${Tooltip_List}    ${Tooltip}
    END
    RETURN    ${Tooltip_List}

Handle Alert Popup
    [Documentation]  Handles a confirmation popup and clicks 'Yes'
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${AlertText}       ${YesButton}
    Wait Until Page Contains Element    ${YesButton}
    ${Alert_Message}=    Get Text       ${AlertText}
    Click Element    ${YesButton}

Verify Text Inside Iframe
    [Documentation]  Verifies if given text is present in the current iframe
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${TextValue}
    Current Frame Should Contain    ${TextValue}

Verify Iframe Content From Main Frame
    [Documentation]  Verifies content inside an iframe from the main frame
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${IframeId}    ${TextValue}
    Frame Should Contain    ${IframeId}    ${TextValue}

Select Iframe
    [Documentation]  Switches context to the given iframe
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${Iframe_Id}
    Select Frame     ${Iframe_Id}

Switch To Main Frame
    [Documentation]  Switches back to the main frame.
    ...              @Author = VIMALKUMAR M
    Unselect Frame

Element Count Should Be At Least One
    [Documentation]  Verifies the given locator has at least one element.
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${locator}
    Sleep            2
    ${count}=        Get Element Count    ${locator}
    Should Be True   ${count} > 0

Move To Last Screen
    [Documentation]  Navigates to the last screen if available.
    ...              @Author = VIMALKUMAR M
    ${present}=      Run Keyword And Return Status    Element Should Be Visible    //*[text()='Last' and not(contains(@class, 'disabled'))]
    Run Keyword If   ${present}    Click Element    (//*[text()='Last'])[1]
    ...              ELSE          Log To Console    First and Last buttons are disabled

Get Table Row Index By Text
    [Documentation]  Returns the row index of the table cell matching the given text.
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${table_css_locator}    ${text}
    Sleep            2
    ${row_index}=    Execute Javascript    return ${table_css_locator}.find("td:contains(${text})").parent("tr").index()
    RETURN           ${row_index}

Check YAxis Score Num
    [Documentation]  Validates the Y-axis scores are not null and count is more than one.
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${y_axis_score}
    ${count}=        Get Element Count    ${y_axis_score}
    Log              y_axis_score_num: ${count}
    Should Be True   ${count} > 1
    FOR              ${i}  IN RANGE    ${count}
        ${scale}=    Get Text    (${y_axis_score})\[${i}+1\]
        Log          ==scale_value: ${scale}
        Should Not Contain    ${scale}    null
    END

Get Checkbox
    [Documentation]  Returns whether a checkbox is selected.
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${locator}
    ${value}=        Run Keyword And Return Status    Checkbox Should Be Selected    ${locator}
    RETURN           ${value}

Set Checkbox
    [Documentation]  Sets a checkbox to the desired value.
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${locator}    ${visible_locator}    ${value}
    ${original}=     Get Checkbox    ${locator}
    Run Keyword Unless    '${original}' == '${value}'    Click Element    ${visible_locator}
    Log              original: ${original}, set to: ${value}

Modify Input Text
    [Documentation]  Sets input field text if it differs from the original.
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${locator}    ${value}
    ${original}=     Get Text By Id    ${locator}
    Log              original: ${original}, set to: ${value}
    Run Keyword Unless    '${original}' == '${value}'    Input Text    ${locator}    ${value}

Get Text By Id
    [Documentation]  Returns the text value of an input field by its ID.
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${element_id}
    ${value}=        Execute Javascript    return $("#${element_id}").val()
    RETURN           ${value}

Input Text By Id Should Be
    [Documentation]  Validates the input text by ID is as expected.
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${id}    ${expected_text}
    ${actual}=       GetTextById    ${id}
    Should Be Equal  ${actual}    ${expected_text}

Should Be Equal As Boolean
    [Documentation]  Validates that both values are equal as booleans.
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${var1}    ${var2}
    ${bool1_type}=   Evaluate    type(${var1}) is bool
    ${bool1}=        Run Keyword Unless    ${bool1_type}    Convert To Boolean    ${var1}
    ...              ELSE    Set Variable    ${var1}
    ${bool2_type}=   Evaluate    type(${var2}) is bool
    ${bool2}=        Run Keyword Unless    ${bool2_type}    Convert To Boolean    ${var2}
    ...              ELSE    Set Variable    ${var2}
    Should Be Equal  ${bool1}    ${bool2}

Should Be Integer
    [Documentation]  Validates if a variable is of integer type.
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${var}
    ${stripped}=     Strip String    ${var}
    ${is_int}=       Evaluate    isinstance(${stripped}, int)
    Should Be True   ${is_int}

Get Percentage Value
    [Documentation]  Extracts numeric value from percentage string.
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${var}
    ${stripped}=     Strip String    ${var}
    ${percentage}=   Fetch From Left    ${stripped}    %
    RETURN           ${percentage}

Table Row Should Contain Element
    [Documentation]  Validates that a specific element exists within a table row.
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${table_css_locator}    ${row}    ${element_css}
    ${locator}=      Set Variable    dom:${table_css_locator}.find('tr').eq(${row}).find('${element_css}')
    Wait Until Element Is Visible    ${locator}
    RETURN           ${locator}

Get Column Index By Table Header
    [Documentation]  Returns column index by matching table header text.
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${table_css_locator}    ${th}
    ${index}=        Execute Javascript    return ${table_css_locator}.find("th:contains(${th})").index()
    RETURN           ${index}

Get Table Cel lBy Jquery
    [Documentation]  Returns the text from a specific table cell using row and column.
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${table_css_locator}    ${row}    ${column}
    ${value}=        Execute Javascript    return ${table_css_locator}.find("tr:not(:has(th))").eq(${row}).find("td").eq(${column}).text()
    RETURN           ${value}

Get Uniq Num String
    [Documentation]  Returns a unique number string based on the timestamp.
    ...              @Author = VIMALKUMAR M
    ${now}=          Get Current Date    result_format=timestamp
    ${epoch}=        Convert Date        ${now}    epoch
    ${timestamp}=    Evaluate            int(round(${epoch} * 1000))
    RETURN           ${timestamp}

Table Data Validation With Drill Down Data
    [Documentation]  Validates the table data against the API response with drill down.
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${Row_xpath}    ${column_xpath}    ${methodname}    ${Table_ID}
    Set Selenium Implicit Wait    60 seconds
    Set Selenium Timeout          60 seconds
    ${response}=     Call Method    ${pos_api}    ${methodname}
    Sleep            5
    ${rows}=         Get Element Count    ${Row_xpath}
    FOR              ${row}  IN RANGE  1  ${rows}
        Handle Table Drill Down    ${row}    ${response}    ${column_xpath}    ${Table_ID}
    END

Handle Table Drill Down
    [Documentation]  Handles each row and column validation for drill down table data.
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${test_row}    ${api_response}    ${column_xpath}    ${Table_ID}
    Set Selenium Implicit Wait    60 seconds
    Set Selenium Timeout          60 seconds
    ${columns}=      Get Element Count    ${column_xpath}
    FOR              ${column}  IN RANGE  1  ${columns}
        ${ui_text}=      Get Text    //*[@id='${Table_ID}']//tbody/tr[${test_row}]/td[${column}]
        Log To Console    ${ui_text}
        ${r}=            Evaluate    ${test_row} - 1
        ${c}=            Evaluate    ${column} - 1
        ${api_text}=     Convert To String    ${api_response}[1][${r}][${c}]
        Should Contain   ${api_text}    ${ui_text}
    END

Table Data Validation With Drill Down Data Limit
    [Documentation]  Validates table data when number of rows is less or greater than 10.
    ...              @Author = VIMALKUMAR M
    [Arguments]      ${Row_xpath}    ${column_xpath}    ${methodname}    ${Table_ID}
    Set Selenium Implicit Wait    60 seconds
    Set Selenium Timeout          60 seconds
    ${response}=     Call Method    ${pos_api}    ${methodname}
    Sleep            5
    ${rows}=         Get Element Count    ${Row_xpath}
    Run Keyword If   ${rows} > 10    ValidateDataWhenGreater10    ${response}    ${column_xpath}    ${Table_ID}
    ...              ELSE            ValidateDataWhenLess10       ${response}    ${column_xpath}    ${Table_ID}