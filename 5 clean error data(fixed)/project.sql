CREATE OR REPLACE PROCEDURE SPR_CLEAN_PROJECT
AS
CURSOR CUR IS
SELECT * FROM PROJECT_ERROR;
RES             PROJECT_ERROR%ROWTYPE;
TEMP_VAL        PROJECT_CLEAN.PLT_SHORT_DESC%TYPE;
TEMP_VAL1        PROJECT_CLEAN.PLT_SHORT_DESC%TYPE;

BEGIN 
OPEN CUR ;
LOOP
FETCH CUR INTO RES;
EXIT WHEN CUR%NOTFOUND;
CASE TRUE 
WHEN RES.PLT_SHORT_DESC IS NULL
THEN
with strings as (
      select 'Apex Developer M&S' as s from dual union all
      select 'Traninee BI' as s from dual union all
      select 'data analyst' as s from dual union all
      select 'Db programmer' as s from dual
     )
select (select s
        from (select s from strings order by dbms_random.value) s
        where rownum = 1
       ) INTO TEMP_VAL1
from dual;

  INSERT INTO PROJECT_CLEAN (
    	PROJECT_SKID, 
	PROJECT_ID_LDS  , 
	PROJECT_ID_MCH , 
	PLT_SHORT_DESC, 
	PLT_REQUIRED_START_DATE , 
	PLT_ESTIMATED_END_DATE , 
	PLT_ACTUAL_START_DATE , 
	PLT_ACTUAL_END_DATE , 
	PLT_RENEWAL_NO , 
	PLT_RATE_DAY_PROJ , 
	ACTUAL_SALARY , 
	ACCOUNT_ID_LDS ,
	ACCOUNT_ID_MCH ,
	CONSULTANT_ID_LDS ,
	CONSULTANT_ID_MCH 
  )
    VALUES(
  RES.PROJECT_SKID,--ACCOUNT_SKID OF ERROR
 RES.PROJECT_ID_LDS,--ACCOUNT_ID OF ERROR
 RES.PROJECT_ID_MCH,--ACCOUNT_ID OF ERROR
   trim(TEMP_VAL1),  
  RES.PLT_REQUIRED_START_DATE , 
	RES.PLT_ESTIMATED_END_DATE , 
	RES.PLT_ACTUAL_START_DATE , 
	RES.PLT_ACTUAL_END_DATE , 
	RES.PLT_RENEWAL_No , 
	RES.PLT_RATE_DAY_PROJ , 
	RES.ACTUAL_SALARY ,
  RES.ACCOUNT_ID_lds,
  RES.ACCOUNT_ID_mch,
	RES.CONSULTANT_ID_lds,
	RES.CONSULTANT_ID_mch
      );
  UPDATE PRO_ISSUES SET I_STATUS ='FIXED' WHERE ROW_ID= RES.PROJECT_SKID  ;--NEED PROJECT_SKID OF ERROR

WHEN REGEXP_LIKE(RES.PLT_SHORT_DESC,'[*|_|#|$]' )
THEN
  SELECT TRANSLATE(RES.PLT_SHORT_DESC, '#$*_', ' ') INTO 
      TEMP_VAL FROM DUAL;
  
INSERT INTO PROJECT_CLEAN (
    	PROJECT_SKID, 
	PROJECT_ID_LDS  , 
	PROJECT_ID_MCH , 
	PLT_SHORT_DESC, 
	PLT_REQUIRED_START_DATE , 
	PLT_ESTIMATED_END_DATE , 
	PLT_ACTUAL_START_DATE , 
	PLT_ACTUAL_END_DATE , 
	PLT_RENEWAL_NO , 
	PLT_RATE_DAY_PROJ , 
	ACTUAL_SALARY , 
	ACCOUNT_ID_LDS ,
	ACCOUNT_ID_MCH ,
	CONSULTANT_ID_LDS ,
	CONSULTANT_ID_MCH 
  )
    VALUES(
   RES.PROJECT_SKID,--ACCOUNT_SKID OF ERROR
 RES.PROJECT_ID_LDS,--ACCOUNT_ID OF ERROR
RES.PROJECT_ID_MCH,--ACCOUNT_ID OF ERROR
   trim(TEMP_VAL), 
  RES.PLT_REQUIRED_START_DATE , 
	RES.PLT_ESTIMATED_END_DATE , 
	RES.PLT_ACTUAL_START_DATE , 
	RES.PLT_ACTUAL_END_DATE , 
	RES.PLT_RENEWAL_No , 
	RES.PLT_RATE_DAY_PROJ , 
	RES.ACTUAL_SALARY ,
  RES.ACCOUNT_ID_lds,
  RES.ACCOUNT_ID_mch,
	RES.CONSULTANT_ID_lds,
	RES.CONSULTANT_ID_mch
      );
  UPDATE PRO_ISSUES SET I_STATUS ='FIXED' WHERE ROW_ID=  RES.PROJECT_SKID ;
  END CASE;
END LOOP;
CLOSE CUR;
EXCEPTION 
WHEN NO_DATA_FOUND THEN 
DBMS_OUTPUT.PUT_LINE('DATA NOT FOUND');
END SPR_CLEAN_PROJECT;
--EXECUTING PROCEDURE-----------------------------------
BEGIN 
SPR_CLEAN_PROJECT;
END;


--100% data migration is needed
-- update issue table that its fixed
-- THERE ARE VALUES THAT ARE EMPTY
------------------------------------------------------------------------------------------------------
