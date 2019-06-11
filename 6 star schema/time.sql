--------------------------------------------------------------------------------------------------------
create table DIM_TIME(
TIME_ID NUMBER not null,
YEAR_C NUMBER
);
alter table dim_time add  
constraint pk_dim_time_id 
primary key(time_id)

select * from dim_time;

drop sequence seq_time_id
create sequence seq_time_id
start with 1
increment by 1;
-------------------------------------------------------
  CREATE OR REPLACE TRIGGER trigger_sdtime
BEFORE INSERT ON dim_time
FOR EACH ROW
BEGIN
   :new.time_id := seq_time_id.NEXTVAL;
END;
-------------------------------------------------------
create or replace procedure check_time 
AS
CURSOR CUR IS
select distinct 
  to_char(PLT_ACTUAL_START_DATE,'yyyy') AS YEARS
  FROM PROJECT_CLEAN ; 
RES   CUR%ROWTYPE;
   --USED CURSOR NAME HERE UNLIKE TABLE NAME 
begin
OPEN CUR ;
LOOP
FETCH CUR INTO RES;
EXIT WHEN CUR%NOTFOUND;
 insert into DIM_TIME
  VALUES(
    seq_time_id.NEXTVAL,
    RES.YEARS
  )  ;
END LOOP;
CLOSE CUR;
end;

begin
check_time;
end;

select * from dim_time;