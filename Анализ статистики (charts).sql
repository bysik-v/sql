-- ������ ���������� �� ����������
select /*+ ordered use_nl(s1 c)*/c.name, substr(time1,10),id_object,
avg_by_hour, 
min_by_hour, max_by_hour
from 
(select id_object,to_char(date_time,'YYYYMMDD HH24') as time1,
round(sum(round(average,0))/count(*),1) as avg_by_hour,
min(round(minimum,0)) as min_by_hour,
max(round(maximum,0)) as max_by_hour
 from charts cs
where date_time between '31/07/2012' and '01/08/2012'
and minimum<1000000 and maximum<1000000 and average<1000000
group by id_object, to_char(date_time,'YYYYMMDD HH24')
) s1, consts c
where s1.id_object=c.id
order by c.name,time1;


-- ������ ���������� �� ���������� �� �����
select time1,
sum(���������_������_avg) as ���������_������_avg,
sum(���������_������_min) as ���������_������_min,
sum(���������_������_max) as ���������_������_max,
sum(���_����_�_���_avg) as ���_����_�_���_avg,
sum(���_����_�_���_min) as ���_����_�_���_min,
sum(���_����_�_���_max) as ���_����_�_���_max,
sum(���_�����_avg) as ���_�����_avg,
sum(���_�����_min) as ���_�����_min,
sum(���_�����_max) as ���_�����_max,
sum(����������_avg) as ����������_avg,
sum(����������_min) as ����������_min,
sum(����������_max) as ����������_max,
sum(����������_������_avg) as ����������_������_avg,
sum(����������_������_min) as ����������_������_min,
sum(����������_������_max) as ����������_������_max
from
(select /*+ ordered use_nl(s1 c)*/
--c.name, 
time1,--id_object,
DECODE(c.name,'��������� ������',avg_by_hour,0) as ���������_������_avg, 
DECODE(c.name,'��������� ������',min_by_hour,0) as ���������_������_min,
DECODE(c.name,'��������� ������',max_by_hour,0) as ���������_������_max,
DECODE(c.name,'���������� ��������',avg_by_hour,0) as ���_����_�_���_avg, 
DECODE(c.name,'���������� ��������',min_by_hour,0) as ���_����_�_���_min,
DECODE(c.name,'���������� ��������',max_by_hour,0) as ���_����_�_���_max,
DECODE(c.name,'���������� �������������',avg_by_hour,0) as ���_�����_avg, 
DECODE(c.name,'���������� �������������',min_by_hour,0) as ���_�����_min,
DECODE(c.name,'���������� �������������',max_by_hour,0) as ���_�����_max,
DECODE(c.name,'����������',avg_by_hour,0) as ����������_avg, 
DECODE(c.name,'����������',min_by_hour,0) as ����������_min,
DECODE(c.name,'����������',max_by_hour,0) as ����������_max,
DECODE(c.name,'���������� ������',avg_by_hour,0) as ����������_������_avg, 
DECODE(c.name,'���������� ������',min_by_hour,0) as ����������_������_min,
DECODE(c.name,'���������� ������',max_by_hour,0) as ����������_������_max
--min_by_hour, max_by_hour
from 
(select id_object,to_char(date_time,'YYYYMMDD HH24') as time1,
round(sum(round(average,0))/count(*),1) as avg_by_hour,
min(round(minimum,0)) as min_by_hour,
max(round(maximum,0)) as max_by_hour
 from charts cs
where date_time between '01/04/2013' and '15/04/2013'
and minimum<1000000 and maximum<1000000 and average<1000000
group by id_object, to_char(date_time,'YYYYMMDD HH24')
) s1, consts c
where s1.id_object=c.id) group by time1
order by time1;

-- ������ ���������� �� ���������� �� 5 �������
select time1,
sum(���������_������_avg) as ���������_������_avg,
--sum(���������_������_min) as ���������_������_min,
--sum(���������_������_max) as ���������_������_max,
sum(���_����_�_���_avg) as ���_����_�_���_avg,
--sum(���_����_�_���_min) as ���_����_�_���_min,
--sum(���_����_�_���_max) as ���_����_�_���_max,
sum(���_�����_avg) as ���_�����_avg,
--sum(���_�����_min) as ���_�����_min,
--sum(���_�����_max) as ���_�����_max,
sum(����������_avg) as ����������_avg,
--sum(����������_min) as ����������_min,
--sum(����������_max) as ����������_max,
sum(�������_avg) as �������_avg,
--sum(�������_min) as �������_min,
--sum(�������_max) as �������_max,
sum(����������_������_avg) as ����������_������_avg,
--sum(����������_������_min) as ����������_������_min,
--sum(����������_������_max) as ����������_������_max,
sum(�������_������_avg) as �������_������_avg
--sum(�������_������_min) as �������_������_min,
--sum(�������_������_max) as �������_������_max
from
(select /*+ ordered use_nl(s1 c)*/
--c.name, 
time1,--id_object,
DECODE(c.name,'��������� ������',avg_by_hour,0) as ���������_������_avg, 
DECODE(c.name,'��������� ������',min_by_hour,0) as ���������_������_min,
DECODE(c.name,'��������� ������',max_by_hour,0) as ���������_������_max,
DECODE(c.name,'���������� ��������',avg_by_hour,0) as ���_����_�_���_avg, 
DECODE(c.name,'���������� ��������',min_by_hour,0) as ���_����_�_���_min,
DECODE(c.name,'���������� ��������',max_by_hour,0) as ���_����_�_���_max,
DECODE(c.name,'���������� �������������',avg_by_hour,0) as ���_�����_avg, 
DECODE(c.name,'���������� �������������',min_by_hour,0) as ���_�����_min,
DECODE(c.name,'���������� �������������',max_by_hour,0) as ���_�����_max,
DECODE(c.name,'����������',avg_by_hour,0) as ����������_avg, 
DECODE(c.name,'����������',min_by_hour,0) as ����������_min,
DECODE(c.name,'����������',max_by_hour,0) as ����������_max,
DECODE(c.name,'�������',avg_by_hour,0) as �������_avg, 
DECODE(c.name,'�������',min_by_hour,0) as �������_min,
DECODE(c.name,'�������',max_by_hour,0) as �������_max,
DECODE(c.name,'���������� ������',avg_by_hour,0) as ����������_������_avg, 
DECODE(c.name,'���������� ������',min_by_hour,0) as ����������_������_min,
DECODE(c.name,'���������� ������',max_by_hour,0) as ����������_������_max,
DECODE(c.name,'������� ������',avg_by_hour,0) as �������_������_avg, 
DECODE(c.name,'������� ������',min_by_hour,0) as �������_������_min,
DECODE(c.name,'������� ������',max_by_hour,0) as �������_������_max
--min_by_hour, max_by_hour
from 
(select id_object,to_char(TRUNC(date_time, 'MI') - MOD(TO_CHAR(date_time, 'MI'), 5) / (24 * 60),'YYYYMMDD HH24 Mi') as time1,
round(sum(round(average,0))/count(*),1) as avg_by_hour,
min(round(minimum,0)) as min_by_hour,
max(round(maximum,0)) as max_by_hour
 from charts cs
where date_time between '01/04/2013' and '02/04/2013'
--and to_char(date_time,'HH24') between '06' and '21'
and minimum<1000000 and maximum<1000000 and average<1000000
group by id_object,TRUNC(date_time, 'MI') - MOD(TO_CHAR(date_time, 'MI'), 5) / (24 * 60)-- to_char(date_time,'YYYYMMDD HH24 Mi')
) s1, consts c
where s1.id_object=c.id) group by time1
order by time1;