BEGIN;

CREATE SEQUENCE empires.province_details_seq MINVALUE 110000 MAXVALUE 199999;

CREATE TYPE empires.terrain_types AS ENUM ('heavy forrest', 'light forrest', 'plains', 'desert', 'mountains', 'hills', 'swamp', 'jungle');
CREATE TYPE empires.harbour_types AS ENUM ('fishing', 'trade', 'military');
CREATE TYPE empires.road_types AS ENUM ('paths', 'roads', 'highway');
CREATE TYPE empires.bridge_types AS ENUM ('wood', 'stone');

CREATE TABLE empires.province_details (
  province_details_id INTEGER DEFAULT nextval('empires.province_details_seq'),
  province VARCHAR(10),
  terrain empires.terrain_types,
  harbour empires.harbour_types,
  roads   empires.road_types,
  city    VARCHAR(20),
  bridges empires.bridge_types,
  FOREIGN KEY (province) REFERENCES empires.provinces (pname) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE OR REPLACE FUNCTION empires.create_province_details(
    IN  i_province      VARCHAR(10),
    IN  i_terrain       empires.terrain_types,
    IN  i_harbour_types empires.harbour_types,
    IN  i_road_types    empires.road_types,
    IN  i_city          VARCHAR(20),
    IN  i_bridge_types  empires.bridge_types
) RETURNS JSON AS
    $BODY$
    BEGIN
        INSERT INTO empires.province_details (
            province,
            terrain,
            harbour,
            roads,
            city,
            bridges
        ) VALUES (
        i_province,
        i_terrain,
        i_harbour,
        i_roads,
        i_city,
        i_bridges);
        RETURN ( SELECT row_to_json (t) FROM (
            SELECT
            province_details_id
            province,
            terrain,
            harbour,
            roads,
            city,
            bridges
            FROM
                empires.province_details
            WHERE
                province = i_province) t);
    END;
    $BODY$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION empires.update_province_details (
    IN  i_province_details_id   INTEGER,
    IN  i_province              VARCHAR(10),
    IN  i_terrain               empires.terrain_types,
    IN  i_harbour_types         empires.harbour_types,
    IN  i_road_types            empires.road_types,
    IN  i_city                  VARCHAR(20),
    IN  i_bridge_types          empires.bridge_types
) RETURNS JSON AS
    $BODY$
    BEGIN UPDATE
        empires.province_details pd
    SET
        province = COALESCE(i_province, pd.province),
        terrain = COALESCE(i_terrain, pd.terrain),
        harbour = COALESCE(i_harbour, pd.harbour),
        roads = COALESCE(i_roads, pd.roads),
        city = COALESCE(i_city, pd.city),
        bridges = COALESCE(i_bridges, pd.bridges)
    WHERE
        pd.province_details_id = i_province_details_id;
    RETURN ( SELECT row_to_json (t) FROM (
        SELECT
            province_details_id
            province,
            terrain,
            harbour,
            roads,
            city,
            bridges
        FROM
            empires.province_details pd
        WHERE
            pd.province_details_id = i_province_details_id)t);
    END;
    $BODY$
    LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION empires.delete_province_details (
    IN i_province_details_id INTEGER)
RETURNS BOOLEAN AS
    $BODY$
    BEGIN
        DELETE FROM
            empires.province_details
        WHERE
            province_details_id = i_province_details_id;
        RETURN FOUND;
END;
$BODY$
LANGUAGE plpgsql;

COMMIT;