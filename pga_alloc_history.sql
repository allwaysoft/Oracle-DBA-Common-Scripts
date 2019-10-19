set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:pga_alloc_history.sql
prompt *****************Begin*********
prompt

with tmp_pga_warning as
( select round((case
                when (select value
                        from v$parameter
                       where name like 'pga_aggregate_target') > 0 then
                 (select value
                    from v$parameter
                   where name like 'pga_aggregate_target')
                when (select value
                        from v$parameter
                       where name like 'pga_aggregate_target') = 0 then
                 (select value from v$parameter where name like 'memory_target')
              end) / 1024 / 1024,
              0) as value
   from dual)
select to_char(b.end_interval_time, 'yyyymmdd hh24')  ||'||'||
       round(a.value / 1024 / 1024, 1)  ||'||'||
       c.value 
  from dba_hist_pgastat a, dba_hist_snapshot b,tmp_pga_warning c
 where a.name = 'total PGA allocated'
   and a.snap_id = b.snap_id
   and a.instance_number = b.instance_number
   and a.instance_number = (select instance_number from v$instance)
   and b.end_interval_time >= sysdate - 7
 order by 1 ;

prompt
prompt *****************End************
prompt ##############End#################################
