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
COMMIT;

CREATE OR REPLACE FUNCTION empires.create_domain (
  IN  i_dname,
  IN  i_regent,
  IN  i_display,
  IN  i_abbr,
  IN  i_treasury
)