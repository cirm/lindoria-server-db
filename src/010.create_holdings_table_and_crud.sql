BEGIN;

CREATE TYPE empires.holding_types AS ENUM ('guild', 'source', 'law', 'temple');

CREATE TABLE empires.holdings (
    level       SMALLINT DEFAULT 0,
    owner       VARCHAR(10),
    province    VARCHAR(10),
    type        empires.holding_types,
    FOREIGN KEY (owner) REFERENCES empires.organizations (oname),
    FOREIGN KEY (province) REFERENCES empires.provinces (pname),
    PRIMARY KEY (owner, province)
);

COMMIT;