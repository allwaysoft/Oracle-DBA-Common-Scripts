set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:v$recover_file view
prompt *****************Begin*********
prompt

SELECT 
		 FILE#                ||'||'||
		 ONLINE_STATUS        ||'||'||
		 ERROR                ||'||'||
		 CHANGE#              ||'||'||
		 TIME                 		 
  FROM v$recover_file ;

prompt
prompt *****************End************
prompt ##############End#################################
