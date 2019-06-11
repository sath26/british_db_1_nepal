---------------------------------------------------------------------------------------------------------------------------------------------------

drop table dim_consultant

create table dim_consultant(
consultant_skid number not null,
consultant_id_lds number unique,
consultant_id_mch number unique,
CONSULTANT_NAME varchar2(100),
CONSULTANT_POSTCODE varchar2(100),
HIGHEST_QUALIFICATION number,
CONSULTANT_REGISTERED date,
CONSULTANT_SKILL varchar2(100),
  PREFERRED_ROLE varchar2(100)
);
alter table dim_consultant add constraint pk3_consultant_skid primary key(consultant_skid)
-------------------------------------------------------------------

create sequence 
seq_dim_consultant_skid
start with 1
increment by 1;

CREATE TRIGGER TRIGG_dim_contract BEFORE INSERT ON dim_consultant FOR EACH ROW
BEGIN

:new.consultant_skid :=seq_dim_consultant_skid.NEXTVAL;

END

------------------------------------------------
create or replace procedure  datadim_consultant 
as 
begin 
insert into dim_consultant 
  select 
  seq_dim_account_skid.NEXTVAL,
 CONSULTANT_ID_LDS, 
	CONSULTANT_ID_MCH, 
  CONSULTANT_NAME,
  CONSULTANT_POSTCODE,
  HIGHEST_QUALIFICATION,
  CONSULTANT_REGISTERED,
  CONSULTANT_SKILL,
  PREFERRED_ROLE
from consultant_clean;
end;


begin
datadim_consultant;
end;

select * from dim_consultant;