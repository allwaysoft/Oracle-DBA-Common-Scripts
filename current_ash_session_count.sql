set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:ash_session_count
prompt *****************Begin*********
prompt

select to_char(sample_time, 'yyyymmdd hh24:mi:ss')  || '||' || count(*)|| '||' ||50
  from v$active_session_history
 where sample_time >= sysdate - 1/96
 group by to_char(sample_time, 'yyyymmdd hh24:mi:ss')
 order by 1;

prompt
prompt *****************End************
prompt ##############End#################################
