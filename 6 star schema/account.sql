--surrogate key is not needed in dim tables

CREATE TABLE dim_account
(   
account_skid number not null,
ACCOUNT_ID_LDS NUMBER UNIQUE, 
ACCOUNT_ID_MCH NUMBER UNIQUE, 
account_name varchar2(50),
account_postcode varchar2(25),
registered_date date,
turnover number,
no_of_employees number,
global_influence varchar2(25)
); 
alter table dim_account add constraint pk_account_dim primary key(account_skid);

create sequence 
seq_dim_account_skid
start with 1
increment by 1;
--------------------------------------------------
CREATE TRIGGER TRIG_dim_account BEFORE INSERT ON dim_account FOR EACH ROW
BEGIN

:new.account_skid :=seq_dim_account_skid.NEXTVAL;

END

-----------------------------------------------------------
create or replace procedure  datadim_account 
as 
begin 
insert into dim_account 
  select 
  seq_dim_account_skid.NEXTVAL,
  ACCOUNT_ID_LDS, 
	ACCOUNT_ID_MCH, 
  account_name,
  account_postcode,
  registered_date,
  turnover,
  no_of_employees,
  global_influence
from account_clean;
end;

begin
datadim_account;
end;

select * from dim_account