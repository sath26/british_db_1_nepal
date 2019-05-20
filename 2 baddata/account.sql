--doesnt have values in mch
--turnover
--no_of_employees
--global_influence

--doesnt have values in lds
--account_registered
create or replace procedure bad_data_account
as 
begin
	UPDATE STG_ACCOUNT 
	SET ACCOUNT_NAME = '##Zed Zand'
	WHERE ACCOUNT_KEY = 222;
end bad_data_account;

begin
bad_data_account;
end;

