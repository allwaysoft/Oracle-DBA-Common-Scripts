set pagesize 0 linesize 200 echo off feedback off
prompt
prompt ##############Begin############################################# 
prompt Parameter:dba_data_files view
prompt *****************Begin*********
prompt

 SELECT
				FILE_NAME||'||'||
				FILE_ID||'||'||
				TABLESPACE_NAME||'||'||
				BYTES||'||'||
				BLOCKS||'||'||
				STATUS||'||'||
				RELATIVE_FNO||'||'||
				AUTOEXTENSIBLE||'||'||
				MAXBYTES||'||'||
				MAXBLOCKS||'||'||
				INCREMENT_BY||'||'||
				USER_BYTES||'||'||
				USER_BLOCKS||'||'||
				ONLINE_STATUS
 FROM dba_data_files ;

prompt
prompt *****************End************
prompt ##############End#################################
