--Visualizar el nombre de ese departamento y el número de empleados

set serveroutput on
DECLARE
 COD_DEPARTAMENTO DEPARTMENTS.DEPARTMENT_ID%TYPE:=10;
 NOM_DEPARTAMENTO DEPARTMENTS.DEPARTMENT_NAME%TYPE;
 NUM_EMPLE NUMBER;
BEGIN
 --RECUPERAR EL NOMBRE DEL DEPARTAMENTO
 SELECT DEPARTMENT_NAME INTO NOM_DEPARTAMENTO FROM
DEPARTMENTS WHERE DEPARTMENT_ID=COD_DEPARTAMENTO;
 --RECUPERAR EL NÚMERO DE EMLEADOS DEL DEPARTAMENTO
 SELECT COUNT(*) INTO NUM_EMPLE FROM EMPLOYEES WHERE
DEPARTMENT_ID=COD_DEPARTAMENTO;
 DBMS_OUTPUT.PUT_LINE('EL DEPARTAMENTO
'||NOM_DEPARTAMENTO||' TIENE '||NUM_EMPLE||' EMPLEADOS');
END;
/