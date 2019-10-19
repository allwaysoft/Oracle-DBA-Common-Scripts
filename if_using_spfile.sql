set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:if_using_spfile
prompt *****************Begin*********
prompt

select 'instance ' || inst_id || ' is not using SPFILE'  if_using_spfile
  from gv$parameter
 where name = 'spfile'
   and value is  null;

prompt
prompt *****************End************
prompt ##############End#################################
