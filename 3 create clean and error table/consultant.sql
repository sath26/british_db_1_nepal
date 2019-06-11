drop table CONsultant_clean;
create table consultant_clean(
consultant_skid number not null,
consultant_id_lds number ,
consultant_id_mch number ,
CONSULTANT_name varchar2(100),
CONSULTANT_postcode varchar2(100),
highest_qualification number,
CONSULTANT_registered date,
CONSULTANT_SKILL varchar2(100),
PREFERRED_ROLE varchar2(100)
);
alter table CONsultant_clean add CONstraint pk1_CONsultant_skid primary key(CONsultant_skid);

------------------------------------------------------------

drop table CONsultant_error;
create table CONsultant_error(
CONsultant_skid number not null,
CONsultant_id_lds number,
CONsultant_id_mch number,
CONSULTANT_name varchar2(50),
CONSULTANT_postcode varchar2(50),
highest_qualification number,
CONSULTANT_registered date,
CONSULTANT_SKILL varchar2(100),
PREFERRED_ROLE varchar2(100)
);

alter table CONsultant_error add CONstraint pk2_CONsultant_skid primary key(CONsultant_skid);