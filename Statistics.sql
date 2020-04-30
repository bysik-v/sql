-- Запрос надо выполнять на схеме ETL

select row_number() over (order by elapsed_time_sek desc) N,q.* from
(select /*+ no_merge(snaps)*/
 (select DBMS_LOB.SUBSTR(sql_text,3999) from dba_hist_sqltext where sql_id=s.sql_id) sql,
sum(executions_delta) exec_cnt,
round(sum(elapsed_time_delta)/1000000,0) elapsed_time_sek,
round(sum(cpu_time_delta)/1000000,0) cpu_time_sek, 
round(sum(iowait_delta)/1000000,0) iowait_sek,
round(sum(clwait_delta)/1000000,0) cluster_wait_sek,
round(sum(apwait_delta)/1000000,0) app_wait_sek,
round(sum(ccwait_delta)/1000000,0) concurrency_wait_sek,
sql_id
from 
(select distinct snap_id from DBA_HIST_SNAPSHOT 
where begin_interval_time between to_date('29.12.2017 10','DD.MM.YYYY HH24') and to_date('29.12.2017 15','DD.MM.YYYY HH24') and rownum>0
) snaps,
DBA_HIST_SQLSTAT s
where s.snap_id=snaps.snap_id
group by sql_id
order by elapsed_time_sek desc
) q where rownum<=1000
