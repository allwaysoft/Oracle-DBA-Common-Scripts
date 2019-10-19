set pagesize 0 linesize 200 echo off feedback off
prompt
prompt ##############Begin############################################# 
prompt Parameter:dba_undo_extents view
prompt *****************Begin*********
prompt

select c.tablespace_name || '||' || 
       round(c.sum_b / 1024 / 1024, 1) || '||' ||
       d.status || '||' || round(d.status_b / 1024 / 1024, 1) || '||' ||
       round(100 * nvl(d.status_b, 0) / c.sum_b, 1)
  from (select a.tablespace_name, sum(bytes) sum_b
          from dba_data_files a, dba_tablespaces b
         where a.tablespace_name = b.tablespace_name
           and b.contents = 'UNDO'
         group by a.tablespace_name) c,
       (select tablespace_name, status, sum(bytes) status_b
          from dba_undo_extents
         group by tablespace_name, status) d
 where c.tablespace_name = d.tablespace_name(+) ;


prompt
prompt *****************End************
prompt ##############End#################################
