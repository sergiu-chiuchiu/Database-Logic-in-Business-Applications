CREATE OR REPLACE TRIGGER la_logare
 AFTER LOGON ON FOTACHEM.SCHEMA
BEGIN
re_compilare ;
END ;
/     
