CREATE OR REPLACE PROCEDURE SPR_CLEAN_ERR_ACCOUNT
AS
CURSOR CUR IS
SELECT * FROM STG_ACCOUNT;

RES   STG_ACCOUNT%ROWTYPE;

BEGIN 
OPEN CUR ;
LOOP
FETCH CUR INTO RES;
EXIT WHEN CUR%NOTFOUND;

IF  REGEXP_LIKE(RES.ACCOUNT_NAME,'[*|_|#|&]' )  
THEN
INSERT INTO ACCOUNT_ERROR 
VALUES(
  RES.ACCOUNT_KEY,--surrogaet of stg_account, other wise it will get difficult to find which row did i fixed(surrogate key of stg_account will also be unique)
  RES.ACCOUNT_id_lds,
  RES.ACCOUNT_id_mch,
  RES.ACCOUNT_NAME, 
  RES.ACCOUNT_POSTCODE, 
  RES.ACCOUNT_REGISTERED,
  RES.TURNOVER,
  RES.NO_OF_EMPLOYEES,
  RES.GLOBAL_INFLUENCE
  );
  
INSERT INTO ACC_ISSUES
  (
  ISSUE_ID, 
  ROW_ID, 
  ISSUE, 
  i_STATUS)
VALUES(
  STAGING_ACCOUNT_SEQ.nextval, 
  RES.ACCOUNT_KEY, --saves surrogate key of staging table
  'SPECIAL CHARACTERS FOUND ON CONSULTANT', 
  'UN-FIXED'
  );

ELSIF   RES.ACCOUNT_REGISTERED IS NULL 
THEN
INSERT INTO ACCOUNT_ERROR 
VALUES(
  STAGING_ACCOUNT_SEQ.nextval,
  RES.ACCOUNT_id_lds,
  RES.ACCOUNT_id_mch,
  RES.ACCOUNT_NAME, 
  RES.ACCOUNT_POSTCODE, 
  RES.ACCOUNT_REGISTERED,
  RES.TURNOVER,
  RES.NO_OF_EMPLOYEES,
  RES.GLOBAL_INFLUENCE
  );
  
INSERT INTO ACC_ISSUES
  (
  ISSUE_ID, 
  ROW_ID, 
  ISSUE, 
  i_STATUS)
VALUES(
  STAGING_ACCOUNT_SEQ.nextval, 
  RES.ACCOUNT_KEY, 
  'FOUND VALUES EMPTY', 
  'UN-FIXED'
  );
  
ELSE

INSERT INTO ACCOUNT_CLEAN 
VALUES(
  RES.ACCOUNT_KEY,
  RES.ACCOUNT_id_lds,
  RES.ACCOUNT_id_mch,
  RES.ACCOUNT_NAME, 
  RES.ACCOUNT_POSTCODE, 
  RES.ACCOUNT_REGISTERED,
  RES.TURNOVER,
  RES.NO_OF_EMPLOYEES,
  RES.GLOBAL_INFLUENCE
  );

END IF;
END LOOP;
CLOSE CUR;
END SPR_CLEAN_ERR_ACCOUNT;

--EXECUTING PROCEDURE-----------------------------------
BEGIN 
SPR_CLEAN_ERR_ACCOUNT;
END;


--search data from error table and clean data
--store the cleaned data  in clean table
--update the status in error table
--insert issue table where the error is
----------------------------------------------------------------------------------------------------------------------------------------