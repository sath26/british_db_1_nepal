

---------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE FACT_TABLE
CREATE TABLE  "FACT_TABLE" 
   (	"PROJECT_ID" NUMBER NOT NULL ENABLE, 
	"ACCOUNT_ID" NUMBER NOT NULL ENABLE, 
	"CONSULTANT_ID" NUMBER NOT NULL ENABLE, 
	"TIME_ID" NUMBER(*,0) NOT NULL ENABLE, 
	"SUM_OF_ACTUAL_SALARY" NUMBER, 
	"NO_OF_PLACEMENTS" NUMBER, 
	"NO_OF_RENEWED_PLACEMENTS" NUMBER, 
	"TURNOVER_RATE" NUMBER
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

create or replace procedure check_fact_data
as
v_count number;
v_avg_salary number;

begin
  for data in (select distinct
                dp.project_skID as project_id,
                dt.time_id as time_id,
                da.account_skid as account_id,
                dc.consultant_skid as consultant_id
               from 
                dim_project DP,
                DIM_consultant DC,
                DIM_account da,
                dim_time dt
               where DP.consultant_ID = DC.consultant_ID
               and dp.account_id = da.account_id 
               and to_char(dp.PLT_ACTUAL_START_DATE,'YYYY')=dt.year
               and to_char(dp.PLT_ACTUAL_START_DATE,'MM')=dt.month
               )
  loop
      select  
        avg(actual_salary) 
      into 
        v_avg_salary 
      from 
        dim_project;

      select count(*) into v_count 
        from fact_table 
        where 
          project_id=data.project_id and 
          account_id=data.account_id and 
          consultant_id=data.consultant_id;

      if v_count=0 then
      
      insert into fact_table(
        project_id,
        account_id,
        consultant_id,
        time_id) 
      values (
        data.project_id,
        data.account_id,
        data.consultant_id,
        data.time_id);

      dbms_output.put_line('Successfully data inserted');

      else
      dbms_output.put_line('Duplicate data its already inserted');
      end if;

  end loop;

                                                     
end;

begin
check_fact_data;

end;