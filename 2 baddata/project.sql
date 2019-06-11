create or replace procedure bad_data_project
as 
begin
	update STG_project set plct_short_desc=null where project_KEY=1454;
	update STG_project set plct_short_desc=null where project_KEY=1453;
	update STG_project set plct_short_desc='DB PROGRAMMER$$' where project_KEY=1452	;
end;

begin
bad_data_project;
end;

