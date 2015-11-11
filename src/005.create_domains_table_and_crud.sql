BEGIN;

CREATE TABLE empires.domains (
    dname     VARCHAR(10) PRIMARY KEY,
    regent    VARCHAR(10),
    display   VARCHAR(25),
    abbr      VARCHAR(3),
    treasury  SMALLINT DEFAULT 0,
    CONSTRAINT  abbr_upper  CHECK (abbr = upper(abbr)),
    CONSTRAINT  positive_treasury CHECK (treasury > -1),
    FOREIGN KEY (regent) REFERENCES empires.persons (pname)
);

CREATE OR REPLACE FUNCTION empires.create_domain (
  IN  i_dname     VARCHAR(10),
  IN  i_regent    VARCHAR(10),
  IN  i_display   VARCHAR(25),
  IN  i_abbr      VARCHAR(3),
  IN  i_treasury  SMALLINT
)
  RETURNS JSON AS
  $BODY$
  BEGIN
    INSERT INTO empires.domains (
    dname,
    regent,
    display,
    abbr,
    treasury
    ) VALUES (
    i_dname,
    i_regent,
    i_display,
    i_abbr,
    i_treasury);
    RETURN (
      SELECT
      dname,
      regent,
      display,
      abbr,
      treasury
      FROM
        empires.domains
      WHERE
        dname = dname);
  END;
  $BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION empires.update_domain (
  IN  i_dname   VARCHAR(10),
  IN  i_regent  VARCHAR(10),
  IN  i_display VARCHAR(25),
  IN  i_abbr    VARCHAR(3),
  IN  i_treasury  SMALLINT
)
  RETURNS JSON AS
  $BODY$
  BEGIN
    UPDATE
      empires.domains
    SET
      regent  = COALESCE(i_regent, domains.regent),
      display = COALESCE(i_display, domains.display),
      abbr    = COALESCE(i_abbr, domains.abbr),
      treasury  = COALESCE(treasury, i_treasury)
    WHERE
      domains.dname = i_dname;
    RETURN (
      SELECT
        dname,
        regent,
        display,
        abbr,
        treasury
      FROM
        empires.domains
      WHERE
        dname = i_dname);
  END;
  $BODY$
  LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION empires.delete_domain (
    IN i_dname VARCHAR(10)
)
RETURNS BOOLEAN AS $BODY$
BEGIN
    DELETE
    FROM
        empires.domains
    WHERE
        dname = i_dname;
    RETURN FOUND;
END;
$BODY$
LANGUAGE plpgsql;
COMMIT;


