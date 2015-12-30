CREATE OR REPLACE FUNCTION empires.get_organizations()
RETURNS JSON AS
$BODY$
BEGIN
    RETURN (
    SELECT array_to_json(array_agg(row_to_json(t.*)))
    FROM (
        SELECT eo.oname, eo.display, eo.owner, ep.display, eo.abbr, eo.treasury
        FROM empires.organizations eo, empires.persons ep
        WHERE eo.owner = ep.pname) t);
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION empires.get_organization_details(
    IN i_oname  VARCHAR(10)
) RETURNS JSON AS
$BODY$
BEGIN
    RETURN (
    SELECT row_to_json(t.*) as org_details
    FROM (
        SELECT eo.oname, eo.display, eo.owner, eo.abbr, eo.treasury, (
            SELECT array_to_json(array_agg(row_to_json(d)))
            FROM (
                SELECT eh.holding_id, eh.level, ep.pname, ep.display, eh.type
                FROM empires.holdings eh, empires.provinces ep
                WHERE owner = i_oname AND ep.pname = eh.province) d) AS holdings
        FROM empires.organizations eo WHERE eo.oname = i_oname)t


     );
END;
$BODY$
LANGUAGE plpgsql;