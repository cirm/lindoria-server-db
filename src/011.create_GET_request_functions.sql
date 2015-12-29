select row_to_json(t)
from (
select eo.oname, eo.display, eo.owner, ep.display, eo.abbr, eo.treasury
from empires.organizations eo, empires.persons ep
where eo.owner = ep.pname) t;

select eh.holding_id, eh.level, eh.owner, ep.pname, ep.display, eh.type
from empires.holdings eh, empires.provinces ep
where owner = 'lvahtkond' and ep.pname = eh.province;

with holdings as (select eh.holding_id, eh.level, eh.owner, ep.pname, ep.display, eh.type
                  from empires.holdings eh, empires.provinces ep
                  where owner = 'lvahtkond' and ep.pname = eh.province)



select eo.oname, eo.display, eo.owner, ep.display, eo.abbr,(array_to_json(array_agg(select row_to_json(t) from (select holding_id, level, owner, pname, display, type from holdings)t))) as holdings, eo.treasury
from empires.organizations eo, empires.persons ep, holdings
where eo.owner = ep.pname and eo.oname = 'lvahtkond' ;

select row_to_json(t)
from ()t

(select array( select holding_id from holdings)),



-----------------------------
select row_to_json(t) as org_details from (
select eo.oname, eo.display, eo.owner, eo.abbr, eo.treasury,
(
    select array_to_json(array_agg(row_to_json(d)))
    from (select eh.holding_id, eh.level, ep.pname, ep.display, eh.type
                            from empires.holdings eh, empires.provinces ep
                            where owner = 'lvahtkond' and ep.pname = eh.province ) d) as holdings
                            from empires.organizations eo where eo.oname = 'lvahtkond')t;



---------------------------------
select row_to_json(t) as org
from (
select eo.oname, eo.display, eo.owner, ep.display, eo.abbr, eo.treasury
from empires.organizations eo, empires.persons ep
where eo.owner = ep.pname) t;