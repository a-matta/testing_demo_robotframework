*** Settings ***
Library         ./libraries/ApiConsumer.py
Library         Collections
Resource        ./resources/common.robot

Test Setup      Setup ApiConsumer BaseURL


*** Variables ***
${API_URL}      ${BASE_URL}/api


*** Test Cases ***
New User Can Be Registered And Its Data Fetched
    Create New User
    ${TOKEN}    Fetch Token For User In Context
    &{EXPECTED_USER_DETAILS}    Create Dictionary    firstname=${FIRSTNAME}    lastname=${LASTNAME}    phone=${PHONE}
    Fetch And Assert User Details    ${TOKEN}    ${EXPECTED_USER_DETAILS}

Token Fetching Fails If Username And Passwords Do Not Match
    Create New User
    ${RESPONSE}    Get Auth Token    ${USERNAME}    ${PASSWORD}1
    Assert Failure    ${RESPONSE}

Duplicate Username Registration Is Not Allowed
    Create New User
    ${RESPONSE}    Create User    ${USERNAME}    ${PASSWORD}1    ${FIRSTNAME}1    ${LASTNAME}1    ${PHONE}1
    Assert Failure    ${RESPONSE}

User Details Cannot Be Fetched Without Token
    ${RESPONSE}    Get User    ${EMPTY}    someuser
    Assert Failure    ${RESPONSE}

Users List Cannot Be Fetched Without Token
    ${RESPONSE}    Get All Users    ${EMPTY}
    Assert Failure    ${RESPONSE}

Users List Contains Newly Created User
    Create New User
    ${TOKEN}    Fetch Token For User In Context
    ${RESPONSE}    Get All Users    ${TOKEN}
    Assert Success    ${RESPONSE}
    ${USERS_LIST}    Get From Dictionary    ${RESPONSE}    payload
    List Should Contain Value    ${USERS_LIST}    ${USERNAME}

User Information Can Be Updated
    Create New User
    ${TOKEN}    Fetch Token For User In Context
    ${RESPONSE}    Update User
    ...    ${TOKEN}
    ...    ${USERNAME}
    ...    firstname=${FIRSTNAME}1
    ...    lastname=${LASTNAME}1
    ...    phone=${PHONE}1
    Assert Success    ${RESPONSE}
    &{EXPECTED_USER_DETAILS}    Create Dictionary
    ...    firstname=${FIRSTNAME}1
    ...    lastname=${LASTNAME}1
    ...    phone=${PHONE}1
    Fetch And Assert User Details    ${TOKEN}    ${EXPECTED_USER_DETAILS}


*** Keywords ***
Setup ApiConsumer BaseURL
    [Documentation]    Sets the api url in api consumer library.
    Set Api Url    ${API_URL}

Create New User
    [Documentation]    Creates a new user and validates sucessful response.
    Create New User Data In Test Context
    ${RESPONSE}    Create User    ${USERNAME}    ${PASSWORD}    ${FIRSTNAME}    ${LASTNAME}    ${PHONE}
    Assert Success    ${RESPONSE}

Fetch Token For User In Context
    [Documentation]    Fetches authorization token from api and returns token.
    ${RESPONSE}    Get Auth Token    ${USERNAME}    ${PASSWORD}
    Assert Success    ${RESPONSE}
    ${TOKEN}    Get From Dictionary    ${RESPONSE}    token
    RETURN    ${TOKEN}

Fetch And Assert User Details
    [Documentation]    Get the user details using the provided token and validate that the returned details match the passed argument.
    [Arguments]    ${TOKEN}    ${EXPECTED_USER_DETAILS}
    ${RESPONSE}    Get User    ${TOKEN}    ${USERNAME}
    Assert Success    ${RESPONSE}
    ${USER_DETAILS}    Get From Dictionary    ${RESPONSE}    payload
    Dictionaries Should Be Equal    ${EXPECTED_USER_DETAILS}    ${USER_DETAILS}
