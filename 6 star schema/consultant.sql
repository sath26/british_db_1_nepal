---------------------------------------------------------------------------------------------------------------------------------------------------

drop table dim_consultant

create table dim_consultant(
consultant_skid number not null,
consultant_id number not null,
con_name varchar2(100),
con_postcode varchar2(100),
highest_qual number,
con_registered date
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
MERGE INTO dim_consultant dc
    USING consultant_clean cc
    ON (
      cc.consultant_id =dc.consultant_id and
        cc.con_postcode=dc.con_postcode
)
    WHEN MATCHED THEN 
   update SET dc.con_name=cc.con_name,
           dc.highest_qual=cc.highest_qual,
           dc.con_registered=cc.con_registered
           
WHEN NOT MATCHED THEN 
INSERT (dc.consultant_id,
  dc.con_name,
  dc.con_postcode,
  dc.highest_qual,
  dc.con_registered)
    VALUES (
      cc.consultant_id,
      cc.con_name,
      cc.con_postcode,
      cc.highest_qual,
      cc.con_registered);

dbms_output.put_line('clean data loaded into dimension table of placement');
end;


begin
datadim_consultant;
end;

select * from dim_consultant;