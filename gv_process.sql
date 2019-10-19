set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:gv$process view
prompt *****************Begin*********
prompt

SELECT 
			INST_ID||'||'||
			ADDR||'||'||
			PID||'||'||
			SPID||'||'||
			USERNAME||'||'||
			SERIAL#||'||'||
			TERMINAL||'||'||
			PROGRAM||'||'||
			TRACEID||'||'||
			BACKGROUND||'||'||
			LATCHWAIT||'||'||
			LATCHSPIN||'||'||
			PGA_USED_MEM||'||'||
			PGA_ALLOC_MEM||'||'||
			PGA_FREEABLE_MEM||'||'||
			PGA_MAX_MEM
 FROM gv$process 
order by inst_id,PGA_ALLOC_MEM;

prompt
prompt *****************End************
prompt ##############End#################################
