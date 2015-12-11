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
  FOREIGN KEY (province) REFERENCES empires.provinces (pname)
);