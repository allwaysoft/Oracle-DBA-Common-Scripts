set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:db_resource_used_percent.sql
prompt *****************Begin*********
prompt

select to_char(inst_id) ||'||'||
       decode(resource_name,
              'processes',
              'processes',
              'sessions',
              'sessions',
              'parallel_max_servers',
              'parallel_max_servers')  ||'||'||
       current_utilization   ||'||'||
       max_utilization  ||'||'||
       decode(limit_value, 'UNLIMITED', 'UNLIMITED', limit_value)  ||'||'||
       decode(max_utilization,
              0,
              0,
              round(100 * current_utilization / limit_value, 2)) || '%' 
  from gv$resource_limit
 where resource_name in ('processes', 'sessions', 'parallel_max_servers')
union all
select '*'  ||'||'||
       'db_files'  ||'||'||
       (select count(*) from dba_data_files)  ||'||'||
       (select count(*) from dba_data_files)  ||'||'||
       (select value from v$parameter where name = 'db_files')  ||'||'||
       round(100 * (select count(*) from dba_data_files) /
             (select value from v$parameter where name = 'db_files'),
             2) || '%' 
from dual ;

prompt
prompt *****************End************
prompt ##############End#################################
