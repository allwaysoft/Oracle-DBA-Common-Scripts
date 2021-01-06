SELECT *   FROM (  SELECT event as Event,time_waited as Time_Waited, total_waits as Total_Waits FROM v$system_event    WHERE event NOT IN ('PX Idle Wait',   'pmon timer',         'smon timer',     'rdbms ipc message',     'parallel dequeue wait',  'parallel query dequeue',     'virtual circuit',  'SQL*Net message from client', 'SQL*Net message to client', 'SQL*Net more data to client',  'client message',   'Null event',   'WMON goes to sleep',  'virtual circuit status',  'dispatcher timer',  'pipe get',  'slave wait', 'KXFX: execution message dequeue - Slaves','parallel query idle wait - Slaves', 'lock manager wait for remote message')  ORDER BY time_waited DESC) WHERE ROWNUM < 21