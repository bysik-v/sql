-- ���������� ������
SELECT
 (SELECT max(username) FROM gv$session WHERE sid = a.sid) AS "��� ���������",
a.sid,a.*,' ��������� ',
 (SELECT max(username)  FROM gv$session WHERE sid = b.sid) AS "��� ������������",
b.sid as sid_2, sysdate
FROM gv$lock a, gv$lock b
 WHERE a.BLOCK > 0
       AND b.request > 0
       AND a.id1 = b.id1
       AND a.id2 = b.id2;



-- ��������������� ������� 1
select a.*,e.*,sysdate from gv$locked_object a, dba_objects e
where A.OBJECT_ID=E.OBJECT_ID -- and xidusn>0 -- ���� 0,�� ��� �� ������������, �� � �������
order by locked_mode desc,xidusn desc, object_name;


-- ��������������� ������� 2
SELECT *
  FROM gv$session      b,
       gv$lock l,
       gv$locked_object d,
       dba_objects     e
 WHERE d.session_id = b.sid
       AND d.object_id = e.object_id
       AND b.sid=L.SID and l.BLOCK > 0 and ctime>10
ORDER BY  BLOCKING_SESSION, locked_mode desc,ctime desc,object_name;   



-- �������� ������� � ����������� �������, ���� ����� ���������� >10 ���
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
       AND l.type='TX' -- ������ ����������
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


-- ������� ������. ��������� �� ����������� ������� 'sid,serial#'
alter system kill session '151,2562' immediate;


-- ������ ���������� LMode
0 - none
1 - null (NULL)
2 - row-S (SS) ����������� ���������� ������ (RS) ��� ���������� select for update;
3 - row-X (SX) ����������� ���������� ������ (RX) ��� ���������� ���������� insert, delete, update;
4 - share (S) ����������� ���������� ������� share mode, ������������, ��������, ���������� lock table <�> in share mode;
5 - S/Row-X (SSX) (����������� ���������� ������� � ����������� ���������� ����� share row exclusive; ������������, ��������, ���������� lock table <�..> in share row exclusive mode;
6 - exclusive (X) ����������� ���������� ( X) ��� ���������� lock table.

������  4 - share (S) � 5 - S/Row-X (SSX) ����������� ������ �����.
