--data clean and store clean table
--error data identification  and store in  error table
--SKID IS for a unique value for pk for these tables
drop table account_clean
CREATE TABLE account_clean 
(   
account_skid number not null,
account_id number not null,
account_name varchar2(50),
account_postcode varchar2(25),
registered_date date,
turnover number,
no_of_employees number,
global_influence varchar2(25)
); 
alter table account_clean add constraint pk_account_clean primary key(account_skid);
---------------------------------------------------------------------------------------

drop table account_error
CREATE TABLE account_error 
(   
account_skid number not null,
account_id number not null,
account_name varchar2(50),
account_postcode varchar2(25),
registered_date date,
turnover number,
no_of_employees number,
global_influence varchar2(25)
); 
alter table account_error add constraint pk_account_error primary key(account_skid);
------------------------------------------------------------