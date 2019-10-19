set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:dba_registry view
prompt *****************Begin*********
prompt

select 
		 COMP_ID        ||'||'||      
		 COMP_NAME      ||'||'||      
		 VERSION        ||'||'||      
		 STATUS         ||'||'||      
		 MODIFIED       ||'||'||      
		 NAMESPACE      ||'||'||      
		 CONTROL        ||'||'||      
		 SCHEMA         ||'||'||      
		 PROCEDURE      ||'||'||      
		 STARTUP        ||'||'||      
		 PARENT_ID            
 from dba_registry;

prompt
prompt *****************End************
prompt ##############End#################################
