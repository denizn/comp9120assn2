
CREATE TABLE IF NOT EXISTS MUTUAL_FUND 
    (
        SYMBOL CHAR(3) PRIMARY KEY,
        NAME VARCHAR(10) NOT NULL,
        DESCRIPTION VARCHAR(30),
        CATEGORY VARCHAR(10),
        T_NUM_SHARES INTEGER,
        C_DATE DATE NOT NULL,
        COMPANY_ID INTEGER REFERENCES COMPANY ON DELETE CASCADE ##relationship between mutual_fund and company
    );

#####closing_price is a weak entity type
CREATE TABLE IF NOT EXISTS closing_price
(
    PRICE INTEGER,
    P_DATE DATE NOT NULL,
    SYMBOL CHAR(3) REFERENCES MUTUAL_FUND ##should we add "on delete cascade"
    PRIMARY KEY (P_DATE,SYMBOL)
);

CREATE TABLE IF NOT EXISTS LOCATION
    (
        LOCATION_ID INTEGER PRIMARY KEY,
        STATE VARCHAR(3) DEFAULT "NSW", ##additional details 
        CITY VARCHAR(10),
        POSTCODE VARCHAR(5)
    );

CREATE TABLE IF NOT EXISTS COMPANY
    (
        COMPANY_ID INTEGER PRIMARY KEY,
        NAME VARCHAR(30) NOT NULL,
        CEO_lname VARCHAR(20),
        CEO_fname VARCHAR(20),
        LOCATION_ID INTEGER REFERENCES LOCATION
    );

CREATE TABLE IF NOT EXISTS USERS
    (
        LOGIN VARCHAR(30) PRIMARY KEY,
        EMAIL VARCHAR(30),
        NAME VARCHAR(30),
        ADDRESS VARCHAR(50),
        PASSWORD VARCHAR(15)
    );

CREATE TABLE IF NOT EXISTS CUSTOMER
    (
        CUSTOMER_ID VARCHAR(30) REFERENCES USERS(LOGIN) PRIMARY KEY,
        BALANCES FLOAT
    );

##relationship schema between mutual_fund and customer --> "prefers"
CREATE TABLE IF NOT EXISTS R_PREFER
    (
        SYMBOL CHAR(3), ##mutual_fund entity's primary key
        COMPANY_ID INTEGER, ##mutual_fund entity has exactly one company
        PERCENTAGE INTEGER,  ##relationship's attribute 
        CUSTOMER_ID VARCHAR(30), ##customer entity's primary key
        PRIMARY KEY (SYMBOL, COMPANY_ID, CUSTOMER_ID) 
    );

CREATE TABLE IF NOT EXISTS R_OWNS
    (
        SYMBOL CHAR(3), ##mutual_fund entity's primary key
        COMPANY_ID INTEGER, ##mutual_fund entity has exactly one company
        SHARES INTEGER,  ##relationship's attribute 
        CUSTOMER_ID VARCHAR(30), ##customer entity's primary key
        PRIMARY KEY (SYMBOL, COMPANY_ID, CUSTOMER_ID) 
    );

CREATE TABLE IF NOT EXISTS R_PROFOLIO_ACTION
    (
        SYMBOL CHAR(3), ##mutual_fund entity's primary key
        COMPANY_ID INTEGER, ##mutual_fund entity has exactly one company
        SHARES INTEGER,  ##relationship's attribute
        t_date DATE NOT NULL,
        PRICE INTEGER,
        AMOUNT INTEGER,
        NUM_SHARES INTEGER,
        ACTION VARCHAR (10),
        CUSTOMER_ID VARCHAR(30), ##customer entity's primary key
        TRANS_ID INTEGER,
        PRIMARY KEY (SYMBOL, COMPANY_ID, CUSTOMER_ID, TRANS_ID),
        CHECK (AMOUNT = NUM_SHARES), ##adtional details 
        CHECK (ACTION = 'sell' or ACTION = 'buy') ##adtional details 
    );


CREATE TABLE IF NOT EXISTS ADMINISTRATOR
    (
        ADMINISTRATOR_ID VARCHAR(30) REFERENCES USERS(LOGIN) PRIMARY KEY,
    );

CREATE TABLE TRANSACTIONS
    (
        TRANS_ID INTEGER PRIMARY KEY,
    );

CREATE TABLE INV_TRANS
    (
        TRANS_ID INTEGER REFERENCES TRANSACTIONS PRIMARY KEY
    );

CREATE TABLE DEP_TRANS
    (
        TRANS_ID INTEGER REFERENCES TRANSACTIONS PRIMARY KEY
    );

CREATE TABLE R_DEPOSIT_TRANS
    (
        TRANS_ID INTEGER,
        CUSTOMER_ID INTEGER,
        t_date DATE NOT NULL,
        AMOUNT INTEGER,
        PRIMARY KEY (TRANS_ID, CUSTOMER_ID)
    );

