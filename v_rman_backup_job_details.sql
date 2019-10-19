set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:v$rman_backup_job_details view
prompt *****************Begin*********
prompt

SELECT *  FROM (select 
SESSION_KEY || '||'|| SESSION_RECID || '||'|| SESSION_STAMP || '||'|| COMMAND_ID 
|| '||'|| START_TIME || '||'|| END_TIME || '||'|| INPUT_BYTES || '||'|| OUTPUT_BYTES || '||'|| 
STATUS_WEIGHT || '||'|| OPTIMIZED_WEIGHT || '||'|| OBJECT_TYPE_WEIGHT || '||'|| 
OUTPUT_DEVICE_TYPE || '||'|| AUTOBACKUP_COUNT || '||'|| AUTOBACKUP_DONE || '||'|| STATUS
 || '||'|| INPUT_TYPE || '||'|| OPTIMIZED || '||'|| ELAPSED_SECONDS || '||'||
  COMPRESSION_RATIO || '||'|| INPUT_BYTES_PER_SEC || '||'|| OUTPUT_BYTES_PER_SEC || '||'||
   INPUT_BYTES_DISPLAY || '||'|| OUTPUT_BYTES_DISPLAY || '||'|| INPUT_BYTES_PER_SEC_DISPLAY || '||'|| 
   OUTPUT_BYTES_PER_SEC_DISPLAY || '||'|| TIME_TAKEN_DISPLAY
                  from v$rman_backup_job_details
                 order by start_time DESC) r WHERE rownum < 21;


prompt
prompt *****************End************
prompt ##############End#################################
