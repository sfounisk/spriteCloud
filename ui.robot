*** Settings ***
Documentation    UI tests for saucedemo

Library    Browser
Library	   String

Test Setup    New Page    ${URL}
Suite Setup    Set Log Level  DEBUG

Force Tags    happy_flow


*** Variables ***
${URL}    https://www.saucedemo.com


*** Test Cases ***
Validate errors in login page
    Click    id=login-button
    ${error_msg}=    Get Text    //h3
    Should Be Equal    ${error_msg}    Epic sadface: Username is required
    Fill Text    id=user-name    testName
    Click    id=login-button
    ${error_msg}=    Get Text    //h3
    Should Be Equal    ${error_msg}    Epic sadface: Password is required
    #Fill Text    id=user-name    testName
    Fill Text    id=password    Invalid
    Click    id=login-button
    ${error_msg}=    Get Text    //h3
    Should Be Equal    ${error_msg}    Epic sadface: Username and password do not match any user in this service
    Fill Text    id=user-name    locked_out_user
    Fill Text    id=password    secret_sauce
    Click    id=login-button
    ${error_msg}=    Get Text    //h3
    Should Be Equal    ${error_msg}    Epic sadface: Sorry, this user has been locked out.


E2E test for valid user
    Login valid customer

    # Get text from item 4
    ${title_1}=    Get Text    a#item_4_title_link
    ${description_1}=    Get Text    xpath=//a[@id="item_4_title_link"]/following-sibling::div[@class="inventory_item_desc"]
    ${price_1}=    Get Text    xpath=//button[@id="add-to-cart-sauce-labs-backpack"]/preceding-sibling::div[@class="inventory_item_price"]
    ${clear_price_1}=    Replace String    ${price_1}    $     \

    Click    button#add-to-cart-sauce-labs-backpack

    Validate quantity of items in cart    1

    # Get text from item 5
    ${title_2}=    Get Text    a#item_5_title_link
    ${description_2}=    Get Text    xpath=//a[@id="item_5_title_link"]/following-sibling::div[@class="inventory_item_desc"]
    ${price_2}=    Get Text    xpath=//button[@id="add-to-cart-sauce-labs-fleece-jacket"]/preceding-sibling::div[@class="inventory_item_price"]
    ${clear_price_2}=    Replace String    ${price_2}    $     \

    Click    a#item_5_title_link
    Click    button#add-to-cart

    Validate quantity of items in cart    2

    Click    a[data-test="shopping-cart-link"]
    ${current_url}=    Get Url
    Should Be Equal    ${current_url}    ${URL}/cart.html

    # Data validation in cart page (item 1)
    ${cart_title_1}=    Get Text    a#item_4_title_link
    ${cart_description_1}=    Get Text    xpath=//a[@id="item_4_title_link"]/following-sibling::div[@class="inventory_item_desc"]
    ${cart_price_1}=    Get Text    xpath=//button[@id="remove-sauce-labs-backpack"]/preceding-sibling::div[@class="inventory_item_price"]
    ${cart_clear_price_1}=    Replace String    ${cart_price_1}    $     \
    Should Be Equal    ${title_1}    ${cart_title_1}
    Should Be Equal    ${description_1}    ${cart_description_1}
    Should Be Equal    ${clear_price_1}    ${cart_clear_price_1}

    # Data validation in cart page (item 2)
    ${cart_title_2}=    Get Text    a#item_5_title_link
    ${cart_description_2}=    Get Text    xpath=//a[@id="item_5_title_link"]/following-sibling::div[@class="inventory_item_desc"]
    ${cart_price_2}=    Get Text    xpath=//button[@id="remove-sauce-labs-fleece-jacket"]/preceding-sibling::div[@class="inventory_item_price"]
    ${cart_clear_price_2}=    Replace String    ${cart_price_2}    $     \
    Should Be Equal    ${title_2}    ${cart_title_2}
    Should Be Equal    ${description_2}    ${cart_description_2}
    Should Be Equal    ${clear_price_2}    ${cart_clear_price_2}

    Click    button#checkout

    Fill Text    input#first-name    testName
    Fill Text    input#last-name    testLastName
    Fill Text    input#postal-code    1212as

    Click    input#continue

    # Calculate prices and taxes
    ${subtotal}=    Evaluate    ${clear_price_1} + ${clear_price_2}
    ${tax}=    Evaluate    round(${subtotal} * 0.08, 2)
    ${total}=    Evaluate    round(${subtotal} + ${tax}, 2)

    ${get_subtotal}=    Get Text    xpath=//div[@data-test="subtotal-label"]
    ${match_subtotal}=    Get Regexp Matches    ${get_subtotal}    \\d+\\.\\d+
    ${clean_subtotal}=    Set Variable    ${match_subtotal[0]}
    Should Be Equal As Strings   ${subtotal}    ${clean_subtotal}

    ${get_tax}=    Get Text    xpath=//div[@data-test="tax-label"]
    ${match_tax}=    Get Regexp Matches    ${get_tax}    \\d+\\.\\d+
    ${clean_tax}=    Set Variable    ${match_tax[0]}
    Should Be Equal As Numbers   ${tax}    ${clean_tax}

    ${get_total}=    Get Text    xpath=//div[@data-test="total-label"]
    ${match_total}=    Get Regexp Matches    ${get_total}    \\d+\\.\\d+
    ${clean_total}=    Set Variable    ${match_total[0]}
    Should Be Equal As Strings   ${total}    ${clean_total}

    Click    button#finish

    ${thank_you}=    Get Text    xpath=//h2
    Should Be Equal    ${thank_you}    Thank you for your order!

Validate inventory item page
    Login valid customer

    #Get text from item 1
    ${title}=    Get Text    a#item_4_title_link
    ${description}=    Get Text    xpath=//a[@id="item_4_title_link"]/following-sibling::div[@class="inventory_item_desc"]
    ${price}=    Get Text    xpath=//button[@id="add-to-cart-sauce-labs-backpack"]/preceding-sibling::div[@class="inventory_item_price"]

    Click    a#item_4_title_link

    ${item_title}=    Get Text    div[data-test="inventory-item-name"]
    ${item_description}=    Get Text    div[data-test="inventory-item-desc"]
    ${item_price}=    Get Text    div[data-test="inventory-item-price"]
    
    # Verify in inventory-item page
    Should Be Equal    ${title}    ${item_title}
    Should Be Equal    ${description}    ${item_description}
    Should Be Equal    ${price}    ${item_price}

*** Keywords ***
Login valid customer
    Fill Text    input#user-name    standard_user
    Fill Text    input#password    secret_sauce
    Click    input#login-button

Validate quantity of items in cart
    [Arguments]    ${quantity}
    ${get_cart_number}    Get Text    span[data-test="shopping-cart-badge"]
    Should Be Equal   ${get_cart_number}    ${quantity}