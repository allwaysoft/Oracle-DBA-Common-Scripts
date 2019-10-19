set pagesize 0 linesize 200 echo off feedback off
prompt
prompt ##############Begin############################################# 
prompt Parameter:Instance status check
prompt *****************Begin*********
prompt

SELECT 
			INST_ID||'||'||
			INSTANCE_NUMBER||'||'||
			INSTANCE_NAME||'||'||
			HOST_NAME||'||'||
			VERSION||'||'||
			STARTUP_TIME||'||'||
			STATUS||'||'||
			PARALLEL||'||'||
			THREAD#||'||'||
			ARCHIVER||'||'||
			LOG_SWITCH_WAIT||'||'||
			LOGINS||'||'||
			SHUTDOWN_PENDING||'||'||
			DATABASE_STATUS||'||'||
			INSTANCE_ROLE||'||'||
			ACTIVE_STATE||'||'||
			BLOCKED
FROM GV$INSTANCE;


prompt
prompt *****************End************
prompt ##############End#################################
