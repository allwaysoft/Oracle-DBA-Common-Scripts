set pagesize 0 linesize 200 echo off feedback off
prompt
prompt ##############Begin############################################# 
prompt Parameter:v$controlfile view
prompt *****************Begin*********
prompt

SELECT
			STATUS||'||'||
			NAME||'||'||
			IS_RECOVERY_DEST_FILE||'||'||
			BLOCK_SIZE||'||'||
			FILE_SIZE_BLKS        
FROM V$CONTROLFILE;


prompt
prompt *****************End************
prompt ##############End#################################
