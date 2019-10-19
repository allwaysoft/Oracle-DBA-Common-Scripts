set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:PGA_hist_peak_value_check
prompt *****************Begin*********
prompt

select a.instance_number ||'||'||
       b.param_value     ||'||'||
       a.max_value 
  from (select instance_number, round(max(value) / 1024 / 1024, 1) max_value
          from dba_hist_pgastat
         where name in ('maximum PGA allocated')
         group by instance_number) a,
       (select inst_id, round(value / 1024 / 1024, 1) param_value
          from gv$pgastat
         where name in ('aggregate PGA target parameter')) b
 where a.instance_number = b.inst_id ;


prompt
prompt *****************End************
prompt ##############End#################################
