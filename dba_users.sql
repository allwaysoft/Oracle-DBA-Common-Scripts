set pagesize 0 linesize 200 echo off feedback off
prompt
prompt ##############Begin############################################# 
prompt Parameter:dba_users view
prompt *****************Begin*********
prompt

 SELECT
			USERNAME||'||'||
			USER_ID||'||'||
			PASSWORD||'||'||
			ACCOUNT_STATUS||'||'||
			LOCK_DATE||'||'||
			EXPIRY_DATE||'||'||
			DEFAULT_TABLESPACE||'||'||
			TEMPORARY_TABLESPACE||'||'||
			CREATED||'||'||
			PROFILE||'||'||
			INITIAL_RSRC_CONSUMER_GROUP||'||'||
			EXTERNAL_NAME
 FROM dba_users order by created;

prompt
prompt *****************End************
prompt ##############End#################################
