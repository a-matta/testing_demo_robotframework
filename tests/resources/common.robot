*** Settings ***
Library     DateTime
Library     FakerLibrary


*** Variables ***
${BASE_URL}     http://localhost:8080


*** Keywords ***
Create New User Data In Test Context
    [Documentation]    Creates unique username and fake userdetails. Set them in test variables.
    ${value}    Get Current Date    time_zone=utc    result_format=epoch
    ${value}    Convert To String    ${value}
    Set Test Variable    ${USERNAME}    ${value}
    ${value}    FakerLibrary.Password
    Set Test Variable    ${PASSWORD}    ${value}
    ${value}    FakerLibrary.First Name
    Set Test Variable    ${FIRSTNAME}    ${value}
    ${value}    FakerLibrary.Last Name
    Set Test Variable    ${LASTNAME}    ${value}
    ${value}    FakerLibrary.Phone Number
    Set Test Variable    ${PHONE}    ${value}
