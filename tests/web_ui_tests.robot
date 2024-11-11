*** Settings ***
Library             SeleniumLibrary
Resource            ./resources/common.robot

Test Setup          Open UI Application
Test Teardown       Close All Browsers


*** Variables ***
${BROWSER}              chrome
${LOGIN_PAGE}           ${BASE_URL}/login
${REGISTER_PAGE}        ${BASE_URL}/register
${USER_PAGE}            ${BASE_URL}/user
${LOGOUT_LINK}          xpath://a[@href='/logout' and text()='Log Out']
${REGISTER_LINK}        xpath://a[@href='/register' and text()='Register']
${USERNAME_INPUT}       id:username
${PASSWORD_INPUT}       id:password
${FIRSTNAME_INPUT}      id:firstname
${FAMILY_NAME_INPUT}    id:lastname
${PHONE_INPUT}          id:phone
${REGISTER_BUTTON}      xpath://input[@type='submit' and @value='Register']
${LOGIN_BUTTON}         xpath://input[@type='submit' and @value='Log In']
${USERNAME_INFO}        xpath://td[@id='username']
${FIRSTNAME_INFO}       xpath://td[@id='firstname']
${LASTNAME_INFO}        xpath://td[@id='lastname']
${PHONE_INFO}           xpath://td[@id='phone']


*** Test Cases ***
New User Can Register And Login To Check Own Data
    Create New User Data In Test Context
    Register User
    ${USER_ALREADY_REGISTERED_ERROR}    Catenate    User    ${USERNAME}    is already registered.
    Page Should Not Contain Element
    ...    xpath://div[@class='flash' and contains(text(), '${USER_ALREADY_REGISTERED_ERROR}')]
    Login User
    Page Should Contain Element    ${LOGOUT_LINK}
    Verify User Information Is Displayed

Login Fails If Username and Password Does Not Match
    Create New User Data In Test Context
    Register User
    Location Should Be    ${LOGIN_PAGE}
    Input Text    ${USERNAME_INPUT}    ${USERNAME}
    Input Password    ${PASSWORD_INPUT}    ${PASSWORD}1
    Click Element    ${LOGIN_BUTTON}
    Page Should Contain Element    xpath://p[contains(text(), 'You provided incorrect login details')]

Duplicate Username Registration Is Not Allowed
    Create New User Data In Test Context
    Register User
    ${USER_ALREADY_REGISTERED_ERROR}    Catenate    User    ${USERNAME}    is already registered.
    Page Should Not Contain Element
    ...    xpath://div[@class='flash' and contains(text(), '${USER_ALREADY_REGISTERED_ERROR}')]
    Register User
    Page Should Contain Element    xpath://div[@class='flash' and contains(text(), '${USER_ALREADY_REGISTERED_ERROR}')]

User Details Are Not Shown If User Is Not Logged In
    Go To    ${USER_PAGE}
    Page Should Not Contain Element    ${USERNAME_INFO}
    Page Should Not Contain Element    ${FIRSTNAME_INFO}
    Page Should Not Contain Element    ${LASTNAME_INFO}
    Page Should Not Contain Element    ${PHONE_INFO}


*** Keywords ***
Open UI Application
    Open Browser    ${BASE_URL}    ${BROWSER}

Register User
    [Documentation]    Navigates to register page, enter user details from context and pushes the register button.
    Click Element    ${REGISTER_LINK}
    Input Text    ${USERNAME_INPUT}    ${USERNAME}
    Input Password    ${PASSWORD_INPUT}    ${PASSWORD}
    Input Text    ${FIRSTNAME_INPUT}    ${FIRSTNAME}
    Input Text    ${FAMILY_NAME_INPUT}    ${LASTNAME}
    Input Text    ${PHONE_INPUT}    ${PHONE}
    Click Element    ${REGISTER_BUTTON}

Verify User Information Is Displayed
    [Documentation]    Verifies that location is user details page and verifies the user details with respect to data in context.
    Location Should Be    ${USER_PAGE}
    Element Text Should Be    ${USERNAME_INFO}    ${USERNAME}
    Element Text Should Be    ${FIRSTNAME_INFO}    ${FIRSTNAME}
    Element Text Should Be    ${LASTNAME_INFO}    ${LASTNAME}
    Element Text Should Be    ${PHONE_INFO}    ${PHONE}

Login User
    [Documentation]    Verifies that location is login page, user can login and pushes login button.
    Location Should Be    ${LOGIN_PAGE}
    Input Text    ${USERNAME_INPUT}    ${USERNAME}
    Input Password    ${PASSWORD_INPUT}    ${PASSWORD}
    Click Element    ${LOGIN_BUTTON}
