
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
create or replace FUNCTION get_consultant_id_LDS(
  consultant_id_lds IN NUMBER,
  years IN VARCHAR2
) 
   RETURN VARCHAR2
   IS no_consult_LDS VARCHAR2(130);

   BEGIN 

	  select count(consultant_id_LDS) 
    into no_consult_LDS
    from project_clean
    where consultant_id_lds = consultant_id_lds
    and to_char(PLT_ACTUAL_START_DATE,'yyyy')=years;

      RETURN(no_consult_LDS); 

    END get_consultant_id_LDS;

    SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line(get_consultant_id_LDS(10,'2012'));
---------------------*************************------------------------------

create or replace FUNCTION get_consultant_id_MCH(
  consultant_id_mch IN NUMBER,
  years IN VARCHAR2
) 
   RETURN VARCHAR2
   IS no_consult_MCH VARCHAR2(130);

   BEGIN 

	 select count(consultant_id_MCH) into no_consult_MCH
      from project_clean
      where consultant_id_mch = consultant_id_mch
      and to_char(PLT_ACTUAL_START_DATE,'yyyy')=years;

      RETURN(no_consult_MCH); 

    END get_consultant_id_MCH;
SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line(get_consultant_id_MCH(31,'2012'));
---------------------*************************------------------------------
create or replace FUNCTION get_account_id_LDS(
  account_id_LDS IN NUMBER,
 years IN VARCHAR2
) 
   RETURN VARCHAR2
   IS no_account_lds VARCHAR2(130);

   BEGIN 

	 select count(account_id_LDS)  into no_account_lds
      from project_clean
      where account_id_lds = account_id_LDS
      and to_char(PLT_ACTUAL_START_DATE,'yyyy')=years;

      RETURN(no_account_lds); 

    END get_account_id_LDS;
SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line(get_account_id_LDS(41,'2012'));
---------------------*************************------------------------------
create or replace FUNCTION get_account_id_MCH(
  account_id_mch IN NUMBER,
 years IN VARCHAR2
)  
   RETURN VARCHAR2
   IS no_account_mch VARCHAR2(130);

   BEGIN 

	select count(account_id_MCH)  into no_account_mch
      from project_clean
      where account_id_mch = account_id_mch
      and to_char(PLT_ACTUAL_START_DATE,'yyyy')=years;
      
      RETURN(no_account_mch); 

    END get_account_id_MCH;
SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line(get_account_id_MCH(20));

---------------------*************************------------------------------
create or replace FUNCTION get_time_id(years IN VARCHAR2) 
   RETURN VARCHAR2
   IS time_id VARCHAR2(130);

   BEGIN 

	  select time_id into time_id
      from dim_time
      where year_c = years;

      RETURN(time_id); 

    END get_time_id;
SET SERVEROUTPUT ON;
EXECUTE dbms_output.put_line(get_years(20));