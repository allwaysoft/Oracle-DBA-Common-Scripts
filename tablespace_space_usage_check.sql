set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:tablespace_space_usage_check
prompt *****************Begin*********
prompt

select d.tablespace_name	||'||'||
       round((d.sumbytes / 1024 / 1024), 2)||'||'||
       round((d.sum_free_extend_bytes +
             decode(f.sumbytes, null, 0, f.sumbytes)) / 1024 / 1024,
             2) ||'||'||
       round(((d.sumbytes - d.sum_free_extend_bytes -
             decode(f.sumbytes, null, 0, f.sumbytes)) / 1024 / 1024),
             2) ||'||'||
       round((d.sumbytes - d.sum_free_extend_bytes -
             decode(f.sumbytes, null, 0, f.sumbytes)) * 100 / d.sumbytes,
             2)||'%' "used_PCT%"
  from (select tablespace_name, sum(bytes) sumbytes
          from dba_free_space
         group by tablespace_name) f,
       (select tablespace_name,
               sum(decode(maxbytes, 0, bytes, maxbytes)) sumbytes,
               sum((decode(maxbytes, 0, bytes, maxbytes) - bytes)) sum_free_extend_bytes
          from dba_data_files
         group by tablespace_name) d
 where f.tablespace_name(+) = d.tablespace_name ;

prompt
prompt *****************End************
prompt ##############End#################################
