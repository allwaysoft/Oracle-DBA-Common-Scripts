set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:invalid_dba_objects
prompt *****************Begin*********
prompt

select 
		 OWNER               ||'||'||
		 OBJECT_NAME         ||'||'||
		 SUBOBJECT_NAME      ||'||'||
		 OBJECT_ID           ||'||'||
		 DATA_OBJECT_ID      ||'||'||
		 OBJECT_TYPE         ||'||'||
		 CREATED             ||'||'||
		 LAST_DDL_TIME       ||'||'||
		 TIMESTAMP           ||'||'||
		 STATUS              ||'||'||
		 TEMPORARY           ||'||'||
		 GENERATED           ||'||'||
		 SECONDARY           
  FROM dba_objects
 WHERE status <> 'VALID' ;

prompt
prompt *****************End************
prompt ##############End#################################
