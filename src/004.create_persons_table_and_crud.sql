BEGIN;

CREATE TABLE empires.persons (
    pname   VARCHAR(10) PRIMARY KEY,
    display VARCHAR(25)
);

CREATE OR REPLACE FUNCTION empires.create_person (
    IN  i_pname     VARCHAR(10),
    IN  i_display   VARCHAR(25)
)
    RETURNS JSON AS
    $BODY$
    BEGIN
        INSERT INTO empires.persons (
        pname,
        display
        ) VALUES (
        i_pname,
        i_display
        );
    RETURN (
        SELECT
            row_to_json(t)
        FROM (
    		SELECT
    		    pname,
                display
            FROM
                empires.persons
            WHERE
                pname = i_pname) t) ;
    END
    $BODY$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION empires.update_person (
    IN  i_pname     VARCHAR(10),
    IN  i_display   VARCHAR(25)
)
    RETURNS JSON AS
    $BODY$
    BEGIN UPDATE
        empires.persons
    SET
        display = COALESCE(i_display, display)
    WHERE
        pname = i_pname;
    RETURN (
        SELECT
            row_to_json(t)
        FROM (
            SELECT
                pname,
                display
            FROM
                empires.persons
            WHERE
                pname = i_pname) t);
    END
    $BODY$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION empires.delete_person (
    IN i_pname VARCHAR(10)
)
RETURNS BOOLEAN AS $BODY$
BEGIN
    DELETE
    FROM
        empires.persons
    WHERE
        pname = i_pname;
    RETURN FOUND;
END;
$BODY$
LANGUAGE plpgsql;
COMMIT;
