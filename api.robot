*** Settings ***
Documentation    API tests for reqres

Library    api_calls.py
Library    data_validation.py

Suite Setup    Set Log Level  DEBUG

Force Tags    api


*** Test Cases ***
CRUD valid user
    Register user    eve.holt@reqres.in    123456
    Fetch user data    4
    Update user data    4
    Delete user    4

Validate unsuccessful login
    Login with invalid email    hello@mail.com

Validate user list schema
    ${response}    Get user list    1    4
    Validate user list schema    ${response}