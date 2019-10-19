set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:nls_database_parameters
prompt *****************Begin*********
prompt

select parameter||'||'||value
  from nls_database_parameters ;

prompt
prompt *****************End************
prompt ##############End#################################
