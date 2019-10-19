set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:dba_scheduler_jobs view
prompt *****************Begin*********
prompt

select 
		job_name||'||'||
		owner||'||'||
		enabled||'||'||
		state||'||'||
		program_name||'||'||
		TO_CHAR(LAST_START_DATE,'YYYYMMDD HH24:MI:SS')||'||'||
		TO_CHAR(NEXT_RUN_DATE,'YYYYMMDD HH24:MI:SS')
 from dba_scheduler_jobs order by 1 ;

prompt
prompt *****************End************
prompt ##############End#################################
