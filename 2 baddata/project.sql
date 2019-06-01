create or replace procedure bad_data_project
as 
begin
	update STG_project set plct_short_desc=null where project_KEY=398;
	update STG_project set plct_short_desc=null where project_KEY=400;
	update STG_project set plct_short_desc='saugat$$' where project_KEY=402	;
end;

begin
bad_data_project;
end;

