
--use the data to get into excel and chart visualization then update fact table
/* Number of project by consultant per year
Number of project from account so far
Number of consultants added per year: can get from consultant table it self
Turnover per account per  year: can get from account table it self
Number of account per year : can get from account table it self
SUM OF ACTUAL SALARY: can get from project itself
*/
--project consist of consultant_id and accout_id as foreign key

--respective relationships can be created using project id columns
---------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE FACT_TABLE
CREATE TABLE  "FACT_TABLE" 
  (
  "FACT_ID" NUMBER NOT NULL,
  "PROJECT_ID_LDS" NUMBER,
  "PROJECT_ID_MCH" NUMBER,
  "CONSULTANT_ID_LDS" NUMBER,
  "CONSULTANT_ID_MCH" NUMBER,
  "ACCOUNT_ID_LDS" NUMBER,
  "ACCOUNT_ID_MCH" NUMBER,
  "TIME_ID" NUMBER,
  "NO_PROJECT_BY_ACCT_P_YR_LDS" NUMBER,
  "NO_PROJECT_BY_ACCT_P_YR_MCH" NUMBER,
  "NO_PROJECT_BY_CONST_P_YR_LDS" NUMBER,
  "NO_PROJECT_BY_CONST_P_YR_MCH" NUMBER
   ) ;
ALTER TABLE  "FACT_TABLE" ADD 
CONSTRAINT "FK_FACT_ACCOUNT_ID_LDS" 
FOREIGN KEY ("ACCOUNT_ID_LDS")
REFERENCES  "DIM_ACCOUNT" ("ACCOUNT_ID_LDS") ENABLE;

ALTER TABLE  "FACT_TABLE" ADD 
CONSTRAINT "FK_FACT_ACCOUNT_ID_MCH" 
FOREIGN KEY ("ACCOUNT_ID_MCH")
REFERENCES  "DIM_ACCOUNT" ("ACCOUNT_ID_MCH") ENABLE;

ALTER TABLE  "FACT_TABLE" ADD 
CONSTRAINT "FK_FACT_CONSULTANT_ID_LDS" 
FOREIGN KEY ("CONSULTANT_ID_LDS")
REFERENCES  "DIM_CONSULTANT" ("CONSULTANT_ID_LDS") ENABLE;

ALTER TABLE  "FACT_TABLE" ADD 
CONSTRAINT "FK_FACT_CONSULTANT_ID_MCH" 
FOREIGN KEY ("CONSULTANT_ID_MCH")
REFERENCES  "DIM_CONSULTANT" ("CONSULTANT_ID_MCH") ENABLE;

ALTER TABLE  "FACT_TABLE" ADD 
CONSTRAINT "FK_FACT_PROJECT_ID_LDS" 
FOREIGN KEY ("PROJECT_ID_LDS")
REFERENCES  "DIM_PROJECT" ("PROJECT_ID_LDS") ENABLE;

ALTER TABLE  "FACT_TABLE" ADD 
CONSTRAINT "FK_FACT_PROJECT_ID_MCH" 
FOREIGN KEY ("PROJECT_ID_MCH")
REFERENCES  "DIM_PROJECT" ("PROJECT_ID_MCH") ENABLE;

ALTER TABLE  "FACT_TABLE" ADD 
CONSTRAINT "FK_FACT_TIME_ID" 
FOREIGN KEY ("TIME_ID")
REFERENCES  "DIM_TIME" ("TIME_ID") ENABLE;
-------------------------------******************---------------------------
create or replace procedure fill_fact_data
as

time_id varchar2(4);
no_consult_LDS number;
no_consult_MCH number;
no_account_lds number;
no_account_mch number;
--the select values brought into data are in from joining dimension table and fact table 
begin
   --gives count of consultants I.E. NO_OF_PROJECT_BY_CONSULTANT_PER_YEAR
    --respective consultants must have respective counts
    --gives count of account I.E. NO_OF_PROJECT_BY_account_PER_YEAR
    --respective account must have respective counts
--respective year must have respective time_id
--if time table has only year this is possible otherwise multiple id can come
  for result in (
        select 
        consultant_id_LDS, 
        consultant_id_MCH, 
        account_id_LDS, 
        account_id_MCH, 
        project_id_LDS, 
        project_id_MCH, 
        to_char(PLT_ACTUAL_START_DATE,'yyyy') as years
        from project_clean 
        )
        --LDS AND MCH ARE FOR RESPECTIVE PRIMARY AND FOREIGN KEY WHICH MIGHT GET REPEATED 
    loop 
   
     time_id := get_time_id(result.years);
     NO_CONSULT_LDS := get_consultant_id_LDS(result.consultant_id_lds, result.years);
     NO_CONSULT_MCH := get_consultant_id_MCH(result.consultant_id_mch, result.years);
     NO_ACCOUNT_LDS := get_account_id_LDS(result.account_id_lds, result.years);
     NO_ACCOUNT_MCH :=  get_account_id_MCH(result.account_id_mch, result.years);
     
      
      insert into fact_table(
        FACT_ID,
        PROJECT_ID_LDS,
        project_id_MCH,
        consultant_id_LDS,
        consultant_id_MCH,
        account_id_LDS,
        account_id_MCH,
        TIME_ID,
        NO_PROJECT_BY_ACCT_P_YR_LDS,
        NO_PROJECT_BY_ACCT_P_YR_MCH,
        NO_PROJECT_BY_CONST_P_YR_LDS,
        NO_PROJECT_BY_CONST_P_YR_MCH
        )
      values(
        STAGING_CONSULTANT_SEQ.NEXTVAL,
        result.PROJECT_ID_LDS,
        result.PROJECT_ID_MCH,
        result.CONSULTANT_ID_LDS,
        result.CONSULTANT_ID_MCH,
        result.ACCOUNT_ID_LDS,
        result.ACCOUNT_ID_MCH,
        TIME_ID,
        NO_ACCOUNT_LDS,
        NO_ACCOUNT_MCH,
        NO_CONSULT_LDS,
        NO_CONSULT_MCH
      );
    end loop;
end;

begin
fill_fact_data;

end;
---------------------*************************------------------------------
CREATE OR REPLACE FUNCTION GET_CONSULTANT_ID_LDS(
  CONSULTANT_ID_LDS_P IN NUMBER,
  YEARS IN VARCHAR2
) 
   RETURN NUMBER
   IS NO_CONSULT_LDS NUMBER;

   BEGIN 

	  SELECT COUNT(CONSULTANT_ID_LDS) 
    INTO NO_CONSULT_LDS
    FROM PROJECT_CLEAN
    WHERE CONSULTANT_ID_LDS = CONSULTANT_ID_LDS_P
    AND TO_CHAR(PLT_ACTUAL_START_DATE,'YYYY')=YEARS;

      RETURN(NO_CONSULT_LDS); 

    END GET_CONSULTANT_ID_LDS;

    SET SERVEROUTPUT ON;
EXECUTE DBMS_OUTPUT.PUT_LINE(GET_CONSULTANT_ID_LDS(10,'2012'));
---------------------*************************------------------------------

CREATE OR REPLACE FUNCTION GET_CONSULTANT_ID_MCH(
  CONSULTANT_ID_MCH_P IN NUMBER,
  YEARS IN VARCHAR2) 
   RETURN NUMBER
   IS NO_CONSULT_MCH NUMBER;

   BEGIN 

	 SELECT COUNT(CONSULTANT_ID_MCH) INTO NO_CONSULT_MCH
      FROM PROJECT_CLEAN
      WHERE CONSULTANT_ID_MCH = CONSULTANT_ID_MCH_P
      AND TO_CHAR(PLT_ACTUAL_START_DATE,'YYYY')=YEARS;

      RETURN(NO_CONSULT_MCH); 

    END GET_CONSULTANT_ID_MCH;
SET SERVEROUTPUT ON;
EXECUTE DBMS_OUTPUT.PUT_LINE(GET_CONSULTANT_ID_MCH(31,'2012'));
---------------------*************************------------------------------
CREATE OR REPLACE FUNCTION GET_ACCOUNT_ID_LDS(
  ACCOUNT_ID_LDS_P IN NUMBER,
 YEARS IN VARCHAR2
) 
   RETURN NUMBER
   IS NO_ACCOUNT_LDS NUMBER;

   BEGIN 

	 SELECT COUNT(ACCOUNT_ID_LDS)  INTO NO_ACCOUNT_LDS
      FROM PROJECT_CLEAN
      WHERE ACCOUNT_ID_LDS = ACCOUNT_ID_LDS_P
      AND TO_CHAR(PLT_ACTUAL_START_DATE,'YYYY')=YEARS;

      RETURN(NO_ACCOUNT_LDS); 

    END GET_ACCOUNT_ID_LDS;
SET SERVEROUTPUT ON;
EXECUTE DBMS_OUTPUT.PUT_LINE(GET_ACCOUNT_ID_LDS(41,'2012'));
---------------------*************************------------------------------
CREATE OR REPLACE FUNCTION GET_ACCOUNT_ID_MCH(
  ACCOUNT_ID_MCH_P IN NUMBER,
 YEARS IN VARCHAR2
)  
   RETURN NUMBER
   IS NO_ACCOUNT_MCH NUMBER;

   BEGIN 

	SELECT COUNT(ACCOUNT_ID_MCH)  INTO NO_ACCOUNT_MCH
      FROM PROJECT_CLEAN
      WHERE ACCOUNT_ID_MCH = ACCOUNT_ID_MCH_P
      AND TO_CHAR(PLT_ACTUAL_START_DATE,'YYYY')=YEARS;
      
      RETURN(NO_ACCOUNT_MCH); 

    END GET_ACCOUNT_ID_MCH;
SET SERVEROUTPUT ON;
EXECUTE DBMS_OUTPUT.PUT_LINE(GET_ACCOUNT_ID_MCH(20));

---------------------*************************------------------------------
CREATE OR REPLACE FUNCTION GET_TIME_ID(YEARS IN VARCHAR2) 
   RETURN NUMBER
   IS TIME_ID NUMBER;

   BEGIN 

	  SELECT TIME_ID INTO TIME_ID
      FROM DIM_TIME
      WHERE YEAR_C = YEARS;

      RETURN(TIME_ID); 

    END GET_TIME_ID;
SET SERVEROUTPUT ON;
EXECUTE DBMS_OUTPUT.PUT_LINE(GET_YEARS(20));