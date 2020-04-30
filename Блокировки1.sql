-- Блокировка сессий
SELECT
 (SELECT max(username) FROM gv$session WHERE sid = a.sid) AS "Кто блокирует",
a.sid,a.*,' блокирует ',
 (SELECT max(username)  FROM gv$session WHERE sid = b.sid) AS "Кто заблокирован",
b.sid as sid_2, sysdate
FROM gv$lock a, gv$lock b
 WHERE a.BLOCK > 0
       AND b.request > 0
       AND a.id1 = b.id1
       AND a.id2 = b.id2;



-- Заблокированные объекты 1
select a.*,e.*,sysdate from gv$locked_object a, dba_objects e
where A.OBJECT_ID=E.OBJECT_ID -- and xidusn>0 -- если 0,то еще не заблокирован, но в очереди
order by locked_mode desc,xidusn desc, object_name;


-- Заблокированные объекты 2
SELECT *
  FROM gv$session      b,
       gv$lock l,
       gv$locked_object d,
       dba_objects     e
 WHERE d.session_id = b.sid
       AND d.object_id = e.object_id
       AND b.sid=L.SID and l.BLOCK > 0 and ctime>10
ORDER BY  BLOCKING_SESSION, locked_mode desc,ctime desc,object_name;   



-- Открытые курсоры в блокирующих сессиях, если время блокировки >10 сек
WITH t AS (
SELECT distinct /*+ ordered*/e.object_name, E.OBJECT_TYPE,
       b.sid,b.serial#,D.LOCKED_MODE,D.ORACLE_USERNAME,D.OS_USER_NAME,
       B.SADDR, l.ctime as ctime_s,l.inst_id,l.type as type_s,l.lmode as lmode_s,l.request as request_s,l.block as block_s
  FROM gv$session      b,
       gv$lock l,
       gv$locked_object d,
       dba_objects     e
 WHERE d.session_id = b.sid
       AND d.object_id = e.object_id
       AND b.sid=L.SID and l.BLOCK > 0 and ctime>10
       AND BLOCKING_SESSION is null
       AND l.type='TX' -- только транзакции
       )
SELECT distinct z.*, t.serial#,/*GVSQL.SQL_FULLTEXT,*/ t.object_type, t.object_name, 
            t.LOCKED_MODE,t.ORACLE_USERNAME,t.OS_USER_NAME,
            t.ctime_s,t.type_s,t.lmode_s,t.request_s,t.block_s,sysdate
  FROM 
  (SELECT distinct t.inst_id,t.sql_id,t.sql_text, t.saddr,t.sid
  FROM gv$open_cursor t) z, t,gv$sql gvsql
WHERE t.inst_id=z.inst_id and  t.sid=Z.SID and Z.SADDR=t.sADDR 
and z.sql_id=gvsql.sql_id and GVSQL.INST_ID=Z.INST_ID
order by t.ctime_s,z.sql_id;


-- Удалить сессию. Параметры из предыдущего запроса 'sid,serial#'
alter system kill session '151,2562' immediate;


-- Режимы блокировки LMode
0 - none
1 - null (NULL)
2 - row-S (SS) разделяемая блокировка строки (RS) при выполнении select for update;
3 - row-X (SX) монопольная блокировка строки (RX) при выполнении операторов insert, delete, update;
4 - share (S) разделяемая блокировка таблицы share mode, генерируется, например, оператором lock table <…> in share mode;
5 - S/Row-X (SSX) (разделяемая блокировка таблицы и монопольная блокировка строк share row exclusive; генерируется, например, оператором lock table <…..> in share row exclusive mode;
6 - exclusive (X) монопольная блокировка ( X) при выполнении lock table.

Режимы  4 - share (S) и 5 - S/Row-X (SSX) встречаются крайне редко.
