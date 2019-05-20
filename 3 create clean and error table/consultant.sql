drop table consultant_clean;
create table consultant_clean(
consultant_skid number not null,
consultant_id number not null,
con_name varchar2(100),
con_postcode varchar2(100),
highest_qual number,
con_registered date
);
alter table consultant_clean add constraint pk1_consultant_skid primary key(consultant_skid)