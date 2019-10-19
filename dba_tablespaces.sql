set pagesize 0 linesize 200 echo off feedback off
prompt
prompt ##############Begin############################################# 
prompt Parameter:dba_tablespaces view
prompt *****************Begin*********
prompt

 SELECT
 TABLESPACE_NAME                 ||'||'||
 BLOCK_SIZE                      ||'||'||
 INITIAL_EXTENT                  ||'||'||
 NEXT_EXTENT                     ||'||'||
 MIN_EXTENTS                     ||'||'||
 MAX_EXTENTS                     ||'||'||
 PCT_INCREASE                    ||'||'||
 MIN_EXTLEN                      ||'||'||
 STATUS                          ||'||'||
 CONTENTS                        ||'||'||
 LOGGING                         ||'||'||
 FORCE_LOGGING                   ||'||'||
 EXTENT_MANAGEMENT               ||'||'||
 ALLOCATION_TYPE                 ||'||'||
 PLUGGED_IN                      ||'||'||
 SEGMENT_SPACE_MANAGEMENT        ||'||'||
 DEF_TAB_COMPRESSION             ||'||'||
 RETENTION                       ||'||'||
 BIGFILE
 FROM dba_tablespaces ;

prompt
prompt *****************End************
prompt ##############End#################################
