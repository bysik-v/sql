select * from dt,det where dt.id=det.dt_id

select * from dt LEFT JOIN det on dt.id=p_common.TO_NUM(det.dt_id)
where det.id is null--=228

select 
first_value(name) over(order by name rows between 1 preceding and 1 preceding) as prev,
dt.* 
from 
(select * from dt order by name) dt
--order by name


select 
last_value(name) over(order by name rows between 1 preceding and current row) as prev,
dt.* 
from dt
order by name

select 
first_value(name) over(order by name rows between 1 preceding and 1 preceding) as prev,
dt.* 
from dt
--order by name
