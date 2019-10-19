set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:all non-default database parameter
prompt *****************Begin*********
prompt

select sid||'||'||name||'||'||value
  from v$spparameter
 where value is not null
 order by name, sid;

prompt
prompt *****************End************
prompt ##############End#################################
