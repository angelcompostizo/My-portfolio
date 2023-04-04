DECLARE
    nombre      VARCHAR2(20);
    apellido1   VARCHAR2(20);
    apellido2   VARCHAR2(20);
    iniciales   VARCHAR2(6);
BEGIN
    nombre := 'Angel';
    apellido1 := 'Compostizo';
    apellido2 := 'Olarte';
    iniciales := substr(nombre,1,1)
     || '.'
     || substr(apellido1,1,1)
     || '.'
     || substr(apellido2,1,1)
     || '.';

    dbms_output.put_line(upper(iniciales) );
END;