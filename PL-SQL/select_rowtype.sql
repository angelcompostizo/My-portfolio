SET SERVEROUTPUT ON

DECLARE
    salario    NUMBER;
    nombre     employees.first_name%TYPE;
    empleado   employees%rowtype;
BEGIN
    SELECT  --SOLO PUEDE DEVOLVER UNA FILA
        *
    INTO
        empleado
    FROM
        employees
    WHERE
        employee_id = 100;

    dbms_output.put_line(empleado.salary * 100);
    dbms_output.put_line(empleado.first_name);
END;