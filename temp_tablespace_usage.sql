set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:TEMP TableSpace usage check
prompt *****************Begin*********
prompt

col value new_val db_block_size noprint
select value from v$parameter where name='db_block_size'; 

select t.tablespace_name || '||' || round(sum_temp / 1024 / 1024, 1) || '||' ||
       s.INST_ID|| '||' ||
       round(current_used_size / 1024 / 1024, 1) || '||' ||
       round(s.current_used_size / t.sum_temp, 1) || '||' ||
       round(max_used_size / 1024 / 1024, 1) || '||' ||
       round(s.max_used_size / t.sum_temp, 1) || '||' ||
       round(max_sort_size / 1024 / 1024, 1) || '||' ||
       round(s.max_sort_size / t.sum_temp, 1)
  from (select /*+ no_merge */
         tablespace_name, sum(bytes) sum_temp
          from dba_temp_files
         group by tablespace_name) t,
       (select /*+ no_merge */
         tablespace_name tablespace_name,
         INST_ID,
         (used_blocks * &db_block_size) current_used_size,
         (MAX_USED_BLOCKS * &db_block_size) max_used_size,
         (MAX_SORT_BLOCKS * &db_block_size) max_sort_size
          from gv$sort_segment) s
 where t.tablespace_name = s.tablespace_name;

prompt
prompt *****************End************
prompt ##############End#################################
