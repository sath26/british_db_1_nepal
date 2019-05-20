create or replace procedure bad_data_for_staging_con
as
begin
	update st_consultant set cont_name=null where consultant_id=14;
	update st_consultant set cont_postcode=null where consultant_key=51;
	update st_consultant set cont_postcode='Zed Zebra', cont_name='YK7 981' where consultant_key=37;
	
end;

select * from st_consultant;
begin
bad_data_for_staging_con;
end;

------------------------------------------------------------

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