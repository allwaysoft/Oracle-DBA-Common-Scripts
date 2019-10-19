set pagesize 0 linesize 200 echo off feedback off verify off
set echo on
prompt
prompt ##############Begin############################################# 
prompt Parameter:top_event_check.sql
prompt *****************Begin*********
prompt

col dbid new_val dbid noprint
select dbid from v$database;

col INSTANCE_NUMBER  new_val INSTANCE_NUMBER noprint
select INSTANCE_NUMBER  from v$instance;

col begin_snap_id new_val begin_snap_id noprint
col end_snap_id   new_val end_snap_id   noprint

select snap_id begin_snap_id
  from (select *
          from dba_hist_snapshot
         where 
               INSTANCE_NUMBER = &INSTANCE_NUMBER
           and end_interval_time >=
               (select trunc(sysdate, 'd') + 2 + 9 / 24 from dual)
         order by snap_id)
 where rownum < 2 ;
 
select snap_id end_snap_id
  from (select *
          from dba_hist_snapshot
         where end_interval_time >=
               (select trunc(sysdate, 'd') + 2 + 10 / 24 from dual)
           and snap_id != &begin_snap_id
         order by snap_id)
 where rownum < 2 ;


select *
  from (select event_name||'||'||
               total_waits||'||'||
               round(time_waited_micro / 1000000,0) ||'||'||
               round(time_waited_micro / 1000 / total_waits, 0) ||'||'||
               wait_class  ||'||'||
               100 * (round(ratio_to_report(time_waited_micro) over(), 1)) || '%'
          from (select a.event_name,
                       (a.total_waits - b.total_waits) total_waits,
                       a.time_waited_micro - b.time_waited_micro time_waited_micro,
                       a.wait_class
                  from (select event_name,
                               total_waits,
                               time_waited_micro,
                               wait_class
                          from dba_hist_system_event
                         where snap_id = &end_snap_id
                           and dbid = &dbid
                           and wait_class != 'Idle'
                           and instance_number = &INSTANCE_NUMBER) a,
                       (select event_name,
                               total_waits,
                               time_waited_micro,
                               wait_class
                          from dba_hist_system_event
                         where snap_id = &begin_snap_id
                           and dbid =  &dbid
                           and wait_class != 'Idle'
                           and instance_number = &INSTANCE_NUMBER) b
                 where a.event_name = b.event_name
                   and a.wait_class = b.wait_class )
         where total_waits != 0
         order by time_waited_micro desc )
 where rownum < 11 ;

prompt
prompt *****************End************
prompt ##############End#################################
