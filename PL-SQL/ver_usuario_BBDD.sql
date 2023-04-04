--ver que usuario se ha conectado a la base de datos.
SET SERVEROUTPUT ON

DECLARE
    usuario   VARCHAR2(30);
BEGIN
    usuario := user;
    CASE
        usuario
        WHEN 'SYS' THEN
            dbms_output.put_line('ERES
SUPERADMINISTRADOR');
        WHEN 'SYSTEM' THEN
            dbms_output.put_line('ERES
ADMINISTRADOR NORMAL');
        WHEN 'HR' THEN
            dbms_output.put_line('ERES DE
RECURSOS HUMANOS');
        ELSE
            dbms_output.put_line('USUARIO NO
AUTORIZADO');
    END CASE;

END;