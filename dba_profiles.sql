set pagesize 0 linesize 200 echo off feedback off
prompt
prompt ##############Begin############################################# 
prompt Parameter:dba_profiles view
prompt *****************Begin*********
prompt

 SELECT
				PROFILE||'||'||
				RESOURCE_NAME||'||'||
				RESOURCE_TYPE||'||'||
				LIMIT
 FROM dba_profiles order by PROFILE ;

prompt
prompt *****************End************
prompt ##############End#################################
