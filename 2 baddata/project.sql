create or replace procedure bad_data_project
as 
begin
	update staging_project set plct_short_desc=null where project_id=99;
	update staging_project set plct_short_desc=null where project_id=100;
	update staging_project set plct_short_desc='223' where project_id=108;
end;

begin
bad_data_project;
end;
--------------------------------------------------------------
select * from staging_project 


drop table project_error;
CREATE TABLE  "PROJECT_ERROR" 
   (	"PROJECT_SKID" NUMBER NOT NULL ENABLE, 
	"PROJECT_ID" NUMBER NOT NULL ENABLE, 
	"PLT_SHORT_DESC" VARCHAR2(500), 
	"PLT_REQUIRED_START_DATE" DATE, 
	"PLT_ESTIMATED_END_DATE" DATE, 
	"PLT_ACTUAL_START_DATE" DATE, 
	"PLT_ACTUAL_END_DATE" DATE, 
	"PLT_RENEWAL_NO" NUMBER(*,0), 
	"PLT_RATE_DAY_PROJ" VARCHAR2(100), 
	"ACTUAL_SALARY" NUMBER, 
	"ACCOUNT_ID" NUMBER, 
	"CONSULTANT_ID" NUMBER, 
	 CONSTRAINT "PK_PROJECT_ERROR" PRIMARY KEY ("PROJECT_SKID") ENABLE
   );

