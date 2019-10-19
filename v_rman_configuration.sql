set pagesize 0 linesize 200 echo off feedback off
prompt
prompt ##############Begin############################################# 
prompt Parameter:v$rman_configuration view
prompt *****************Begin*********
prompt

 SELECT
				CONF#||'||'||    
				NAME||'||'||    
				VALUE
 FROM v$rman_configuration order by name ;

prompt
prompt *****************End************
prompt ##############End#################################
