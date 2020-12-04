How to List and Monitor DBMS Jobs and Scheduler Jobs in Oracle Database
Mehmet Salih Deveci March 29, 2020 Leave a comment

I will explain How to List and Monitor DBMS Jobs and Scheduler Jobs in Oracle Database in this post.


 

Monitoring Oracle Jobs
There are two packages related with Oracle database jobs which are called dbms_job,dbms_scheduler.

 

DBMS_SCHEDULER Jobs
DBMS_SCHEDULER offers new features by adding the ability to jobs with specific privileges and roles according to DBMS_JOB.

 

 

List and Monitor DBMS Jobs and Scheduler Jobs in Oracle
 

DBMS_JOB – Gather Schema Stats job
For example; Gather Schema Stats job with DBMS_JOB are as follows.

SET SERVEROUTPUT ON
DECLARE
l_job NUMBER;
BEGIN
SELECT MAX (job) + 1 INTO l_job FROM dba_jobs;
DBMS_JOB.submit(l_job,
'BEGIN DBMS_STATS.gather_schema_stats(''MSD'',estimate_percent => dbms_stats.auto_sample_size, degree=>8 ); END;',
trunc(next_day(SYSDATE,'SUNDAY'))+11/24,
'TRUNC (SYSDATE+7)+11/24');
COMMIT;
DBMS_OUTPUT.put_line('Job: ' || l_job);
END;
/
 

 

DBMS_JOB
For example; Kill Long Session ( procedure ) with DBMS_SCHEDULER are as follows.

 

BEGIN
SYS.DBMS_SCHEDULER.CREATE_JOB
(
job_name => 'SYS.KILL_LONG_SESSION'
,start_date => TO_TIMESTAMP_TZ('2020/02/06 16:00:00.000000 +03:00','yyyy/mm/dd hh24:mi:ss.ff tzr')
,repeat_interval => 'FREQ=MINUTELY;INTERVAL=1'
,end_date => TO_TIMESTAMP_TZ('2090/08/18 00:00:00.000000 +03:00','yyyy/mm/dd hh24:mi:ss.ff tzr')
,job_class => 'DEFAULT_JOB_CLASS'
,job_type => 'STORED_PROCEDURE'
,job_action => 'SYS.KILL_LONG_SESSIONS'
,comments => NULL
);
SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
( name => 'SYS.KILL_LONG_SESSION'
,attribute => 'RESTARTABLE'
,value => FALSE);
SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
( name => 'SYS.KILL_LONG_SESSION'
,attribute => 'LOGGING_LEVEL'
,value => SYS.DBMS_SCHEDULER.LOGGING_OFF);
SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
( name => 'SYS.KILL_LONG_SESSION'
,attribute => 'MAX_FAILURES');
SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
( name => 'SYS.KILL_LONG_SESSION'
,attribute => 'MAX_RUNS');
SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
( name => 'SYS.KILL_LONG_SESSION'
,attribute => 'STOP_ON_WINDOW_CLOSE'
,value => FALSE);
SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
( name => 'SYS.KILL_LONG_SESSION'
,attribute => 'JOB_PRIORITY'
,value => 3);
SYS.DBMS_SCHEDULER.SET_ATTRIBUTE_NULL
( name => 'SYS.KILL_LONG_SESSION'
,attribute => 'SCHEDULE_LIMIT');
SYS.DBMS_SCHEDULER.SET_ATTRIBUTE
( name => 'SYS.KILL_LONG_SESSION'
,attribute => 'AUTO_DROP'
,value => FALSE);

SYS.DBMS_SCHEDULER.ENABLE
(name => 'SYS.KILL_LONG_SESSION');
END;
/
 

Monitor or List DBMS_JOB 
You can list and monitor the DBMS_JOB as follows.

select * from dba_jobs;
 



 

dba_jobs view columns are as follows.

 

SQL> desc dba_jobs;
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 JOB                                       NOT NULL NUMBER
 LOG_USER                                  NOT NULL VARCHAR2(30)
 PRIV_USER                                 NOT NULL VARCHAR2(30)
 SCHEMA_USER                               NOT NULL VARCHAR2(30)
 LAST_DATE                                          DATE
 LAST_SEC                                           VARCHAR2(8)
 THIS_DATE                                          DATE
 THIS_SEC                                           VARCHAR2(8)
 NEXT_DATE                                 NOT NULL DATE
 NEXT_SEC                                           VARCHAR2(8)
 TOTAL_TIME                                         NUMBER
 BROKEN                                             VARCHAR2(1)
 INTERVAL                                  NOT NULL VARCHAR2(200)
 FAILURES                                           NUMBER
 WHAT                                               VARCHAR2(4000)
 NLS_ENV                                            VARCHAR2(4000)
 MISC_ENV                                           RAW(32)
 INSTANCE                                           NUMBER

SQL>
 

 

 

DBMS_SCHEDULER Jobs Monitor
 

You can list and monitor the DBMS_SCHEDULER as follows.

select * from dba_scheduler_jobs;
 



 

You can list and view the log of  DBMS_SCHEDULER  as follows.

select * from DBA_SCHEDULER_JOB_LOG;



 

dba_scheduler_jobs view columns are as follows.

 

SQL> desc dba_scheduler_jobs;
 Name                                                  Null?    Type
 ----------------------------------------------------- -------- ------------------------------------
 OWNER                                                          VARCHAR2(30)
 JOB_NAME                                                       VARCHAR2(30)
 JOB_SUBNAME                                                    VARCHAR2(30)
 JOB_STYLE                                                      VARCHAR2(11)
 JOB_CREATOR                                                    VARCHAR2(30)
 CLIENT_ID                                                      VARCHAR2(64)
 GLOBAL_UID                                                     VARCHAR2(32)
 PROGRAM_OWNER                                                  VARCHAR2(4000)
 PROGRAM_NAME                                                   VARCHAR2(4000)
 JOB_TYPE                                                       VARCHAR2(16)
 JOB_ACTION                                                     VARCHAR2(4000)
 NUMBER_OF_ARGUMENTS                                            NUMBER
 SCHEDULE_OWNER                                                 VARCHAR2(4000)
 SCHEDULE_NAME                                                  VARCHAR2(4000)
 SCHEDULE_TYPE                                                  VARCHAR2(12)
 START_DATE                                                     TIMESTAMP(6) WITH TIME ZONE
 REPEAT_INTERVAL                                                VARCHAR2(4000)
 EVENT_QUEUE_OWNER                                              VARCHAR2(30)
 EVENT_QUEUE_NAME                                               VARCHAR2(30)
 EVENT_QUEUE_AGENT                                              VARCHAR2(256)
 EVENT_CONDITION                                                VARCHAR2(4000)
 EVENT_RULE                                                     VARCHAR2(65)
 FILE_WATCHER_OWNER                                             VARCHAR2(65)
 FILE_WATCHER_NAME                                              VARCHAR2(65)
 END_DATE                                                       TIMESTAMP(6) WITH TIME ZONE
 JOB_CLASS                                                      VARCHAR2(30)
 ENABLED                                                        VARCHAR2(5)
 AUTO_DROP                                                      VARCHAR2(5)
 RESTARTABLE                                                    VARCHAR2(5)
 STATE                                                          VARCHAR2(15)
 JOB_PRIORITY                                                   NUMBER
 RUN_COUNT                                                      NUMBER
 MAX_RUNS                                                       NUMBER
 FAILURE_COUNT                                                  NUMBER
 MAX_FAILURES                                                   NUMBER
 RETRY_COUNT                                                    NUMBER
 LAST_START_DATE                                                TIMESTAMP(6) WITH TIME ZONE
 LAST_RUN_DURATION                                              INTERVAL DAY(9) TO SECOND(6)
 NEXT_RUN_DATE                                                  TIMESTAMP(6) WITH TIME ZONE
 SCHEDULE_LIMIT                                                 INTERVAL DAY(3) TO SECOND(0)
 MAX_RUN_DURATION                                               INTERVAL DAY(3) TO SECOND(0)
 LOGGING_LEVEL                                                  VARCHAR2(11)
 STOP_ON_WINDOW_CLOSE                                           VARCHAR2(5)
 INSTANCE_STICKINESS                                            VARCHAR2(5)
 RAISE_EVENTS                                                   VARCHAR2(4000)
 SYSTEM                                                         VARCHAR2(5)
 JOB_WEIGHT                                                     NUMBER
 NLS_ENV                                                        VARCHAR2(4000)
 SOURCE                                                         VARCHAR2(128)
 NUMBER_OF_DESTINATIONS                                         NUMBER
 DESTINATION_OWNER                                              VARCHAR2(128)
 DESTINATION                                                    VARCHAR2(128)
 CREDENTIAL_OWNER                                               VARCHAR2(30)
 CREDENTIAL_NAME                                                VARCHAR2(30)
 INSTANCE_ID                                                    NUMBER
 DEFERRED_DROP                                                  VARCHAR2(5)
 ALLOW_RUNS_IN_RESTRICTED_MODE                                  VARCHAR2(5)
 COMMENTS                                                       VARCHAR2(240)
 FLAGS                                                          NUMBER
 

 

 

All Scheduler Job Run Details
You can monitor all scheduler jobs run details as follows.

select * from ALL_SCHEDULER_JOB_RUN_DETAILS;
 



 

You can monitor dba scheduler running jobs as follows.

select * from dba_scheduler_running_jobs;
 

You can monitor dba scheduler running jobs details as follows.

select * from dba_scheduler_job_run_details;
 

 

You can run any scheduler jobs manually as follows.

begin 
dbms_scheduler.run_job('JOB_NAME');
end;
/
 

 

Do you want to learn Oracle Database for Beginners, then Click and read the following articles.
Oracle Database Tutorials for Beginners ( Junior Oracle DBA )
