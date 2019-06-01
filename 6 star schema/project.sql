----------------------------------------------------------------------------------------------------------------------------

drop table dim_project
CREATE TABLE dim_project(
  project_skid number not null,
	project_id	number not null,
	plt_short_desc	VARCHAR2(500),
	plt_required_start_date	DATE,
	plt_estimated_end_date	DATE,
	plt_actual_start_date	DATE,
	plt_actual_end_date	DATE,
	plt_renewal_no	INTEGER,
	plt_RATE_DAY_PROJ VARCHAR2(100),
	actual_salary	number,
  account_id number,
  consultant_id number,
  CONSTRAINT pk_dim_project PRIMARY KEY (project_skid)
);

-----------------------------------------
create sequence 
seq_dim_project_skid
start with 1
increment by 1;
--------------------------------------------------
  CREATE OR REPLACE TRIGGER trigger_sdproject
BEFORE INSERT ON dim_project
FOR EACH ROW
BEGIN
   :new.project_skid := seq_dim_project_skid.NEXTVAL;
END;
-------------------------------------------------------
create or replace procedure mergedim_project
as
begin
MERGE INTO dim_project dp
    USING project_clean pc
    ON (pc.project_id=dp.project_id and
        pc.plt_short_desc=dp.plt_short_desc and
        pc.plt_required_start_date=dp.plt_required_start_date and
        pc.plt_estimated_end_date=dp.plt_estimated_end_date and
        pc.plt_actual_start_date=dp.plt_actual_start_date and 
        pc.plt_actual_end_date=dp.plt_actual_end_date and 
        pc.actual_salary=dp.actual_salary
        )
    WHEN MATCHED THEN 
   update SET dp.PLT_RENEWAL_NO=pc.PLT_RENEWAL_NO,
           dp.plt_RATE_DAY_PROJ=pc.plt_RATE_DAY_PROJ
WHEN NOT MATCHED THEN 
INSERT (
  dp.project_id,
  dp.plt_short_desc,
  dp.plt_required_start_date,
  dp.plt_estimated_end_date,
  dp.plt_actual_start_date,
  dp.plt_actual_end_date,
  dp.PLT_RENEWAL_NO,
  dp.plt_RATE_DAY_PROJ,
  dp.actual_salary,
  dp.account_id,
  dp.consultant_id)
    VALUES (
      pc.project_id,
      pc.plt_short_desc,
      pc.plt_required_start_date,
      pc.plt_estimated_end_date,
      pc.PLT_ACTUAL_START_DATE,
      pc.plt_actual_end_date,
      pc.PLT_RENEWAL_NO,
      pc.plt_RATE_DAY_PROJ,
      pc.actual_salary,
      pc.account_id
      pc.consultant_id);

dbms_output.put_line('clean data loaded into dimension table of project.');
end;

DECLARE
  
BEGIN
  mergedim_project;
END;
