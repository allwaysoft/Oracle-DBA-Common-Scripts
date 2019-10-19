set pagesize 0 linesize 200 echo off feedback off
prompt
prompt ##############Begin############################################# 
prompt Parameter:V$LOGFILE view
prompt *****************Begin*********
prompt

SELECT 
			GROUP#||'||'||
			STATUS||'||'||
			TYPE||'||'||
			MEMBER||'||'||
			IS_RECOVERY_DEST_FILE
FROM V$LOGFILE;


prompt
prompt *****************End************
prompt ##############End#################################
