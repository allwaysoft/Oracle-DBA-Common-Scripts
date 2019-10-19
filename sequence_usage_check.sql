set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:Sequence usage check
prompt *****************Begin*********
prompt

select SEQUENCE_OWNER || '||' || 
       SEQUENCE_NAME || '||' ||
       round((case
               when INCREMENT_BY < 0 then
                abs(a.last_number - a.MAX_VALUE) / abs(a.max_value - MIN_VALUE)
               when INCREMENT_BY > 0 then
                abs(a.last_number - a.MIN_VALUE) / abs(a.max_value - MIN_VALUE)
             end),
             0) || '||' || 
       MIN_VALUE || '||' || 
       MAX_VALUE || '||' ||
       INCREMENT_BY || '||' || 
       CYCLE_FLAG || '||' || 
       ORDER_FLAG || '||' ||
       CACHE_SIZE || '||' || 
       LAST_NUMBER
  from dba_sequences a
 where cycle_flag = 'N'
   and round(100 * (case
               when INCREMENT_BY < 0 then
                abs(a.last_number - a.MAX_VALUE) / abs(a.max_value - MIN_VALUE)
               when INCREMENT_BY > 0 then
                abs(a.last_number - a.MIN_VALUE) / abs(a.max_value - MIN_VALUE)
             end),
             0) >= 70 ;

prompt
prompt *****************End************
prompt ##############End#################################
