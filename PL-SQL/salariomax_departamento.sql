--bloque Pl-SQL que devuelve el salario maximo del departamento 100 y lo deja en variable y lo muestra
SET SERVEROUTPUT ON

DECLARE
    salario_maximo   employees.salary%TYPE;
BEGIN
    SELECT
        MAX(salary)
    INTO
        salario_maximo
    FROM
        employees
    WHERE
        department_id = 100;

    dbms_output.put_line('el salario máximo de ese departamento
es:' || salario_maximo);
END;