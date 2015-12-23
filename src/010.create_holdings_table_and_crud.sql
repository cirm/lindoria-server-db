BEGIN;

CREATE TYPE empires.holding_types AS ENUM ('guild', 'source', 'law', 'temple');
CREATE SEQUENCE empires.holding_seq MINVALUE 200000 MAXVALUE 299999;

CREATE TABLE empires.holdings (
    holding_id  INTEGER DEFAULT nextval('empires.holding_seq'),
    level       SMALLINT DEFAULT 0,
    owner       VARCHAR(10),
    province    VARCHAR(10),
    type        empires.holding_types,
    FOREIGN KEY (owner) REFERENCES empires.organizations (oname) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (province) REFERENCES empires.provinces (pname) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (owner, province)
);

CREATE OR REPLACE FUNCTION empires.create_holding(
    IN  i_level     SMALLINT,
    IN  i_owner     VARCHAR(10),
    IN  i_province  VARCHAR(10),
    IN  i_type      empires.holding_types
) RETURNS JSON AS
    $BODY$
    BEGIN
        INSERT INTO empires.holdings (
        level,
        owner,
        province,
        type
        ) VALUES (
        i_level,
        i_owner,
        i_province,
        i_type);
        RETURN (
            SELECT
            holding_id,
            level,
            owner,
            province,
            type
            FROM
                empires.holdings
            WHERE
                owner   = i_owner
                AND type = i_type
                AND province = i_province);
    END;
    $BODY$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION empires.update_holding(
    IN  i_holding_id    INTEGER,
    IN  i_level     SMALLINT,
    IN  i_owner     VARCHAR(10),
    IN  i_province  VARCHAR(10),
    IN  i_type      empires.holding_types
) RETURNS JSON AS
    $BODY$
    BEGIN UPDATE
        empires.holdings h
    SET
        level   = COALESCE(i_level, h.level),
        owner   = COALESCE(i_owner, h.owner)
    WHERE
        h.holding_id = i_holding_id;
    RETURN (
        SELECT
            holding_id,
            level,
            owner,
            province,
            type
        FROM
            empires.holdings h
        WHERE
            h.holding_id = i_holding_id);
    END;
    $BODY$
    LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION empires.delete_holding (
    IN i_holding_id INTEGER)
RETURNS BOOLEAN AS
    $BODY$
    BEGIN
        DELETE FROM
            empires.holdings
        WHERE
            holding_id = i_holding_id;
        RETURN FOUND;
END;
$BODY$
LANGUAGE plpgsql;

COMMIT;