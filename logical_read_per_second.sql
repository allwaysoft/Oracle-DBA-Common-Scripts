set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:logical_read_per_second.sql
prompt *****************Begin*********
prompt

col dbid new_val dbid noprint
select dbid from v$database;

col INSTANCE_NUMBER  new_val INSTANCE_NUMBER noprint
select INSTANCE_NUMBER  from v$instance;

col value_cpu_count new_val value_cpu_count noprint
select round(value * 2 / 3, 2) value_cpu_count
          from v$parameter
         where name = 'cpu_count' ;
         
col startup_time  new_val startup_time noprint      
select to_char(startup_time, 'yyyymmddhh24mi') startup_time
  from v$instance ;

select substr(end_interval_time, 5, 4) || ' ' ||
       substr(end_interval_time, 9, 4) ||'||'||
       round((value - value_prev) /
             ((to_date(end_interval_time, 'yyyymmddhh24miss') -
             to_date(end_interval_time_prev, 'yyyymmddhh24miss')) * 24 * 3600),
             1) 
  from (select a.snap_id,
               to_char(b.end_interval_time, 'yyyymmddhh24miss') end_interval_time,
               a.value,
               lag(a.value) over(order by a.snap_id) value_prev,
               to_char(lag(b.end_interval_time) over(order by a.snap_id),
                       'yyyymmddhh24miss') end_interval_time_prev
          from dba_hist_sysstat a, dba_hist_snapshot b
         where a.stat_name = 'session logical reads'
           AND a.DBID=&DBID
           and a.instance_number=&INSTANCE_NUMBER
           and b.snap_id = a.snap_id
           and a.instance_number = b.instance_number
           and to_char(b.end_interval_time, 'yyyymmddhh24mi') > &startup_time
           and b.end_interval_time >= sysdate - 7 )
 where value_prev is not null
   and end_interval_time_prev is not null
 order by snap_id ;

prompt
prompt *****************End************
prompt ##############End#################################
