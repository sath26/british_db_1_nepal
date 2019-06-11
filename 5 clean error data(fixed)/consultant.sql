CREATE OR replace PROCEDURE Spr_clean_consultant 
AS 
  CURSOR cur IS 
    SELECT * 
    FROM   consultant_error; 
  res       consultant_error%ROWTYPE; 
  temp_val  consultant_clean.consultant_name%TYPE; 
 -- temp_val1 consultant_clean.consultant_name%TYPE; 
BEGIN 
    OPEN cur; 
    LOOP 
        FETCH cur INTO res; 
        EXIT WHEN cur%NOTFOUND; 

        CASE TRUE 
          WHEN res.consultant_name IS NULL THEN 
            INSERT INTO consultant_clean 
            VALUES     ( res.consultant_skid, 
                        res.consultant_id_lds,
                        res.consultant_id_mch,
                        'saugat thapa', 
                        res.consultant_postcode, 
                        res.highest_qualification, 
                        res.consultant_registered, 
                        res.consultant_skill, 
                        res.preferred_role ); 

            UPDATE con_issues 
            SET    i_status = 'FIXED' 
            WHERE  row_id = res.consultant_skid;  
          
            WHEN Regexp_like(res.consultant_name, '[*|_|#|&]') THEN 
              SELECT TRANSLATE(res.consultant_name, '#&*_', ' ') 
              INTO   temp_val 
              FROM   dual; 
              INSERT INTO consultant_clean 
              VALUES     ( res.consultant_skid, 
                          res.consultant_id_lds, 
                          res.consultant_id_mch, 
                          Trim(temp_val), 
                          res.consultant_postcode, 
                          res.highest_qualification, 
                          res.consultant_registered, 
                          res.consultant_skill, 
                          res.preferred_role ); 

              UPDATE con_issues 
              SET    i_status = 'FIXED' 
              WHERE  row_id = res.consultant_skid; 
            WHEN Regexp_like(res.consultant_name, '[[:digit:]]') THEN 
              SELECT TRANSLATE(res.consultant_name, '123456789', ' ') 
              INTO   temp_val 
              FROM   dual; 
              INSERT INTO consultant_clean 
              VALUES( res.consultant_skid, 
                          res.consultant_id_lds, 
                          res.consultant_id_mch, 
                          Trim(temp_val), 
                          res.consultant_postcode, 
                          res.highest_qualification, 
                          res.consultant_registered, 
                          res.consultant_skill, 
                          res.preferred_role ); 
              UPDATE con_issues 
              SET    i_status = 'FIXED' 
              WHERE  row_id = res.consultant_skid; 
        END CASE; 
    END LOOP; 
    CLOSE cur; 
EXCEPTION 
  WHEN no_data_found THEN 
             dbms_output.Put_line('DATA NOT FOUND'); 
END spr_clean_consultant; 
--EXECUTING PROCEDURE-----------------------------------
BEGIN 
SPR_CLEAN_CONSULTANT;
END;
------------------------*******************--------------------------------
 CREATE SEQUENCE   "clean_Consultant_SEQ" 
 INCREMENT BY 1 
 START WITH 221 
 CACHE 20 
 NOORDER 
 NOCYCLE ;

CREATE OR REPLACE TRIGGER  "clean_CONSULTANT_TRIGGER_3"
 before insert on CONSULTANT_CLEAN
for each row
begin
:new.CONSULTANT_SKID:=STAGING_CONSULTANT_SEQ.NEXTVAL;
end;
--100% data migration is needed
-- update issue table that its fixed
-- THERE ARE VALUES THAT ARE EMPTY
------------------------------------------------------------------------------------------------------
