set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:dba_constraints view
prompt *****************Begin*********
prompt

SELECT 
		 OWNER                    ||'||'||
		 CONSTRAINT_NAME          ||'||'||
		 CONSTRAINT_TYPE          ||'||'||
		 TABLE_NAME               ||'||'||
		 R_OWNER                  ||'||'||
		 R_CONSTRAINT_NAME        ||'||'||
		 DELETE_RULE              ||'||'||
		 STATUS                   ||'||'||
		 DEFERRABLE               ||'||'||
		 DEFERRED                 ||'||'||
		 VALIDATED                ||'||'||
		 GENERATED                ||'||'||
		 BAD                      ||'||'||
		 RELY                     ||'||'||
		 LAST_CHANGE              ||'||'||
		 INDEX_OWNER              ||'||'||
		 INDEX_NAME               ||'||'||
		 INVALID                  ||'||'||
		 VIEW_RELATED
  FROM DBA_CONSTRAINTS
 WHERE STATUS = 'DISABLED' 
   AND OWNER not in
       (select username
          from dba_users
         where default_tablespace in ('SYSTEM', 'SYSAUX')) ;

prompt
prompt *****************End************
prompt ##############End#################################
