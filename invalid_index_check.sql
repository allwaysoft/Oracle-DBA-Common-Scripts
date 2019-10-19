set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:invalid index check
prompt *****************Begin*********
prompt

select  owner || '||' || index_name|| '||' ||status|| '||' ||'Non-partition-index'
  from dba_indexes
 where status not in ('VALID', 'N/A')
union all
select index_owner || '.' || index_name|| '||' ||status|| '||' ||'Partition-index'
  from dba_ind_partitions
 where status not in ('USABLE', 'N/A')
union all
select index_owner || '.' || index_name|| '||' ||status|| '||' ||'SubPartition-index'
  from dba_ind_subpartitions
 where status not in ('USABLE', 'N/A');

prompt
prompt *****************End************
prompt ##############End#################################
