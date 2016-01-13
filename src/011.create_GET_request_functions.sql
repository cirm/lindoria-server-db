CREATE OR REPLACE FUNCTION empires.get_organizations(
    OUT oname   VARCHAR(10),
    OUT display VARCHAR(25),
    OUT owner   VARCHAR(10),
    OUT province    VARCHAR(25),
    OUT abbr    VARCHAR(3),
    OUT treasury    SMALLINT
    ) RETURNS SETOF record AS
$BODY$
        SELECT eo.oname, eo.display, eo.owner, ep.display, eo.abbr, eo.treasury
        FROM empires.organizations eo, empires.persons ep
        WHERE eo.owner = ep.pname;
$BODY$
LANGUAGE sql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION empires.get_organization_details(
    IN i_oname  VARCHAR(10),
    OUT oname VARCHAR (10),
    OUT display VARCHAR(25),
    OUT owner   VARCHAR(10),
    OUT abbr    VARCHAR(3),
    OUT treasury SMALLINT,
    OUT holdings    JSON
) RETURNS record AS
$BODY$
    SELECT eo.oname, eo.display, eo.owner, eo.abbr, eo.treasury, (
        SELECT array_to_json(array_agg(row_to_json(d)))
        FROM (
            SELECT eh.holding_id, eh.level, ep.pname, ep.display, eh.type
            FROM empires.holdings eh, empires.provinces ep
            WHERE owner = i_oname AND ep.pname = eh.province) d) AS holdings
    FROM empires.organizations eo
    WHERE eo.oname = i_oname;
$BODY$
LANGUAGE sql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION empires.get_domains(
    OUT dname   VARCHAR(10),
    OUT regent  VARCHAR(10),
    OUT display VARCHAR(25),
    OUT abbr    VARCHAR(3),
    OUT treasury    SMALLINT
    )   RETURNS SETOF record AS
$BODY$
    SELECT ed.dname, ed.regent, ed.display, ed.abbr, ed.treasury
    FROM empires.domains ed;
$BODY$
LANGUAGE sql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION empires.get_domain_details(
    IN i_dname  VARCHAR(10),
    OUT dname   VARCHAR(10),
    OUT regent  VARCHAR(10),
    OUT display VARCHAR(25),
    OUT abbr    VARCHAR(3),
    OUT treasury    SMALLINT,
    OUT provinces JSON
    ) RETURNS record AS
$BODY$
    SELECT ed.dname, ed.regent, ed.display, ed.abbr, ed.treasury, (
        SELECT array_to_json(array_agg(row_to_json(d)))
        FROM (
            SELECT ep.pname, ep.display, ep.level, ep.regent, ep.loyalty, ep.abbr
            FROM empires.provinces ep
            WHERE ep.domain = i_dname) d) AS provinces
    FROM empires.domains ed
    WHERE ed.dname = i_dname;
$BODY$
LANGUAGE sql STABLE SECURITY DEFINER;

CREATE OR REPLACE FUNCTION empires.get_provinces(
    OUT pname   VARCHaR(10),
    OUT display VARCHAR(25),
    OUT level   INTEGER,
    OUT regent  VARCHAR(10),
    OUT loyalty INTEGER,
    OUT domain  VARCHAR(10),
    OUT abbr    VARcHAR(3),
    OUT holdings    JSON
    ) RETURNS SETOF record AS
$BODY$
    SELECT ep.pname, ep.display, ep.level, ep.regent, ep.loyalty, ep.domain, ep.abbr, (
        SELECT array_to_json(array_agg(row_to_json(d)))
        FROM (
            SELECT eh.holding_id, eh.level, eh.owner, eo.display, eh.type
            FROM empires.holdings eh, empires.organizations eo
            WHERE eh.province = ep.pname AND eh.owner = eo.oname) d) AS holdings
    FROM empires.provinces ep
    WHERE ep.visible = true;
$BODY$
LANGUAGE sql STABLE SECURITY DEFINER;