----------------------------------------------------------------------------------------------------------------------------
--EVERY DIM TABLES REQUIRE LDS AND MCH PK
-- FOREIGN KEYS ARE NOT REQUIRED BECAUSE FACT TABLE WILL HAVE IT
--account_id number,
--consultant_id number,
drop table dim_project
CREATE TABLE dim_project(
  	"PROJECT_SKID" NUMBER NOT NULL ENABLE, 
	"PROJECT_ID_LDS" NUMBER UNIQUE, 
	"PROJECT_ID_MCH" NUMBER UNIQUE, 
	"PLT_SHORT_DESC" VARCHAR2(500), 
	"PLT_REQUIRED_START_DATE" DATE, 
	"PLT_ESTIMATED_END_DATE" DATE, 
	"PLT_ACTUAL_START_DATE" DATE, 
	"PLT_ACTUAL_END_DATE" DATE, 
	"PLT_RENEWAL_NO" NUMBER(*,0), 
	"PLT_RATE_DAY_PROJ" VARCHAR2(100), 
	"ACTUAL_SALARY" NUMBER, 
	
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

create or replace procedure  datadim_PROJECT 
as 
begin 
insert into DIM_PROEJCT (
    PROJECT_SKID,
  PROJECT_ID_LDS,
  PROJECT_ID_MCH,
  PLT_SHORT_DESC,
  PLT_REQUIRED_START_DATE,
  PLT_ESTIMATED_END_DATE,
  PLT_ACTUAL_START_DATE,
  PLT_ACTUAL_END_DATE,
  PLT_RENEWAL_NO,
  PLT_RATE_DAY_PROJ,
  ACTUAL_SALARY

)
  select 
  PROJECT_SKID,
  PROJECT_ID_LDS,
  PROJECT_ID_MCH,
  PLT_SHORT_DESC,
  PLT_REQUIRED_START_DATE,
  PLT_ESTIMATED_END_DATE,
  PLT_ACTUAL_START_DATE,
  PLT_ACTUAL_END_DATE,
  PLT_RENEWAL_NO,
  PLT_RATE_DAY_PROJ,
  ACTUAL_SALARY

from PROJECT_CLEAN;
end;


  
BEGIN
  datadim_PROJECT;
END;
