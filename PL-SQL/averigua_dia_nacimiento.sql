
--averigua dia que naciste

DECLARE
    fec_nac      DATE;
    dia_semana   VARCHAR2(100);
BEGIN
    fec_nac := TO_DATE('10/10/1965');
    dia_semana := TO_CHAR(fec_nac,'DAY');
    dbms_output.put_line(dia_semana);
END;
