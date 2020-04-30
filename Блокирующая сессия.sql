-- SQL блокирующей сессии
Select * from
(
Select 
lo.locked_mode||'-'||
CASE lo.locked_mode
WHEN 0 THEN 'NONE'
WHEN 1 THEN 'NULL'
WHEN 2 THEN 'ROWS_S (SS) Row Share Lock'
WHEN 3 THEN 'ROW_X (SX) Row Exclusive Table Lock'
WHEN 4 THEN 'SHARE (S) Share Table Lock'
WHEN 5 THEN 'S/ROW-X (SSX) Share Row Exclusive Table Lock'
WHEN 6 THEN 'Exclusive (X) Exclusive Table Lock'
END as locked_mode,
ao.object_name,
(select count(*) from gv$session ss where ss.blocking_session=s.sid) as cnt_wait,
SQL1.SQL_TEXT,
 s.*
from  gv$locked_object lo, all_objects ao, gv$sql sql1, gv$session s
where  lo.object_id=ao.object_id
and    sql1.sql_id = s.sql_id
and    sql1.inst_id = s.inst_id
and   ( (s.SID = lo.session_id AND s.INST_ID = lo.inst_id))
and s.blocking_session is null
) s1
--where cnt_wait>0
order by cnt_wait desc,locked_mode desc;


-- Открытые курсоры блокирующей сессии
Select * from
(
Select 
lo.locked_mode||'-'||
CASE lo.locked_mode
WHEN 0 THEN 'NONE'
WHEN 1 THEN 'NULL'
WHEN 2 THEN 'ROWS_S (SS) Row Share Lock'
WHEN 3 THEN 'ROW_X (SX) Row Exclusive Table Lock'
WHEN 4 THEN 'SHARE (S) Share Table Lock'
WHEN 5 THEN 'S/ROW-X (SSX) Share Row Exclusive Table Lock'
WHEN 6 THEN 'Exclusive (X) Exclusive Table Lock'
END as locked_mode
,ao.object_name,
(select count(*) from gv$session ss where ss.blocking_session=s.sid) as cnt_wait,
o.sql_text as open_curs_sql_text, o.user_name as open_curs_user_name, o.sql_id as open_curs_sql_id, s.*
from  gv$locked_object lo, all_objects ao, gv$open_cursor o, gv$session s
where  lo.object_id=ao.object_id and o.saddr = s.saddr
and    o.sid = s.sid
and    o.inst_id = s.inst_id
and   ( (O.SID = lo.session_id AND O.INST_ID = lo.inst_id))
and s.blocking_session is null
) s1
--where cnt_wait>0
order by cnt_wait desc,locked_mode desc;
