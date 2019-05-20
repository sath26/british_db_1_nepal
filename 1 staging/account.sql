CREATE TABLE  "STG_ACCOUNT" 
   (	"ACCOUNT_KEY" NUMBER NOT NULL ENABLE, 
	"ACCOUNT_ID_LDS" NUMBER, 
	"ACCOUNT_ID_MCH" NUMBER, 
	"ACCOUNT_NAME" VARCHAR2(200), 
	"ACCOUNT_POSTCODE" VARCHAR2(50), 
	"ACCOUNT_REGISTERED" DATE, 
	"TURNOVER" NUMBER, 
	"NO_OF_EMPLOYEES" NUMBER, 
	"GLOBAL_INFLUENCE" VARCHAR2(40), 
	 CONSTRAINT "PK_STAGING_ACCOUNT_KEY" PRIMARY KEY ("ACCOUNT_KEY") ENABLE
   ) ;


 CREATE SEQUENCE   "STAGING_ACCOUNT_SEQ" 
 INCREMENT BY 1 
 START WITH 221 
 CACHE 20 
 NOORDER 
 NOCYCLE ;

CREATE OR REPLACE TRIGGER  "STAGING_ACCOUNT_TRIGGER" before insert on STG_Account
for each row
begin
:new.account_key :=staging_account_seq.NEXTVAL;
end;
-----------------------------------------------------------------------------------------
create or replace procedure PL_ACCOUNT_LDS
is 
begin
insert INTO STG_ACCOUNT 
select 
		STAGING_ACCOUNT_SEQ.NEXTVAL,
		account_id,
    '',
		account_name,
		account_postcode,
		account_registered,
		turnover,
		no_of_employees,
		global_influence,
from LDS_ACCOUNT;
END PL_ACCOUNT_LDS;

begin 
PL_ACCOUNT_LDS;
end;
--------------------------------------------------
create or replace procedure PL_ACCOUNT_MCH
is 
begin
insert INTO STG_ACCOUNT 
select
  STAGING_ACCOUNT_SEQ.NEXTVAL,
  '',
  COMPANY_ID,
  CMP_NAME,
  CMP_POSTCODE,
  DATE_REGISTERED,
  '',
  '',
  ''
from MCH_COMPANY;
END PL_ACCOUNT_MCH;

BEGIN 
PL_ACCOUNT_MCH;
END;
SELECT COUNT(*) FROM ST_ACCOUNT;
SELECT COUNT(*) FROM LDS_ACCOUNT;