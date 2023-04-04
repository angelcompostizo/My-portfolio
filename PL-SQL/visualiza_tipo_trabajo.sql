--visualiza el tipo de trabajo de el empleado con id=100
SET SERVEROUTPUT ON

DECLARE
    tipo_trabajo   employees.job_id%TYPE;
BEGIN
    SELECT
        job_id
    INTO
        tipo_trabajo
    FROM
        employees
    WHERE
        employee_id = 100;

    dbms_output.put_line('El tipo de trabajo del empleado 100
es:' || tipo_trabajo);
END;
/