set pagesize 0 linesize 200 echo off feedback off
prompt
prompt ##############Begin############################################# 
prompt Parameter:v$database view
prompt *****************Begin*********
prompt

SELECT
				DBID||'||'||
				NAME||'||'||
				CREATED||'||'||
				RESETLOGS_CHANGE#||'||'||
				RESETLOGS_TIME||'||'||
				LOG_MODE||'||'||
				CHECKPOINT_CHANGE#||'||'||
				OPEN_MODE||'||'||
				PROTECTION_MODE||'||'||
				PROTECTION_LEVEL||'||'||
				DATABASE_ROLE||'||'||
				FORCE_LOGGING||'||'||
				PLATFORM_ID||'||'||
				PLATFORM_NAME||'||'||
				FLASHBACK_ON
FROM V$DATABASE;

prompt
prompt *****************End************
prompt ##############End#################################
