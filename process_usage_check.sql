set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:Process usage check
prompt *****************Begin*********
prompt

select INST_ID || '||' || 
       TO_NUMBER(LIMIT_VALUE) || '||' ||
       CURRENT_UTILIZATION || '||' ||
       ROUND(CURRENT_UTILIZATION / to_number(limit_value), 0) || '||' ||
       MAX_UTILIZATION || '||' ||
       ROUND(MAX_UTILIZATION / to_number(limit_value), 0)
  from gv$resource_limit
 where resource_name = 'processes'
 order by inst_id;

prompt
prompt *****************End************
prompt ##############End#################################
