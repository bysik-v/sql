-- Анализ размера и состояния redo log файлов
select * from gv$log;

-- Анализ ожиданий сессий
SELECT * FROM gv$session_wait
order by seconds_in_wait desc ;

-- Ожидания запросов _WAIT_TIME
select * from gv$sqlarea;

-- Названия событий ожидания
--select * from v$event_name;

-- Анализируем ожидания сессий с блокировкой
select * from gv$session where blocking_session is not null
order by blocking_session;

-- Анализируем ожидания сессий 1
select username, schemaname, inst_id, program,state,event, count(*) as cnt1
from gv$session
group by username, schemaname, inst_id, program,state,event
order by cnt1 desc;

-- Анализ событий ожидания по всей системе
select event, time_waited/100 seconds, total_waits calls
from gv$system_event
order by 2 desc;

-- Ожидания по истории сессий
SELECT   DECODE (session_state, 'WAITING', event, NULL) event,
   session_state, COUNT(*), SUM (time_waited) time_waited
   FROM   gv$active_session_history
   WHERE --   module = 'ARXENV' AND  
   sample_time > SYSDATE - (2/24)
  GROUP BY DECODE (session_state, 'WAITING', event, NULL), session_state
  order by 4 desc;


-- Анализируем ожидания
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


-- Анализ ожиданий
-- Сначала получаем snap_id - статистика работы за час
select * from DBA_HIST_SNAPSHOT 
order by begin_interval_time desc;

-- Затем по snap_id анализируем ожидания
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


-- Анализ запросов SQL
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


-- Анализ событий ожидания по всей системе
select event, time_waited/100 seconds, total_waits calls
from gv$system_event
order by 2 desc;



--Процент попаданий в буфер блока данных (кэш данных)
--если процент ниже 95, то стоит увеличить размер DB_CACHE_SIZE
--или оптимизировать запросы вызывающие много считываний с диска.

select 1- (sum(decode(name, 'physical reads',value,0))/
(sum(decode(name, 'db block gets',value,0)) +
(sum(decode(name, 'consistent gets',value,0)))))
"Read Hit Ratio"
from gv$sysstat;


--Покажет, как увеличение или уменьшение кэша скажется на процессе попаданий
--(эффект от увеличения или уменьшения кэша данных)


select size_for_estimate, buffers_for_estimate,
estd_physical_read_factor, estd_physical_reads
from v$db_cache_advice
where name='DEFAULT'
and block_size=
(select value
from gv$parameter
where name='db_block_size' )
and advice_status='ON';


--Процент попадания в словарный кэш
--Если меньше 95, то стоит задуматься над увеличением SHARED_POOL_SIZE


select sum(gets), sum(getmisses),
(1-(sum(getmisses)/(sum(gets)+ sum(getmisses))))* 100 HitRate
from gv$rowcache;


--Процент попаданий для кэша разделяемых SQL-запросов
--и процедур на языке PL/SQL
--процент попаданий при выполнении PinHitRatio должен быть не менее 95
--процент попаданий при загрузке RelHitRatio должен быть не менее 99


select sum(pins) "Executions",
sum(pinhits) "Hits",
((sum(pinhits)/sum(pins))* 100) "PinHitRatio",
sum(reloads) "Misses",
((sum(pins)/(sum(pins) + sum(reloads)))* 100) "RelHitRatio"
from gv$librarycache


--Объекты PL/SQL, которые следует закрепить в памяти
--(объекты, для хранения которых нужно больше 100 Кбайт)

select name, sharable_mem
from gv$db_object_cache
where sharable_mem>100000
and type in ('PACKAGE','PACKAGE_BODY','FUNCTION','PROCEDURE')
and kept='NO';


--Сессии, наиболее интенсивно использующие процессорное время
--
--Сессии, наиболее интенсивно использующие ресурсы процессора,
--можно определить несколькими способами:
--
--- При помощи команды top операционной системы UNIX.
--
--- С использованием динамической статистики Oracle,
--выполнив следующий запрос:

select v.sid, s.name "statistic", v.value
from gv$statname s, gv$sesstat v
where s.name = 'CPU used by this session'
and v.statistic# = s.statistic#
and v.value > 0
order by 3 desc;

--Следует учитывать, что в данном запросе интересует не большое
--значение статистики само по себе, а скорость ее роста в данный
--момент времени. Связано это с тем, что сессия, функционирующая в
--течение длительного периода времени, при незначительном приросте,
--могла в сумме использовать большое количество процессорного времени.

--Повторный разбор SQL-предложений

select name, value from v$sysstat
where name in (
'parse time cpu',
'parse time elapsed',
'parse count (hard)'
);

--SQL-предложения, подвергающиеся наиболее частым разборам

select sql_text, parse_calls, executions
from gv$sqlarea
order by parse_calls desc;

--О том, что курсоры не разделяются между сессиями, свидетельствуют
--большие и постоянно растущие значения поля VERSION_COUNT:

select sql_text, version_count
from gv$sqlarea order by version_count desc;

--SQL-предложения, наиболее интенсивно выполняющие обращения к блокам
--данных:

select address, hash_value, buffer_gets, executions,
round(buffer_gets/executions,2) "gets/exec", sql_text
from gv$sqlarea
where executions > 0
order by 3 desc;

--(следует обращать внимание на SQL-предложения с большим
--отношением gets/exec или значением buffer_gets)

--Интенсивные согласованные чтения

--Система может тратить большое количество ресурсов на формирование
--согласованного представления информации. Наиболее часто это происходит
--в следующих ситуациях:

--- В системе работают длительный запрос и множество маленьких транзакций,
--выполняющих добавление данных и обращающихся к одной и той же таб-лице.
--При этом запросу требуется откатывать большое количество измене-ний для
--обеспечения согласованности чтения.

--- Если мало число сегментов отката, то система может тратить много времени
--на откат таблицы транзакций. Если запрос работает в течение длительного
--времени, то поскольку число сегментов отката и таблиц транзакций слишком
--мало, ваша система вынуждена часто повторно использовать слоты транзакций.

--- Система сканирует слишком много буферов для того чтобы найти свободный.
--Необходимо увеличить интенсивность скидывания буферов на диск процессом
--DBWRn. Кроме этого можно увеличить размер кэша буферов для уменьшения
--нагрузки для DBWR. Для нахождения среднего количества буферов, которое
--необходимо просмотреть в списке LRU (Least Reasently Used) для нахождения
--свободного буфера, необходимо использовать сле-дующий запрос:

select 1+sum(decode(name, 'free buffer inspected', value, 0)) /
sum(decode(name, 'free buffer requested', value, 0))
from gv$sysstat
where name in (
'free buffer inspected',
'free buffer requested'
);

--Результат должен быть равен в среднем 1-му или 2-м блокам.
--Если количество блоков больше, то необходимо увеличить кэш буферов
--или настроить процессы DBWRn.
--Аналогично следует поступать, если велико среднее количество "грязных"
--буферов в конце списка LRU:

--select * from v$buffer_pool_statistics;


--Ожидания выполнения

--Для определения наиболее частых причин ожидания необходимо выполнить
--следующий запрос:

select * from gv$system_event
where event != 'Null event' and
event != 'rdbms ipc message' and
event != 'pipe get' and
event != 'virtual circuit status' and
event not like '%timer%' and
event not like 'SQL*Net % from %'
order by time_waited desc;

--Обращать внимание следует на события с наибольшими временами ожидания.

--Наиболее часто встречающиеся причины ожиданий:

--- Buffer busy wait - данное событие обычно возникает, если несколько
--сессий пытаются прочитать один и тот же блок, или одна или несколько
--сессий ожидают окончания изменения одного блока. Конкуренция за блок
--корректируется в зависимости от типа блока:

--Блок данных:

--- Уменьшите количество строк в блоке путем изменения параметров
--pctfree/pctused или уменьшением BD_BLOCK_SIZE.

--- Проверьте на наличие right.hand.indexes (индексов, в которые добавляются
--данные многими процессами в одну точку). Возможно, следует использовать
--индексы с обратными ключами.

--Заголовок сегмента:
--- Увеличьте количество freelists.
--- Увеличьте размер экстентов для таблицы.

--Заголовок сегмента отката:
--- Добавьте больше сегментов отката для уменьшения количества транзакций
--на сегмент.
--- Уменьшите значение параметра TRANSACTION_PER_ROLLBACK_SEGMENT.

--Блок сегмента отката:
--- Увеличьте сегмент отката.
--- Free buffer wait - обычно возникает, если процесс DBWR не справляется
--с записью блоков на диск. Необходимо увеличить его пропускную способность.
--- Latch free - конкуренция за доступ к защелкам. При помощи следующего
--запроса можно определить защелки, которые ожидают активные сессии в
--данный момент времени:

select * from gv$latch
where latch# in (
select p2 from v$session_wait
where event = 'latch free' );

--Конкуренция за доступ к защелкам

--Одной из причин простоя процессов может быть конкуренция за доступ
--к защелкам. Защелка - это внутренняя структура данных Oracle,
--контролирующая доступ к объектам, находящимся в SGA (System Global Area).

--О возникновении конкуренции за доступ к защелкам сигнализирует появление
--сессий с ожиданием события "latch free" в динамическом представлении
--V$SESSION_WAIT и соответственно рост статистики ожидания "latch free"
--в V$SESSION_EVENT.

-- Статистика по ожиданиям защелок в системе:

select * from gv$system_event where event = 'latch free';

-- Текущие ожидания защелок:

select * from gv$session_wait where event = 'latch free';


--- Защелки, доступ к которым ожидают процессы в текущий момент времени:

select * from gv$latch
where latch# in (
select p2 from v$session_wait where event = 'latch free' );

--Выявить возникновение конкуренции за доступ к защелкам в системе поможет
--скрипт response_time_breakdown.sql.

--Наиболее часто встречающиеся причины ожиданий:

--- Сache buffers chains - данная защелка запрашивается при поиске блока
--данных, кэшированного в SGA. Поскольку буферный кэш представляет собой
--последовательность блоков, каждая последовательность защищается защелкой,
--которая является дочерней для данной защелки. Конкуренция за доступ к
--данной защелке вызывается очень активным доступом к одному блоку, и обычно
--требует для исправления переписывания приложения. Определить блоки данных
--в кэше буферов, при обращении к которым возникают задержки, поможет
--следующий запрос:

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

--Cущественное уменьшение количества ожиданий защелки данного типа
--можно выставлением скрытого параметра базы данных

_db_block_hash_buckets = 2*db_block_buffers;


--Недостаточность ресурсов памяти

--Разделяемый буфер (shared pool)

-- - Коэффициент попадания в библиотечный кэш, должен быть близок к 1:

select (sum(pins - reloads)) / sum(pins) "lib cache"
from gv$librarycache;

-- - Коэффициент попадания в словарный кэш (содержащий библиотечные данные),
-- коэффициент должен быть близок к 1:

select (sum(gets - getmisses - usage - fixed)) / sum(gets) "row cache"
from v$rowcache;

-- - Свободное место в разделяемом кэше:

select * from v$sgastat where name = 'free memory';

-- - Коэффициент не попадания в библиотечный кэш:

select sum(pins) "executions",
sum(reloads) "cache misses while executing",
sum(reloads)/sum(pins) "miss rate"
from gv$librarycache;


--Кэш буферов (buffer cache)

-- - Коэффициент попаданий в буфер должен быть больше 0.9:

select name, 1-physical_reads/(db_block_gets+consistent_gets) "Hits"
from gv$buffer_pool_statistics;

-- - Коэффициент ожидания LRU защелок при обращении к кэшу буферов:

select bp.name, max(sleeps / gets) ratio
from gv$buffer_pool bp, gv$latch_children lc
where lc.name = 'cache buffers lru chain'
and lc.child# between bp.lo_setid and bp.hi_setid
group by bp.name;

--Кэш журналов регистраций (redo log buffer)
--Количество промахов при обращении к кэшу журналов регистрации:

select name, value
from gv$sysstat
where name = 'redo buffer allocation retries';

--Области сортировки (sort areas)
--Количество сортировок на диске и в памяти:
select name, value
from gv$sysstat
where name in ('sorts (memory)', 'sorts (disk)');

--Конкуренция за доступ к ресурсам

--Конкуренция за сегменты отката

--Количество ожиданий доступа к сегментам отката не должно превышать 1%.
--Если коэффициент ожиданий выше, то необходимо увеличить количество
--сегментов отката:

select w.class, w.count/s.value "Rate"
from gv$waitstat w,
( select sum(value) value from v$sysstat
where name in ('db block gets', 'consistent gets')) s
where w.class in (
'system undo header',
'system undo block',
'undo header',
'undo block'); 


