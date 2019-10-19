set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:shared_pool_usage_check
prompt *****************Begin*********
prompt

select a.inst_id || '||' ||
       a.pool || '||' ||
       a.name || '||' ||
       round(a.bytes/1024/1024,0)|| '||' ||
       round(b.bytes/1024/1024,0)|| '||' ||
       round( a.bytes / b.bytes, 0)
  from gv$sgastat a,
       (select inst_id, sum(bytes) bytes
          from gv$sgastat
         where pool = 'shared pool'
         group by inst_id) b
 where a.pool = 'shared pool'
   and a.inst_id = b.inst_id
   and a.name not in('sql area','free memory','PCursor','CCursor')
   and round(100 * a.bytes / b.bytes, 2) > 10 ;

prompt
prompt *****************End************
prompt ##############End#################################
