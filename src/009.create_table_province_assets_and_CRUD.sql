BEGIN;

CREATE SEQUENCE empires.province_assets_seq MINVALUE 200000 MAXVALUE 299999;

CREATE TYPE empires.province_asset_types AS ENUM (
    'castle',
    'wonder',
    'palace');

CREATE TABLE empires.province_assets (
    asset_id    SMALLINT DEFAULT nextval('empires.province_assets_seq') PRIMARY KEY,
    asset_type  empires.province_asset_types,
    display     VARCHAR(25),
    province    VARCHAR(10),
    level       SMALLINT,
    FOREIGN KEY (province) REFERENCES empires.provinces(pname) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT level_boundary CHECK (level between 0 and 10)
);

CREATE OR REPLACE FUNCTION empires.create_province_asset (
    IN  i_asset_type    empires.province_asset_types,
    IN  i_display       VARCHAR(25),
    IN  i_province      VARCHAR(10),
    IN  i_level         SMALLINT
) RETURNS JSON AS
    $BODY$
    BEGIN
        INSERT INTO empires.province_assets (
        asset_type,
        display,
        province,
        level
        ) VALUES (
        i_assets_type,
        i_display,
        i_province,
        i_level);
        RETURN (
            SELECT
            asset_id,
            asset_type,
            display,
            province,
            level
            FROM
                empires.province_assets
            WHERE
                asset_type = i_asset_type AND
                province = i_province);
    END;
    $BODY$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION empires.update_province_asset (
    IN  i_asset_id      INTEGER,
    IN  i_asset_type    empires.province_asset_types,
    IN  i_display       VARCHAR(25),
    IN  i_level         SMALLINT
) RETURNS JSON AS
    $BODY$
    BEGIN UPDATE
        empires.province_assets pa
    SET
        asset_type  = COALESCE(i_asset_type, pa.asset_type),
        display     = COALESCE(i_display, pa.display),
        level       = COALESCE(i_level, pa.level)
    WHERE
        pa.asset_id = i_asset_id;
    RETURN (
        SELECT
            asset_id,
            asset_type,
            display,
            level
        FROM
            empires.province_assets pa
        WHERE
            pa.asset_id = i_asset_id);
    END;
    $BODY$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION empires.delete_province_asset (
    IN  i_asset_id  INTEGER
) RETURNS BOOLEAN AS
    $BODY$
    BEGIN
        DELETE FROM
            empires.province_assets pa
        WHERE
            pa.asset_id = i_asset_id;
        RETURN FOUND;
    END;
    $BODY$
    LANGUAGE plpgsql;

COMMIT;