# british_db_1_nepal for KPI3(growth)
use this project on apex
# use sqlplus debugging.. 
sqlplus workspace/password
run the script
if any error occurs:
  show error
easier to debug than from apex itself because the error message is more descriptive

# for ETL
project table must have following table structure for staging table of project
and all the values must remain until load table because for fact table to create relationship this id must match with each other with fact table
```project_id_sk
project_id_lds 
project_id_mch
account_id_lds_fk
account_id_mch_fk(company)
consultant_id_lds_fk
consultant_id_mch_fk
```
# for creating column name and run insert query later on
dont use small letter 
use capital letter with double quotation only
small letter cause bug i.e. column not allowed here.

# cursor name used instead of table name for rowtype
see in ```dim_table.sql```
