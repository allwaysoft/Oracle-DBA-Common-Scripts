set pagesize 0 linesize 200 echo off feedback off verify off
prompt
prompt ##############Begin############################################# 
prompt Parameter:foreign key without index check
prompt *****************Begin*********
prompt

select 
       b.owner || '||' || 
       b.table_name|| '||' || 
       b.constraint_name|| '||' || 
       b.COLUMN_NAME|| '||' ||
       b.POSITION
  from dba_constraints a,
       dba_cons_columns b,
       (select /*+ no_merge */
         b.owner, b.table_name, b.column_name, b.position position
          from dba_constraints a, dba_cons_columns b
         where a.constraint_type = 'R'
           and a.owner not in
               ('SYS', 'SYSTEM', 'OUTLN', 'DIP', 'TSMSYS', 'DBSNMP',
                'ORACLE_OCM', 'WMSYS', 'EXFSYS', 'XDB', 'ANONYMOUS', 'ORDSYS',
                'SI_INFORMTN_SCHEMA', 'MDSYS', 'ORDPLUGINS','MGMT_VIEW','OLAPSYS','SYSMAN','PERFSTAT')
           and a.owner = b.owner
           and a.constraint_name = b.constraint_name
           and a.table_name = b.table_name
        minus
        select /*+ no_merge */
         a.table_owner owner,
         a.table_name,
         a.column_name,
         a.column_position position
          from dba_ind_columns a
         where a.table_owner not in
               ('SYS', 'SYSTEM', 'OUTLN', 'DIP', 'TSMSYS', 'DBSNMP',
                'ORACLE_OCM', 'WMSYS', 'EXFSYS', 'XDB', 'ANONYMOUS', 'ORDSYS',
                'SI_INFORMTN_SCHEMA', 'MDSYS', 'ORDPLUGINS','MGMT_VIEW','OLAPSYS','SYSMAN','PERFSTAT')) c
 where a.constraint_type = 'R'
   and a.owner not in
       ('SYS', 'SYSTEM', 'OUTLN', 'DIP', 'TSMSYS', 'DBSNMP', 'ORACLE_OCM',
        'WMSYS', 'EXFSYS', 'XDB', 'ANONYMOUS', 'ORDSYS',
        'SI_INFORMTN_SCHEMA', 'MDSYS', 'ORDPLUGINS','MGMT_VIEW','OLAPSYS','SYSMAN','PERFSTAT')
   and a.owner = b.owner
   and a.constraint_name = b.constraint_name
   and a.table_name = b.table_name
   and b.owner = c.owner
   and b.table_name = c.table_name
   and b.position = c.position ;

prompt
prompt *****************End************
prompt ##############End#################################
