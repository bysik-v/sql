-- юМЮКХГ ХМТНПЛЮЖХХ ОН ЯРЮРХЯРХЙЕ
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


-- юМЮКХГ ХМТНПЛЮЖХХ ОН ЯРЮРХЯРХЙЕ ОН ВЮЯЮЛ
select time1,
sum(бшдекемхе_оюлърх_avg) as бшдекемхе_оюлърх_avg,
sum(бшдекемхе_оюлърх_min) as бшдекемхе_оюлърх_min,
sum(бшдекемхе_оюлърх_max) as бшдекемхе_оюлърх_max,
sum(йнк_опнб_б_яей_avg) as йнк_опнб_б_яей_avg,
sum(йнк_опнб_б_яей_min) as йнк_опнб_б_яей_min,
sum(йнк_опнб_б_яей_max) as йнк_опнб_б_яей_max,
sum(йнк_онкэг_avg) as йнк_онкэг_avg,
sum(йнк_онкэг_min) as йнк_онкэг_min,
sum(йнк_онкэг_max) as йнк_онкэг_max,
sum(янедхмемхъ_avg) as янедхмемхъ_avg,
sum(янедхмемхъ_min) as янедхмемхъ_min,
sum(янедхмемхъ_max) as янедхмемхъ_max,
sum(янедхмемхъ_нрверш_avg) as янедхмемхъ_нрверш_avg,
sum(янедхмемхъ_нрверш_min) as янедхмемхъ_нрверш_min,
sum(янедхмемхъ_нрверш_max) as янедхмемхъ_нрверш_max
from
(select /*+ ordered use_nl(s1 c)*/
--c.name, 
time1,--id_object,
DECODE(c.name,'бшдекемхе оюлърх',avg_by_hour,0) as бшдекемхе_оюлърх_avg, 
DECODE(c.name,'бшдекемхе оюлърх',min_by_hour,0) as бшдекемхе_оюлърх_min,
DECODE(c.name,'бшдекемхе оюлърх',max_by_hour,0) as бшдекемхе_оюлърх_max,
DECODE(c.name,'йнкхвеярбн опнбнднй',avg_by_hour,0) as йнк_опнб_б_яей_avg, 
DECODE(c.name,'йнкхвеярбн опнбнднй',min_by_hour,0) as йнк_опнб_б_яей_min,
DECODE(c.name,'йнкхвеярбн опнбнднй',max_by_hour,0) as йнк_опнб_б_яей_max,
DECODE(c.name,'йнкхвеярбн онкэгнбюрекеи',avg_by_hour,0) as йнк_онкэг_avg, 
DECODE(c.name,'йнкхвеярбн онкэгнбюрекеи',min_by_hour,0) as йнк_онкэг_min,
DECODE(c.name,'йнкхвеярбн онкэгнбюрекеи',max_by_hour,0) as йнк_онкэг_max,
DECODE(c.name,'янедхмемхъ',avg_by_hour,0) as янедхмемхъ_avg, 
DECODE(c.name,'янедхмемхъ',min_by_hour,0) as янедхмемхъ_min,
DECODE(c.name,'янедхмемхъ',max_by_hour,0) as янедхмемхъ_max,
DECODE(c.name,'янедхмемхъ нрверш',avg_by_hour,0) as янедхмемхъ_нрверш_avg, 
DECODE(c.name,'янедхмемхъ нрверш',min_by_hour,0) as янедхмемхъ_нрверш_min,
DECODE(c.name,'янедхмемхъ нрверш',max_by_hour,0) as янедхмемхъ_нрверш_max
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

-- юМЮКХГ ХМТНПЛЮЖХХ ОН ЯРЮРХЯРХЙЕ ОН 5 ЛХМСРЮЛ
select time1,
sum(бшдекемхе_оюлърх_avg) as бшдекемхе_оюлърх_avg,
--sum(бшдекемхе_оюлърх_min) as бшдекемхе_оюлърх_min,
--sum(бшдекемхе_оюлърх_max) as бшдекемхе_оюлърх_max,
sum(йнк_опнб_б_яей_avg) as йнк_опнб_б_яей_avg,
--sum(йнк_опнб_б_яей_min) as йнк_опнб_б_яей_min,
--sum(йнк_опнб_б_яей_max) as йнк_опнб_б_яей_max,
sum(йнк_онкэг_avg) as йнк_онкэг_avg,
--sum(йнк_онкэг_min) as йнк_онкэг_min,
--sum(йнк_онкэг_max) as йнк_онкэг_max,
sum(янедхмемхъ_avg) as янедхмемхъ_avg,
--sum(янедхмемхъ_min) as янедхмемхъ_min,
--sum(янедхмемхъ_max) as янедхмемхъ_max,
sum(нвепедэ_avg) as нвепедэ_avg,
--sum(нвепедэ_min) as нвепедэ_min,
--sum(нвепедэ_max) as нвепедэ_max,
sum(янедхмемхъ_нрверш_avg) as янедхмемхъ_нрверш_avg,
--sum(янедхмемхъ_нрверш_min) as янедхмемхъ_нрверш_min,
--sum(янедхмемхъ_нрверш_max) as янедхмемхъ_нрверш_max,
sum(нвепедэ_нрверш_avg) as нвепедэ_нрверш_avg
--sum(нвепедэ_нрверш_min) as нвепедэ_нрверш_min,
--sum(нвепедэ_нрверш_max) as нвепедэ_нрверш_max
from
(select /*+ ordered use_nl(s1 c)*/
--c.name, 
time1,--id_object,
DECODE(c.name,'бшдекемхе оюлърх',avg_by_hour,0) as бшдекемхе_оюлърх_avg, 
DECODE(c.name,'бшдекемхе оюлърх',min_by_hour,0) as бшдекемхе_оюлърх_min,
DECODE(c.name,'бшдекемхе оюлърх',max_by_hour,0) as бшдекемхе_оюлърх_max,
DECODE(c.name,'йнкхвеярбн опнбнднй',avg_by_hour,0) as йнк_опнб_б_яей_avg, 
DECODE(c.name,'йнкхвеярбн опнбнднй',min_by_hour,0) as йнк_опнб_б_яей_min,
DECODE(c.name,'йнкхвеярбн опнбнднй',max_by_hour,0) as йнк_опнб_б_яей_max,
DECODE(c.name,'йнкхвеярбн онкэгнбюрекеи',avg_by_hour,0) as йнк_онкэг_avg, 
DECODE(c.name,'йнкхвеярбн онкэгнбюрекеи',min_by_hour,0) as йнк_онкэг_min,
DECODE(c.name,'йнкхвеярбн онкэгнбюрекеи',max_by_hour,0) as йнк_онкэг_max,
DECODE(c.name,'янедхмемхъ',avg_by_hour,0) as янедхмемхъ_avg, 
DECODE(c.name,'янедхмемхъ',min_by_hour,0) as янедхмемхъ_min,
DECODE(c.name,'янедхмемхъ',max_by_hour,0) as янедхмемхъ_max,
DECODE(c.name,'нвепедэ',avg_by_hour,0) as нвепедэ_avg, 
DECODE(c.name,'нвепедэ',min_by_hour,0) as нвепедэ_min,
DECODE(c.name,'нвепедэ',max_by_hour,0) as нвепедэ_max,
DECODE(c.name,'янедхмемхъ нрверш',avg_by_hour,0) as янедхмемхъ_нрверш_avg, 
DECODE(c.name,'янедхмемхъ нрверш',min_by_hour,0) as янедхмемхъ_нрверш_min,
DECODE(c.name,'янедхмемхъ нрверш',max_by_hour,0) as янедхмемхъ_нрверш_max,
DECODE(c.name,'нвепедэ нрверш',avg_by_hour,0) as нвепедэ_нрверш_avg, 
DECODE(c.name,'нвепедэ нрверш',min_by_hour,0) as нвепедэ_нрверш_min,
DECODE(c.name,'нвепедэ нрверш',max_by_hour,0) as нвепедэ_нрверш_max
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