set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:important_db_parameter check
prompt *****************Begin*********
prompt

select inst_id||'||'||name||'||'||value
  from gv$parameter
 where name in (
                'cluster_database',
                'cluster_database_instances',
                'cpu_count',
                'memory_target',
                'memory_max_target',
                'sga_max_size',
                'sga_target',
                'shared_pool_size',
                'db_cache_size',
                'large_pool_size',
                'stream_pool_size',
                'large_pool_size',
                'log_buffer',
                'pga_aggregate_target',
                'instance_name',
                'db_block_size',
                'processes')
union all
select INST_ID || '||' || 'DBID' || '||' || DBID
  from gv$database
 where inst_id = (select instance_number from v$instance)
union all
select INST_ID || '||' || 'DBNAME' || '||' || NAME
  from gv$database
 where inst_id = (select instance_number from v$instance) ;
 

prompt
prompt *****************End************
prompt ##############End#################################
