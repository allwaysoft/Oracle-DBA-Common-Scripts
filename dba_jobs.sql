set pagesize 0 linesize 400 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:dba_jobs view
prompt *****************Begin*********
prompt

select 
			JOB||'||'||
			LOG_USER||'||'||
			PRIV_USER||'||'||
			SCHEMA_USER||'||'||
			LAST_DATE||'||'||
			LAST_SEC||'||'||
			THIS_DATE||'||'||
			THIS_SEC||'||'||
			NEXT_DATE||'||'||
			NEXT_SEC||'||'||
			TOTAL_TIME||'||'||
			BROKEN||'||'||
			INTERVAL||'||'||
			FAILURES||'||'||
			WHAT||'||'||
			INSTANCE 
  from dba_jobs ;


prompt
prompt *****************End************
prompt ##############End#################################
