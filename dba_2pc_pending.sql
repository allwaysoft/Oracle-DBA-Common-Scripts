set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:dba_2pc_pending
prompt *****************Begin*********
prompt

 SELECT 
		 LOCAL_TRAN_ID               ||'||'||
		 GLOBAL_TRAN_ID              ||'||'||
		 STATE                       ||'||'||
		 MIXED                       ||'||'||
		 ADVICE                      ||'||'||
		 TRAN_COMMENT                ||'||'||
		 FAIL_TIME                   ||'||'||
		 FORCE_TIME                  ||'||'||
		 RETRY_TIME                  ||'||'||
		 OS_USER                     ||'||'||
		 OS_TERMINAL                 ||'||'||
		 HOST                        ||'||'||
		 DB_USER                     ||'||'||
		 COMMIT#
 FROM dba_2pc_pending 
   where (sysdate - fail_time) * 24 * 3600 > 3600
order by fail_time;

prompt
prompt *****************End************
prompt ##############End#################################
