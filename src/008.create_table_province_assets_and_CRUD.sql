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
    FOREIGN KEY (province) REFERENCES empires.provinces(pname) ON DELETE CASCADE,
    CONSTRAINT level_boundary CHECK (level between 0 and 10)
);

COMMIT;