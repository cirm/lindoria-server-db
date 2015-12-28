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
select row_to_json(t)
from (
select eo.oname, eo.display, eo.owner, ep.display,(select * from holdings), eo.abbr, eo.treasury
from empires.organizations eo, empires.persons ep, holdings
where eo.owner = ep.pname and eo.owner = 'lvahtkond') t;