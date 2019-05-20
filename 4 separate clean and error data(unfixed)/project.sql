drop sequence seq_PROJECT_error_skid ;
create sequence seq_PROJECT_error_skid start with 1 increment by 1;

drop sequence seq_PROJECT_clean_skid 
create sequence seq_PROJECT_clean_skid start with 1 increment by 1;
---------------------------------------------------------------------------------
create or replace procedure checkproject_dataquality
as
begin
insert into project_clean 
	select 
		seq_PROJECT_clean_skid.NEXTVAL,
		PROJECT_id,
		plct_short_desc,
		plct_required_start_date,
		plct_estimated_end_date,
		plct_actual_start_date,
		plct_actual_end_date,
		plct_renewal_number,
		plct_rate_day_proj,
		actual_salary,
		account_id,
		consultant_id
from staging_project where
plct_short_desc is NOT NULL and
NOT REGEXP_LIKE(plct_short_desc,'[[:digit:]]');

insert into project_error 
	select 
		seq_PROJECT_error_skid.NEXTVAL,
		PROJECT_id,
		plct_short_desc,
		plct_required_start_date,
		plct_estimated_end_date,
		plct_actual_start_date,
		plct_actual_end_date,
		plct_renewal_number,
		plct_rate_day_proj,
		actual_salary,
		account_id,
		consultant_id
from staging_project where
plct_short_desc is NULL or
REGEXP_LIKE(plct_short_desc,'[[:digit:]]');

end;

begin
checkproject_dataquality;
end;

select * from project_clean;
select * from project_error;