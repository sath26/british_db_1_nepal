drop table consultant_error;
create table consultant_error(
consultant_skid number not null,
consultant_id number not null,
con_name varchar2(50),
con_postcode varchar2(50),
highest_quality number,
con_registered date
);

alter table consultant_error add constraint pk2_consultant_skid primary key(consultant_skid)
----------------------------------------------------------
drop sequence seq_consultant_error_skid
create sequence seq_consultant_error_skid
start with 1
increment by 1;

drop sequence seq_consultant_clean_skid
create sequence seq_consultant_clean_skid
start with 1
increment by 1;

create or replace procedure checkconsultant_quality 
as
begin
insert into consultant_clean 
	select 
		seq_consultant_clean_skid.NEXTVAL,
		consultant_id ,
		cont_name,
		cont_postcode,
		highest_qualification,
		cont_registered
from st_consultant where 
consultant_id is NOT NULL and 
cont_name IS NOT NULL and 
cont_postcode is NOT NULL and 
REGEXP_LIKE (cont_postcode, '^LS|^YK') and
NOT REGEXP_LIKE(cont_name,'[[:digit:]]');

insert into consultant_error 
	select 
		seq_consultant_error_skid.NEXTVAL,
		consultant_id ,
		cont_name,
		cont_postcode,
		highest_qualification,
		cont_registered
from st_consultant where 
consultant_id is NULL or 
cont_name IS NULL or  
cont_postcode is NULL or
NOT REGEXP_LIKE (cont_postcode, '^LS|^YK') or
REGEXP_LIKE(cont_name,'[[:digit:]]');

end;


begin
 checkconsultant_quality;
end;

select * from consultant_clean ;
select * from consultant_error ;