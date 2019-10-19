set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:database_total_size.sql
prompt *****************Begin*********
prompt

select owner||'||'||
       SEGMENT_TYPE||'||'||
       round(sum(bytes) / 1024 / 1024, 1)
  from dba_segments
 group by owner, SEGMENT_TYPE ;

prompt
prompt *****************End************
prompt ##############End#################################
