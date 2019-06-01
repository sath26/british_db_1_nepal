
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
   ("FACT_ID" NUMBER NOT NULL,
     	"PROJECT_ID" NUMBER , 
	"ACCOUNT_ID" NUMBER , 
	"CONSULTANT_ID" NUMBER , 
	"TIME_ID" NUMBER(*,0) , 
	"NO_OF_PROJECT_BY_ACCOUNT_PER_YEAR" NUMBER, 
	"NO_OF_PROJECT_BY_CONSULTANT_PER_YEAR" NUMBER, 
   ) ;
ALTER TABLE  "FACT_TABLE" ADD 
CONSTRAINT "FK_FACT_ACCOUNT_ID" 
FOREIGN KEY ("ACCOUNT_ID")
REFERENCES  "DIM_ACCOUNT" ("ACCOUNT_SKID") ENABLE;

ALTER TABLE  "FACT_TABLE" ADD 
CONSTRAINT "FK_FACT_CONSULTANT_ID" 
FOREIGN KEY ("CONSULTANT_ID")
REFERENCES  "DIM_CONSULTANT" ("CONSULTANT_SKID") ENABLE;

ALTER TABLE  "FACT_TABLE" ADD 
CONSTRAINT "FK_FACT_PROJECT_ID" 
FOREIGN KEY ("PROJECT_ID")
REFERENCES  "DIM_PROJECT" ("PROJECT_SKID") ENABLE;

ALTER TABLE  "FACT_TABLE" ADD 
CONSTRAINT "FK_FACT_TIME_ID" 
FOREIGN KEY ("TIME_ID")
REFERENCES  "DIM_TIME" ("TIME_ID") ENABLE;

create or replace procedure fill_fact_data
as
v_pro_acc_p_y number;
v_pro_cons_p_y number;
--the select values brought into data are in from joining dimension table and fact table 
begin
   --gives count of consultants I.E. NO_OF_PROJECT_BY_CONSULTANT_PER_YEAR
    --respective consultants must have respective counts
    --gives count of account I.E. NO_OF_PROJECT_BY_account_PER_YEAR
    --respective account must have respective counts
--respective year must have respective time_id
--if time table has only year this is possible otherwise multiple id can come
  for result in (
        select consultant_id, account_id, project_id, to_char(PLT_ACTUAL_START_DATE,'yyyy') as years
        from project_clean 
        )
        --project clean because dim_project doesnt have foreign keys like in project_clean
    loop 
      for corresponding_time in ( 
      select time_id
      from dim_time
      where year = result.years
      )
      for corresponding_consult in ( 
      select count(consultant_id) as no_consult
      from project_clean
      where consultant_id = result.consultant_id
      )
      for corresponding_account in ( 
      select count(account_id)  as no_account
      from project_clean
      where account_id = result.consult_id
      )
      insert into fact_table(
        project_fkproject_skid,
        consultant_fkconsultant_skid,
        account_fkaccount_skid,
        NO_OF_PROJECT_BY_ACCOUNT_PER_YEAR,
        NO_OF_PROJECT_BY_CONSULTANT_PER_YEAR
        )
      values(
        result.consultant_ID,
        result.project_id,
        result.account_id,
        corresponding_time.time_id,
        corresponding_account.no_account,
        corresponding_consult.no_consult
      );
    end loop;
end;

begin
check_fact_data;

end;