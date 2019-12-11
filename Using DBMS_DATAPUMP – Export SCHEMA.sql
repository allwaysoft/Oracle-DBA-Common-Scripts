DECLARE
  l_dp_handle       NUMBER;
  l_last_job_state  VARCHAR2(30) := 'UNDEFINED';
  l_job_state       VARCHAR2(30) := 'UNDEFINED';
  l_sts             KU$_STATUS;
BEGIN
  l_dp_handle := DBMS_DATAPUMP.open(
    operation   => 'EXPORT',
    job_mode    => 'SCHEMA',
    remote_link => NULL,
    job_name    => 'EMP_EXPORT',
    version     => 'LATEST');

  DBMS_DATAPUMP.add_file(
    handle    => l_dp_handle,
    filename  => 'SCOTT.dmp',
    directory => 'DATA_PUMP_DIR');
  DBMS_DATAPUMP.add_file(
    handle    => l_dp_handle,
    filename  => 'SCOTT.log',
    directory => 'DATA_PUMP_DIR',
    filetype  => DBMS_DATAPUMP.KU$_FILE_TYPE_LOG_FILE);

  DBMS_DATAPUMP.metadata_filter(
    handle => l_dp_handle,
    name   => 'SCHEMA_EXPR',
    value  => '= ''SCOTT''');

  DBMS_DATAPUMP.start_job(l_dp_handle);

  DBMS_DATAPUMP.detach(l_dp_handle);
END;
/
select * from dba_datapump_jobs;