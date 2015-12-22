BEGIN;
CREATE TABLE empires.organizations (
    oname       VARCHAR(10) PRIMARY KEY,
    display     VARCHAR(25),
    owner       VARCHAR(10) NOT NULL,
    abbr        VARCHAR(3),
    treasury    SMALLINT DEFAULT 0,
    CONSTRAINT abbr_length CHECK (char_length(abbr) < 2),
    CONSTRAINT abbr_upper  CHECK (abbr = upper(abbr)),
    CONSTRAINT positive_treasuty CHECK (treasury > -1),
    FOREIGN KEY (owner) REFERENCES empires.persons (pname)
);

CREATE OR REPLACE FUNCTION empires.create_organization (
    IN  i_oname  VARCHAR(10),
    IN  i_display   VARCHAR(25),
    IN  i_owner     VARCHAR(10),
    IN  i_abbr      VARCHAR(3),
    IN  i_treasury  SMALLINT
) RETURNS JSON AS
    $BODY$
    BEGIN
        INSERT INTO empires.organizations (
            oname,
            display,
            owner,
            abbr,
            treasury
        ) VALUES (
        i_oname,
        i_display,
        i_owner,
        i_abbr,
        i_treasury);
        RETURN (
            SELECT
            oname,
            display,
            owner,
            abbr,
            treasury
            FROM
                empires.organizations
            WHERE
                oname = i_oname);
    END;
    $BODY$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION empires.update_organization (
    IN  i_oname     VARCHAR(10),
    IN  i_display   VARCHAR(25),
    IN  i_owner     VARCHAR(10),
    IN  i_abbr      VARCHAR(3),
    IN  i_treasury  SMALLINT
    ) RETURNS JSON AS
        $BODY$
        BEGIN UPDATE
            empires.organizations o
        SET
            display = COALESCE(i_display, o.display),
            owner   = COALESCE(i_owner, o.owner),
            abbr    = COALESCE(i_abbr, o.abbr),
            treasuty    = COALESCE(i_treasury, o.treasury)
        WHERE
            o.oname = i_oname;
        RETURN (
            SELECT
            display,
            owner,
            abbr,
            treasury
            FROM
            empires.organizations
            WHERE
            oname = i_oname);
        END;
        $BODY$
        LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION empires.delete_organization (
  IN i_oname VARCHAR(10)
)
RETURNS BOOLEAN AS
$BODY$
BEGIN
  DELETE
  FROM
    empires.organizations
  WHERE
    oname = i_oname;
  RETURN FOUND;
END;
$BODY$
LANGUAGE plpgsql;


COMMIT;