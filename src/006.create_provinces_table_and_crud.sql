BEGIN;

CREATE TABLE empires.provinces (
  pname   VARCHAR(10) PRIMARY KEY,
  display VARCHAR(25) NOT NULL,
  level   INTEGER NOT NULL DEFAULT 0,
  regent  VARCHAR(10),
  loyalty INTEGER NOT NULL DEFAULT 3,
  domain  VARCHAR(10),
  visible boolean NOT NULL,
  abbr    VARCHAR(3),
  CONSTRAINT abbr_upper CHECK (abbr = upper(abbr)),
  CONSTRAINT abbr_length CHECK ( char_length(abbr) < 2),
  CONSTRAINT loyalty_boundary CHECK ( loyalty BETWEEN 0 AND 5),
  CONSTRAINT level_boundary CHECK ( level BETWEEN 0 AND 10),
  FOREIGN KEY (regent) REFERENCES empires.persons (pname),
  FOREIGN KEY (domain) REFERENCES empires.domains (dname)
  );

CREATE OR REPLACE FUNCTION empires.create_province (
  IN  i_pname   VARCHAR(10),
  IN  i_display VARCHAR(25),
  IN  i_level   INTEGER,
  IN  i_regent  VARCHAR(10),
  IN  i_loyalty INTEGER,
  IN  i_domain  VARCHAR(10),
  IN  i_visible boolean,
  IN  i_abbr    VARCHAR(3)
)
  RETURNS JSON AS
  $BODY$
  BEGIN
    INSERT INTO empires.provinces (
    pname,
    display,
    level,
    regent,
    loyalty,
    domain,
    visible,
    abbr
    ) VALUES (
    i_pname,
    i_display,
    i_level,
    i_regent,
    i_loyalty,
    i_domain,
    i_visible,
    i_abbr);
    RETURN (
    SELECT
      pname,
      display,
      level,
      regent,
      loyalty,
      domain,
      visible,
      abbr
    FROM
      empires.provinces
    WHERE
      pname = i_pname);
  END;
  $BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION empires.update_province (
  IN  i_pname   VARCHAR(10),
  IN  i_display VARCHAR(25),
  IN  i_level   INTEGER,
  IN  i_regent  VARCHAR(10),
  IN  i_loyalty INTEGER,
  IN  i_domain  VARCHAR(10),
  IN  i_visible boolean,
  IN  i_abbr    VARCHAR(3)
  ) RETURNS JSON AS
  $BODY$
  BEGIN
    UPDATE
      empires.provinces
    SET
      pname   = COALESCE(i_pname, provinces.pname),
      display = COALESCE(i_display, provinces.display),
      level   = COALESCE(i_level, provinces.level),
      regent  = COALESCE(i_regent, provinces.regent),
      loyalty = COALESCE(i_loyalty, provinces.loyalty),
      domain  = COALESCE(i_domain, provinces.domain),
      visible = COALESCE(i_visible, provinces.visible),
      abbr    = COALESCE(i_abbr, provinces.abbr)
    WHERE
      provinces.pname = i_pname;
  RETURN (
    SELECT
      pname,
      display,
      level,
      regent,
      loyalty,
      domain,
      visible,
      abbr
    FROM
      empires.provinces
    WHERE
      pname = i_pname);
  END;
  $BODY$
  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION empires.delete_province (
  IN i_pname VARCHAR(10)
)
RETURNS BOOLEAN AS
$BODY$
BEGIN
  DELETE
  FROM
    empires.provinces
  WHERE
    pname = i_pname;
  RETURN FOUND;
END;
$BODY$
LANGUAGE plpgsql;
COMMIT;
