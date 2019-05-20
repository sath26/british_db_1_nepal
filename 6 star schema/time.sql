--------------------------------------------------------------------------------------------------------
create table dim_time(
time_id NUMBER not null,
year NUMBER,
month NUMBER
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
create or replace procedure check_time 
as
 v_count number;
begin
 for result in (
  select distinct 
  to_char(PLT_ACTUAL_START_DATE,'yyyy') as years,
  to_char(PLT_ACTUAL_START_DATE,'mm') as months from project_clean)
   loop
       select count(*) into v_count from dim_time where year=result.years and month=result.months;
       if v_count=0 then
        insert into dim_time(time_id,year,month) values (seq_time_id.NEXTVAL,result.years,result.months);
        dbms_output.put_line('date inserted successfully');
      
       else
        dbms_output.put_line('date already inserted');
       end if;
   
   end loop;

end;

begin
check_time;
end;

select * from dim_time;