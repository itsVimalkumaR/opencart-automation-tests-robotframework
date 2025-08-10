*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${URL}            https://example.com

*** Test Cases ***
Zoom In Browser View
    [Documentation]    Zoom in the browser view using JavaScript.
    Open Browser    ${URL}    chrome
    Zoom In Browser    3
    Sleep    2s
    Close Browser

Zoom Out Browser View
    [Documentation]    Zoom out the browser view using JavaScript.
    Open Browser    ${URL}    chrome
    Zoom Out Browser    2
    Sleep    2s
    Close Browser

Reset Zoom Level
    [Documentation]    Reset zoom level to 100%.
    Open Browser    ${URL}    chrome
    Reset Zoom Browser
    Sleep    2s
    Close Browser

*** Keywords ***
Zoom In Browser
    [Arguments]    ${times}=1
    FOR    ${i}    IN RANGE    ${times}
        Execute Javascript    document.body.style.zoom = (parseFloat(document.body.style.zoom || 1) + 0.1).toFixed(1);
    END

Zoom Out Browser
    [Arguments]    ${times}=1
    FOR    ${i}    IN RANGE    ${times}
        Execute Javascript    document.body.style.zoom = (parseFloat(document.body.style.zoom || 1) - 0.1).toFixed(1);
    END

Reset Zoom Browser
    Execute Javascript    document.body.style.zoom = "1.0"
