create or replace procedure bad_data_for_staging_con
as
begin
	update stG_consultant set CONSULTANT_name=null where consultant_id_LDS=14;
	update stG_consultant set CONSULTANT_name='YK7 981' where consultant_key=631;
	UPDATE STG_CONSULTANT SET CONSULTANT_NAME = '##Zed Zand' WHERE CONSULTANT_KEY = 632;
end;

select * from st_consultant;
begin
bad_data_for_staging_con;
end;

