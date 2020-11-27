SQL> @?/rdbms/admin/addmrpt.sql

Or:

-- Check ADDM report for any pool corrections (SGA size, shared pool, buffer cache etc).
 
-- Check last 10 ADDM findings:
col begin_time for a14
col finding_name for a23
col impact for 999999999999
col impact_type for a17
col message for a50
select * from (select to_char(begin_time, 'YY-MM-DD HH24:MI') begin_time, finding_name, impact, impact_type, message
from dba_addm_findings f, dba_addm_tasks t
where impact <> 0 and type='PROBLEM' and f.task_id = t.task_id
order by 1 desc ) where rownum < 11;

-----
select task_name, execution_end 
from dba_advisor_tasks 
where advisor_name='ADDM' 
and status='COMPLETED' 
and owner='SYS' 
order by execution_end desc;

-----
select DBMS_ADVISOR.GET_TASK_REPORT('<task_name from previous query>', 'TEXT', 'TYPICAL', 'ALL', 'SYS') from dual;

--------------------------------------------------------------------------------------------------------------------------------------------

-- ADDM does analysis of the data in the AWR, so any references to snapshots relates to the AWR snapshots

SET LINESIZE 120

COLUMN begin_interval_time FORMAT A30
COLUMN end_interval_time FORMAT A30
COLUMN startup_time FORMAT A30

SELECT snap_id, begin_interval_time, end_interval_time, startup_time
FROM   dba_hist_snapshot
WHERE  begin_interval_time > TRUNC(SYSTIMESTAMP)
ORDER BY snap_id;

--------------------------------------------
--- he ANALYZE_DB procedure does analysis of the whole database for the period between the two specified snapshots.

DECLARE
  l_task_name VARCHAR2(30) := 'MY_REPORT_DB';
BEGIN
  DBMS_ADDM.analyze_db (
    task_name      => l_task_name,
    begin_snapshot => 43206,
    end_snapshot   => 43207);
END;
/

--------------------------------------------
--- The GET_REPORT function returns the findings for the specified analysis task.

SET LONG 1000000 LONGCHUNKSIZE 1000000
SET LINESIZE 1000 PAGESIZE 0
SET TRIM ON TRIMSPOOL ON
SET ECHO OFF FEEDBACK OFF

SELECT DBMS_ADDM.get_report('MY_REPORT_DB') FROM dual;

--------------------------------------------
---- You can remove any ADDM tasks using the DELETE procedure.

BEGIN
  DBMS_ADDM.delete('MY_REPORT_DB');
END;
/




