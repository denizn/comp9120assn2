DROP TABLE IF EXISTS COMPANY CASCADE;
DROP TABLE IF EXISTS MUTUAL_FUND CASCADE;
DROP TABLE IF EXISTS closing_price CASCADE;
DROP TABLE IF EXISTS "LOCATION" CASCADE;
DROP TABLE IF EXISTS USERS CASCADE;
DROP TABLE IF EXISTS CUSTOMER CASCADE;
DROP TABLE IF EXISTS ADMINISTRATOR CASCADE;
DROP TABLE IF EXISTS PREFERS CASCADE;
DROP TABLE IF EXISTS OWNS CASCADE;
DROP TABLE IF EXISTS TRANSACTIONS CASCADE;
DROP TABLE IF EXISTS DEPOSIT_TRANSACTION CASCADE;
DROP TABLE IF EXISTS INVESTMENT_TRANSACTION CASCADE;
DROP TABLE IF EXISTS DEPOSIT_TRANS CASCADE;
DROP TABLE IF EXISTS PORTFOLIO_ACTION CASCADE;


CREATE TABLE IF NOT EXISTS COMPANY
    (
        COMPANY_ID INTEGER PRIMARY KEY NOT NULL,
        "NAME" VARCHAR(30) NOT NULL,
        CEO_lname VARCHAR(20),
        CEO_fname VARCHAR(20)
    );

CREATE TABLE IF NOT EXISTS "LOCATION"
    (
    STATE VARCHAR(3) DEFAULT 'NSW',  
        CHECK (STATE IN ('NSW','QLD','SA','TAS','VIC','WA')), /*make sure location is in Australia*/
        CITY VARCHAR(10),
        POSTCODE INTEGER,
        COMPANY_ID INTEGER REFERENCES COMPANY(COMPANY_ID) ON DELETE CASCADE,  /*location is a multivalued attribute for company*/
        PRIMARY KEY (COMPANY_ID)
    );


CREATE TABLE IF NOT EXISTS MUTUAL_FUND 
    (
        SYMBOL CHAR(3) UNIQUE,
        COMPANY_ID INTEGER,
        FOREIGN KEY (COMPANY_ID) REFERENCES COMPANY ON DELETE CASCADE, /*each mutual fund manage by exactly one company*/
        PRIMARY KEY (SYMBOL,COMPANY_ID),
        "NAME" VARCHAR(10) NOT NULL,
        DESCRIPTION VARCHAR(30),
        CATEGORY VARCHAR(10),
        T_NUM_SHARES INTEGER,
        C_DATE DATE NOT NULL
    );

CREATE TABLE IF NOT EXISTS closing_price  /*weak entity of mutual_fund*/
   (
        PRICE INTEGER,
        P_DATE DATE NOT NULL,
        SYMBOL CHAR (3) REFERENCES MUTUAL_FUND(SYMBOL) ON DELETE CASCADE,  
        PRIMARY KEY (P_DATE,SYMBOL)
   );


CREATE TABLE IF NOT EXISTS USERS
    (
        LOGIN VARCHAR(30) NOT NULL,
        PRIMARY KEY (LOGIN),
        EMAIL VARCHAR(30),
        "NAME" VARCHAR(30),
        ADDRESS VARCHAR(50),
        "PASSWORD" VARCHAR(15)
    );

CREATE TABLE IF NOT EXISTS CUSTOMER
    (
        CUSTOMER_ID VARCHAR(30) NOT NULL REFERENCES USERS(LOGIN), /*isA relationship of USERS*/
        PRIMARY KEY (CUSTOMER_ID),
        BALANCES FLOAT
    );

CREATE TABLE IF NOT EXISTS ADMINISTRATOR /*isA relationship of USERS*/
    (
        ADMINISTRATOR_ID VARCHAR(30) NOT NULL REFERENCES USERS(LOGIN),
        PRIMARY KEY (ADMINISTRATOR_ID)
    );

CREATE TABLE IF NOT EXISTS PREFERS
    (
        PERCENTAGE INTEGER, 
        SYMBOL CHAR(3) REFERENCES MUTUAL_FUND(SYMBOL), 
        COMPANY_ID INTEGER REFERENCES COMPANY(COMPANY_ID),   
        CUSTOMER_ID VARCHAR(30) REFERENCES CUSTOMER(CUSTOMER_ID), 
        PRIMARY KEY (SYMBOL, COMPANY_ID, CUSTOMER_ID) 
    );

CREATE TABLE IF NOT EXISTS OWNS
    (
        SHARES INTEGER,
        SYMBOL CHAR(3) REFERENCES MUTUAL_FUND(SYMBOL), 
        COMPANY_ID INTEGER REFERENCES COMPANY(COMPANY_ID),  
        CUSTOMER_ID VARCHAR(30) REFERENCES CUSTOMER(CUSTOMER_ID), 
        PRIMARY KEY (SYMBOL, COMPANY_ID, CUSTOMER_ID) 
    );

CREATE TABLE IF NOT EXISTS TRANSACTIONS /*either a investment transaction or deposit transaction*/
    (
        TRANS_ID INTEGER PRIMARY KEY
    );

CREATE TABLE IF NOT EXISTS INVESTMENT_TRANSACTION
    (
        TRANS_ID INTEGER REFERENCES TRANSACTIONS PRIMARY KEY /*isA relationship of TRANSACTIONS*/
    );

CREATE TABLE IF NOT EXISTS DEPOSIT_TRANSACTION
    (
        TRANS_ID INTEGER REFERENCES TRANSACTIONS PRIMARY KEY /*isA relationshio of TRANSACTIONS*/
    );

CREATE TABLE IF NOT EXISTS DEPOSIT_TRANS
    (
        TRANS_ID INTEGER REFERENCES DEPOSIT_TRANSACTION(TRANS_ID),
        CUSTOMER_ID VARCHAR(30) REFERENCES CUSTOMER(CUSTOMER_ID),
        PRIMARY KEY (TRANS_ID, CUSTOMER_ID),
        t_date DATE NOT NULL,
        AMOUNT INTEGER
    );

CREATE TABLE IF NOT EXISTS PORTFOLIO_ACTION
    (
        t_date DATE NOT NULL,
        PRICE INTEGER,
        NUM_SHARES INTEGER,
        AMOUNT INTEGER,
        "ACTION" VARCHAR (10),
        SYMBOL CHAR(3) REFERENCES MUTUAL_FUND(SYMBOL), 
        COMPANY_ID INTEGER REFERENCES COMPANY(COMPANY_ID), 
        CUSTOMER_ID VARCHAR(30) REFERENCES CUSTOMER(CUSTOMER_ID), 
        TRANS_ID INTEGER REFERENCES INVESTMENT_TRANSACTION(TRANS_ID),
        PRIMARY KEY (SYMBOL, COMPANY_ID, CUSTOMER_ID, TRANS_ID), /*relationship between mutual fund, investment trasction, and customer*/
        CHECK (AMOUNT = (NUM_SHARES*PRICE)),  
        CHECK ("ACTION" in ('sell','buy')) 
    );


INSERT INTO COMPANY (COMPANY_ID,"NAME",CEO_lname,CEO_fname)
    VALUES (789,'Apple','Cook','Tim');
INSERT INTO "LOCATION" (STATE,CITY,POSTCODE,COMPANY_ID)
    VALUES ('NSW','SYDNEY',2008,789);
INSERT INTO MUTUAL_FUND (SYMBOL,COMPANY_ID,"NAME",DESCRIPTION,CATEGORY,T_NUM_SHARES,C_DATE)
    VALUES ('PA',789,'INVESTMENT','makemoney','invest',1000,'2019-05-01');
INSERT INTO closing_price (PRICE,P_DATE,SYMBOL)
    VALUES (100, '2019-05-01','PA');
INSERT INTO USERS (LOGIN,EMAIL,"NAME",ADDRESS,"PASSWORD")
    VALUES ('adminSid','admin@apple.com','TimCook','address','password');
INSERT INTO USERS (LOGIN,EMAIL,"NAME",ADDRESS,"PASSWORD")
    VALUES ('customerSid','customer@apple.com','BillGates','address','password');
INSERT INTO CUSTOMER (CUSTOMER_ID,BALANCES)
    VALUES ('customerSid',1000);
INSERT INTO ADMINISTRATOR (ADMINISTRATOR_ID)
    VALUES ('adminSid');
INSERT INTO PREFERS (PERCENTAGE,SYMBOL,COMPANY_ID,CUSTOMER_ID)
    VALUES (80,'PA',789,'customerSid');
INSERT INTO OWNS (SHARES,SYMBOL,COMPANY_ID,CUSTOMER_ID)
    VALUES (50,'PA',789,'customerSid');
INSERT INTO TRANSACTIONS (TRANS_ID)
    VALUES (5);
INSERT INTO TRANSACTIONS (TRANS_ID)
    VALUES (6);
INSERT INTO INVESTMENT_TRANSACTION (TRANS_ID)
    VALUES (5);
INSERT INTO DEPOSIT_TRANSACTION (TRANS_ID)
    VALUES (6);
INSERT INTO DEPOSIT_TRANS (TRANS_ID,CUSTOMER_ID,t_date,AMOUNT)
    VALUES (6,'customerSid','2019-04-01',300);
INSERT INTO PORTFOLIO_ACTION (t_date,PRICE,NUM_SHARES,AMOUNT,"ACTION",SYMBOL,COMPANY_ID,CUSTOMER_ID,TRANS_ID)
    VALUES ('2019-05-01',100,5,500,'buy','PA',789,'customerSid',5);
