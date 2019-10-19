set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:dba_triggers view
prompt *****************Begin*********
prompt

SELECT 
		 OWNER                             ||'||'||
		 TRIGGER_NAME                      ||'||'||
		 TRIGGER_TYPE                      ||'||'||
		 TRIGGERING_EVENT                  ||'||'||
		 TABLE_OWNER                       ||'||'||
		 BASE_OBJECT_TYPE                  ||'||'||
		 TABLE_NAME                        ||'||'||
		 COLUMN_NAME                       ||'||'||
		 REFERENCING_NAMES                 ||'||'||
		 WHEN_CLAUSE                       ||'||'||
		 STATUS                            ||'||'||
		 DESCRIPTION                       ||'||'||
		 ACTION_TYPE
  FROM DBA_TRIGGERS
 WHERE STATUS = 'DISABLED'
   AND OWNER not in
       (select username
          from dba_users
         where default_tablespace in ('SYSTEM', 'SYSAUX'));

prompt
prompt *****************End************
prompt ##############End#################################
