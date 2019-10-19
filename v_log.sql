set pagesize 0 linesize 200 echo off feedback off
prompt
prompt ##############Begin############################################# 
prompt Parameter:V$LOG view
prompt *****************Begin*********
prompt

 SELECT
			 GROUP#          ||'||'||           
			 THREAD#         ||'||'|| 
			 SEQUENCE#       ||'||'|| 
			 BYTES           ||'||'|| 
			 MEMBERS         ||'||'|| 
			 ARCHIVED        ||'||'|| 
			 STATUS          ||'||'|| 
			 FIRST_CHANGE#   ||'||'|| 
			 FIRST_TIME
 FROM V$LOG ;

prompt
prompt *****************End************
prompt ##############End#################################
