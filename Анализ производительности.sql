-- ������ ������� � ��������� redo log ������
select * from gv$log;

-- ������ �������� ������
SELECT * FROM gv$session_wait
order by seconds_in_wait desc ;

-- �������� �������� _WAIT_TIME
select * from gv$sqlarea;

-- �������� ������� ��������
--select * from v$event_name;

-- ����������� �������� ������ � �����������
select * from gv$session where blocking_session is not null
order by blocking_session;

-- ����������� �������� ������ 1
select username, schemaname, inst_id, program,state,event, count(*) as cnt1
from gv$session
group by username, schemaname, inst_id, program,state,event
order by cnt1 desc;

-- ������ ������� �������� �� ���� �������
select event, time_waited/100 seconds, total_waits calls
from gv$system_event
order by 2 desc;

-- �������� �� ������� ������
SELECT   DECODE (session_state, 'WAITING', event, NULL) event,
   session_state, COUNT(*), SUM (time_waited) time_waited
   FROM   gv$active_session_history
   WHERE --   module = 'ARXENV' AND  
   sample_time > SYSDATE - (2/24)
  GROUP BY DECODE (session_state, 'WAITING', event, NULL), session_state
  order by 4 desc;


-- ����������� ��������
select row_number() over (order by elapsed_time_sek desc) N,q.* from
(select /*+ no_merge(snaps)*/
 (select DBMS_LOB.SUBSTR(sql_text,300) from dba_hist_sqltext where sql_id=s.sql_id) sql,
sum(executions_delta) exec_cnt,
round(sum(elapsed_time_delta)/1000000,0) elapsed_time_sek,
round(sum(cpu_time_delta)/1000000,0) cpu_time_sek, 
round(sum(iowait_delta)/1000000,0) iowait_sek,
round(sum(clwait_delta)/1000000,0) cluster_wait_sek,
round(sum(apwait_delta)/1000000,0) app_wait_sek,
round(sum(ccwait_delta)/1000000,0) concurrency_wait_sek
from 
(select distinct snap_id from DBA_HIST_SNAPSHOT 
where begin_interval_time between to_date('20.05.2013 09','DD.MM.YYYY HH24') and to_date('20.04.2013 20','DD.MM.YYYY HH24') and rownum>0
) snaps,
DBA_HIST_SQLSTAT s
where s.snap_id=snaps.snap_id
group by sql_id
order by elapsed_time_sek desc
) q where rownum<=300;


select
  to_char(first_time,'DD.MM.YYYY') day,
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'00',1,0)),'999') "00",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'01',1,0)),'999') "01",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'02',1,0)),'999') "02",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'03',1,0)),'999') "03",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'04',1,0)),'999') "04",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'05',1,0)),'999') "05",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'06',1,0)),'999') "06",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'07',1,0)),'999') "07",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'08',1,0)),'999') "08",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'09',1,0)),'999') "09",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'10',1,0)),'999') "10",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'11',1,0)),'999') "11",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'12',1,0)),'999') "12",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'13',1,0)),'999') "13",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'14',1,0)),'999') "14",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'15',1,0)),'999') "15",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'16',1,0)),'999') "16",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'17',1,0)),'999') "17",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'18',1,0)),'999') "18",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'19',1,0)),'999') "19",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'20',1,0)),'999') "20",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'21',1,0)),'999') "21",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'22',1,0)),'999') "22",
  to_char(sum(decode(substr(to_char(first_time,'HH24'),1,2),'23',1,0)),'999') "23"
from
  gv$log_history
group by 
  to_char(first_time,'DD.MM.YYYY')
order by
  to_date(day, 'DD.MM.YYYY')


-- ������ ��������
-- ������� �������� snap_id - ���������� ������ �� ���
select * from DBA_HIST_SNAPSHOT 
order by begin_interval_time desc;

-- ����� �� snap_id ����������� ��������
select row_number() over (order by elapsed_time_sek desc) N,q.* from
(
select (select DBMS_LOB.SUBSTR(sql_text,100) from dba_hist_sqltext where sql_id=s.sql_id) sql,
sum(executions_delta) exec_cnt,
round(sum(elapsed_time_delta)/1000000,0) elapsed_time_sek,
round(sum(cpu_time_delta)/1000000,0) cpu_time_sek, 
round(sum(iowait_delta)/1000000,0) iowait_sek,
round(sum(clwait_delta)/1000000,0) cluster_wait_sek,
round(sum(apwait_delta)/1000000,0) app_wait_sek,
round(sum(ccwait_delta)/1000000,0) concurrency_wait_sek
from DBA_HIST_SQLSTAT s where snap_id=37704
group by sql_id
order by elapsed_time_sek desc
) q where rownum<=50;

--select DBMS_LOB.SUBSTR(sql_text,100) from dba_hist_sqltext where sql_id='7f82sn4nxbzdy'


-- ������ �������� SQL
select hash_value
,sum(disk_reads) disk_reads
,sum(buffer_gets) buffer_gets
,sum(rows_processed) rows_processed
,round(sum(buffer_gets)/greatest(sum(rows_processed), 1),2) buffer_gets_on_rows
, sum(executions) executions
,round(sum(buffer_gets)/greatest(sum(executions),1),2) buffer_gets_on_executions
,max(V1.SQL_TEXT) SQL_TEXT_max
,max(V1.SQL_ID) SQL_ID_max
from gv$sql v1
--where command_type in ( 2,3,6,7 )
group by hash_value
order by 5 desc;


-- ������ ������� �������� �� ���� �������
select event, time_waited/100 seconds, total_waits calls
from gv$system_event
order by 2 desc;



--������� ��������� � ����� ����� ������ (��� ������)
--���� ������� ���� 95, �� ����� ��������� ������ DB_CACHE_SIZE
--��� �������������� ������� ���������� ����� ���������� � �����.

select 1- (sum(decode(name, 'physical reads',value,0))/
(sum(decode(name, 'db block gets',value,0)) +
(sum(decode(name, 'consistent gets',value,0)))))
"Read Hit Ratio"
from gv$sysstat;


--�������, ��� ���������� ��� ���������� ���� �������� �� �������� ���������
--(������ �� ���������� ��� ���������� ���� ������)


select size_for_estimate, buffers_for_estimate,
estd_physical_read_factor, estd_physical_reads
from v$db_cache_advice
where name='DEFAULT'
and block_size=
(select value
from gv$parameter
where name='db_block_size' )
and advice_status='ON';


--������� ��������� � ��������� ���
--���� ������ 95, �� ����� ���������� ��� ����������� SHARED_POOL_SIZE


select sum(gets), sum(getmisses),
(1-(sum(getmisses)/(sum(gets)+ sum(getmisses))))* 100 HitRate
from gv$rowcache;


--������� ��������� ��� ���� ����������� SQL-��������
--� �������� �� ����� PL/SQL
--������� ��������� ��� ���������� PinHitRatio ������ ���� �� ����� 95
--������� ��������� ��� �������� RelHitRatio ������ ���� �� ����� 99


select sum(pins) "Executions",
sum(pinhits) "Hits",
((sum(pinhits)/sum(pins))* 100) "PinHitRatio",
sum(reloads) "Misses",
((sum(pins)/(sum(pins) + sum(reloads)))* 100) "RelHitRatio"
from gv$librarycache


--������� PL/SQL, ������� ������� ��������� � ������
--(�������, ��� �������� ������� ����� ������ 100 �����)

select name, sharable_mem
from gv$db_object_cache
where sharable_mem>100000
and type in ('PACKAGE','PACKAGE_BODY','FUNCTION','PROCEDURE')
and kept='NO';


--������, �������� ���������� ������������ ������������ �����
--
--������, �������� ���������� ������������ ������� ����������,
--����� ���������� ����������� ���������:
--
--- ��� ������ ������� top ������������ ������� UNIX.
--
--- � �������������� ������������ ���������� Oracle,
--�������� ��������� ������:

select v.sid, s.name "statistic", v.value
from gv$statname s, gv$sesstat v
where s.name = 'CPU used by this session'
and v.statistic# = s.statistic#
and v.value > 0
order by 3 desc;

--������� ���������, ��� � ������ ������� ���������� �� �������
--�������� ���������� ���� �� ����, � �������� �� ����� � ������
--������ �������. ������� ��� � ���, ��� ������, ��������������� �
--������� ����������� ������� �������, ��� �������������� ��������,
--����� � ����� ������������ ������� ���������� ������������� �������.

--��������� ������ SQL-�����������

select name, value from v$sysstat
where name in (
'parse time cpu',
'parse time elapsed',
'parse count (hard)'
);

--SQL-�����������, �������������� �������� ������ ��������

select sql_text, parse_calls, executions
from gv$sqlarea
order by parse_calls desc;

--� ���, ��� ������� �� ����������� ����� ��������, ���������������
--������� � ��������� �������� �������� ���� VERSION_COUNT:

select sql_text, version_count
from gv$sqlarea order by version_count desc;

--SQL-�����������, �������� ���������� ����������� ��������� � ������
--������:

select address, hash_value, buffer_gets, executions,
round(buffer_gets/executions,2) "gets/exec", sql_text
from gv$sqlarea
where executions > 0
order by 3 desc;

--(������� �������� �������� �� SQL-����������� � �������
--���������� gets/exec ��� ��������� buffer_gets)

--����������� ������������� ������

--������� ����� ������� ������� ���������� �������� �� ������������
--�������������� ������������� ����������. �������� ����� ��� ����������
--� ��������� ���������:

--- � ������� �������� ���������� ������ � ��������� ��������� ����������,
--����������� ���������� ������ � ������������ � ����� � ��� �� ���-����.
--��� ���� ������� ��������� ���������� ������� ���������� ������-��� ���
--����������� ��������������� ������.

--- ���� ���� ����� ��������� ������, �� ������� ����� ������� ����� �������
--�� ����� ������� ����������. ���� ������ �������� � ������� �����������
--�������, �� ��������� ����� ��������� ������ � ������ ���������� �������
--����, ���� ������� ��������� ����� �������� ������������ ����� ����������.

--- ������� ��������� ������� ����� ������� ��� ���� ����� ����� ���������.
--���������� ��������� ������������� ���������� ������� �� ���� ���������
--DBWRn. ����� ����� ����� ��������� ������ ���� ������� ��� ����������
--�������� ��� DBWR. ��� ���������� �������� ���������� �������, �������
--���������� ����������� � ������ LRU (Least Reasently Used) ��� ����������
--���������� ������, ���������� ������������ ���-������ ������:

select 1+sum(decode(name, 'free buffer inspected', value, 0)) /
sum(decode(name, 'free buffer requested', value, 0))
from gv$sysstat
where name in (
'free buffer inspected',
'free buffer requested'
);

--��������� ������ ���� ����� � ������� 1-�� ��� 2-� ������.
--���� ���������� ������ ������, �� ���������� ��������� ��� �������
--��� ��������� �������� DBWRn.
--���������� ������� ���������, ���� ������ ������� ���������� "�������"
--������� � ����� ������ LRU:

--select * from v$buffer_pool_statistics;


--�������� ����������

--��� ����������� �������� ������ ������ �������� ���������� ���������
--��������� ������:

select * from gv$system_event
where event != 'Null event' and
event != 'rdbms ipc message' and
event != 'pipe get' and
event != 'virtual circuit status' and
event not like '%timer%' and
event not like 'SQL*Net % from %'
order by time_waited desc;

--�������� �������� ������� �� ������� � ����������� ��������� ��������.

--�������� ����� ������������� ������� ��������:

--- Buffer busy wait - ������ ������� ������ ���������, ���� ���������
--������ �������� ��������� ���� � ��� �� ����, ��� ���� ��� ���������
--������ ������� ��������� ��������� ������ �����. ����������� �� ����
--�������������� � ����������� �� ���� �����:

--���� ������:

--- ��������� ���������� ����� � ����� ����� ��������� ����������
--pctfree/pctused ��� ����������� BD_BLOCK_SIZE.

--- ��������� �� ������� right.hand.indexes (��������, � ������� �����������
--������ ������� ���������� � ���� �����). ��������, ������� ������������
--������� � ��������� �������.

--��������� ��������:
--- ��������� ���������� freelists.
--- ��������� ������ ��������� ��� �������.

--��������� �������� ������:
--- �������� ������ ��������� ������ ��� ���������� ���������� ����������
--�� �������.
--- ��������� �������� ��������� TRANSACTION_PER_ROLLBACK_SEGMENT.

--���� �������� ������:
--- ��������� ������� ������.
--- Free buffer wait - ������ ���������, ���� ������� DBWR �� �����������
--� ������� ������ �� ����. ���������� ��������� ��� ���������� �����������.
--- Latch free - ����������� �� ������ � ��������. ��� ������ ����������
--������� ����� ���������� �������, ������� ������� �������� ������ �
--������ ������ �������:

select * from gv$latch
where latch# in (
select p2 from v$session_wait
where event = 'latch free' );

--����������� �� ������ � ��������

--����� �� ������ ������� ��������� ����� ���� ����������� �� ������
--� ��������. ������� - ��� ���������� ��������� ������ Oracle,
--�������������� ������ � ��������, ����������� � SGA (System Global Area).

--� ������������� ����������� �� ������ � �������� ������������� ���������
--������ � ��������� ������� "latch free" � ������������ �������������
--V$SESSION_WAIT � �������������� ���� ���������� �������� "latch free"
--� V$SESSION_EVENT.

-- ���������� �� ��������� ������� � �������:

select * from gv$system_event where event = 'latch free';

-- ������� �������� �������:

select * from gv$session_wait where event = 'latch free';


--- �������, ������ � ������� ������� �������� � ������� ������ �������:

select * from gv$latch
where latch# in (
select p2 from v$session_wait where event = 'latch free' );

--������� ������������� ����������� �� ������ � �������� � ������� �������
--������ response_time_breakdown.sql.

--�������� ����� ������������� ������� ��������:

--- �ache buffers chains - ������ ������� ������������� ��� ������ �����
--������, ������������� � SGA. ��������� �������� ��� ������������ �����
--������������������ ������, ������ ������������������ ���������� ��������,
--������� �������� �������� ��� ������ �������. ����������� �� ������ �
--������ ������� ���������� ����� �������� �������� � ������ �����, � ������
--������� ��� ����������� ������������� ����������. ���������� ����� ������
--� ���� �������, ��� ��������� � ������� ��������� ��������, �������
--��������� ������:

--select a.name, b.obj,
--b.dbarfil file#, b.dbablk block#,
--a.gets, a.sleeps
--from v$latch_children a, x$bh b
--where a.addr = b.hladdr and sleeps > 100
--order by 5 desc;

--select /*+ ordered first_rows*/
--l.child#,
--e.owner||'.'||e.segment_name segment,
--e.segment_type type,
--x.dbarfil file#,
--x.dbablk block#,
--trunc(l.sleeps/l.gets,5) rate
--from
--( select
--(max(sleeps/gets)+avg(sleeps/gets))/2 rate,
--sum(sleeps) sleeps
--from
--sys.v_$latch_children
--where
--name = 'cache buffers chains'
--) a,
--sys.x$bh x,
--sys.v_$latch_children l,
--sys.dba_extents e
--where
--x.inst_id = userenv('Instance') and
--l.sleeps/l.gets > a.rate and
--l.addr = x.hladdr and
--x.dbarfil = e.file_id and
--x.dbablk between e.block_id and e.block_id+e.blocks
--order by rate desc;

--C����������� ���������� ���������� �������� ������� ������� ����
--����� ������������ �������� ��������� ���� ������

_db_block_hash_buckets = 2*db_block_buffers;


--��������������� �������� ������

--����������� ����� (shared pool)

-- - ����������� ��������� � ������������ ���, ������ ���� ������ � 1:

select (sum(pins - reloads)) / sum(pins) "lib cache"
from gv$librarycache;

-- - ����������� ��������� � ��������� ��� (���������� ������������ ������),
-- ����������� ������ ���� ������ � 1:

select (sum(gets - getmisses - usage - fixed)) / sum(gets) "row cache"
from v$rowcache;

-- - ��������� ����� � ����������� ����:

select * from v$sgastat where name = 'free memory';

-- - ����������� �� ��������� � ������������ ���:

select sum(pins) "executions",
sum(reloads) "cache misses while executing",
sum(reloads)/sum(pins) "miss rate"
from gv$librarycache;


--��� ������� (buffer cache)

-- - ����������� ��������� � ����� ������ ���� ������ 0.9:

select name, 1-physical_reads/(db_block_gets+consistent_gets) "Hits"
from gv$buffer_pool_statistics;

-- - ����������� �������� LRU ������� ��� ��������� � ���� �������:

select bp.name, max(sleeps / gets) ratio
from gv$buffer_pool bp, gv$latch_children lc
where lc.name = 'cache buffers lru chain'
and lc.child# between bp.lo_setid and bp.hi_setid
group by bp.name;

--��� �������� ����������� (redo log buffer)
--���������� �������� ��� ��������� � ���� �������� �����������:

select name, value
from gv$sysstat
where name = 'redo buffer allocation retries';

--������� ���������� (sort areas)
--���������� ���������� �� ����� � � ������:
select name, value
from gv$sysstat
where name in ('sorts (memory)', 'sorts (disk)');

--����������� �� ������ � ��������

--����������� �� �������� ������

--���������� �������� ������� � ��������� ������ �� ������ ��������� 1%.
--���� ����������� �������� ����, �� ���������� ��������� ����������
--��������� ������:

select w.class, w.count/s.value "Rate"
from gv$waitstat w,
( select sum(value) value from v$sysstat
where name in ('db block gets', 'consistent gets')) s
where w.class in (
'system undo header',
'system undo block',
'undo header',
'undo block'); 


