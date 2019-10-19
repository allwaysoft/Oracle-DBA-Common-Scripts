set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:physical_read_per_second.sql
prompt *****************Begin*********
prompt

col dbid new_val dbid noprint
select dbid from v$database;

col INSTANCE_NUMBER  new_val INSTANCE_NUMBER noprint
select INSTANCE_NUMBER  from v$instance;

col value_db_block_size new_val value_db_block_size noprint
select value value_db_block_size
          from v$parameter
         where name = 'db_block_size' ;
         
col startup_time  new_val startup_time noprint      
select to_char(startup_time, 'yyyymmddhh24mi') startup_time
  from v$instance ;

select substr(end_interval_time, 5, 4) || ' ' ||
       substr(end_interval_time, 9, 4) ||'||'|| 
       round((value - value_prev) /
             ((to_date(end_interval_time, 'yyyymmddhh24miss') -
             to_date(end_interval_time_prev, 'yyyymmddhh24miss')) * 24 * 3600),
             2)  ||'||'||
       round(50 * 1024 * 1024 / &value_db_block_size ,0) 
  from (select snap_id,
               end_interval_time,
               value,
               lag(value) over(order by snap_id) value_prev,
               lag(end_interval_time) over(order by snap_id) end_interval_time_prev
          from (select a.snap_id,
                       to_char(b.end_interval_time, 'yyyymmddhh24miss') end_interval_time,
                       sum(a.value) value
                  from dba_hist_sysstat a, dba_hist_snapshot b
                 where a.stat_name='physical reads'
                   AND a.DBID=&DBID
                   and a.instance_number=&INSTANCE_NUMBER
                   and b.snap_id = a.snap_id
                   and a.instance_number = b.instance_number
                   and to_char(b.end_interval_time, 'yyyymmddhh24mi') > &startup_time
                   and b.end_interval_time >= sysdate - 7 
                 group by a.snap_id,
                          to_char(b.end_interval_time, 'yyyymmddhh24miss'))) result_a
 where value_prev is not null
   and end_interval_time_prev is not null
 order by snap_id ;

prompt
prompt *****************End************
prompt ##############End#################################
