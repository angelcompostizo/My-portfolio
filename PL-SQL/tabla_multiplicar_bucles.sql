--tabla de multiplicar usando bucles y condicionales

DECLARE
    x   NUMBER;
    z   NUMBER;
BEGIN
    x := 1;
    z := 1;
    LOOP
        EXIT WHEN x = 11;
        dbms_output.put_line('Tabla de multiplicar del :' || x);
        LOOP
            EXIT WHEN z = 11;
            dbms_output.put_line(x * z);
            z := z + 1;
        END LOOP;

        z := 0;
        x := x + 1;
    END LOOP;

END;
/

DECLARE
    x   NUMBER;
    z   NUMBER;
BEGIN
    x := 1;
    z := 1;
    WHILE x < 11 LOOP
        dbms_output.put_line('Tabla de multiplicar del :' || x);
        WHILE z < 11 LOOP
            dbms_output.put_line(x * z);
            z := z + 1;
        END LOOP;

        z := 0;
        x := x + 1;
    END LOOP;

END;
/

BEGIN
    FOR x IN 1..10 LOOP
        dbms_output.put_line('Tabla de multiplicar del :' || x);
        FOR z IN 1..10 LOOP
            dbms_output.put_line(x * z);
        END LOOP;

    END LOOP;
END;
/